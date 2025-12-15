# trails.py
import pyodbc
from flask import request, jsonify, make_response
from config import DB_CONFIG
from models import Trail, trail_schema, trails_schema
from auth import authenticate_user, get_local_user_role


# -------------------------------------------------
# Database connection helper
# -------------------------------------------------
def get_connection():
    conn_str = (
        f"DRIVER={{{DB_CONFIG['DRIVER']}}};"
        f"SERVER={DB_CONFIG['SERVER']};"
        f"DATABASE={DB_CONFIG['DATABASE']};"
        f"UID={DB_CONFIG['UID']};"
        f"PWD={DB_CONFIG['PWD']};"
        "TrustServerCertificate=yes;"
    )
    return pyodbc.connect(conn_str)


# -------------------------------------------------
# GET /trails
# Anyone can view trails (limited view)
# -------------------------------------------------
def read_all():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("EXEC CW2.GetAllTrails")
    rows = cur.fetchall()
    conn.close()

    trails = trails_schema.dump([
        Trail(
            trail_id=r.trail_id,
            trail_name=r.trail_name,
            description=r.description,
            difficulty=r.difficulty,
            length=float(r.length) if r.length else None,
            elevation_gain=r.elevation_gain,
            estimated_time=r.estimated_time,
            route_type=r.route_type,
            location_id=r.location_id,
            user_id=r.user_id,
            created_at=r.created_at
        )
        for r in rows
    ])

    return jsonify(trails), 200


# -------------------------------------------------
# GET /trails/{id}
# -------------------------------------------------
def read_one(trail_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("EXEC CW2.GetTrailByID ?", trail_id)
    row = cur.fetchone()

    if not row:
        conn.close()
        return make_response(jsonify({"error": "Trail not found"}), 404)

    # fetch trail points
    cur.execute("""
        SELECT latitude, longitude, sequence_number
        FROM CW2.Trail_Point
        WHERE trail_id = ?
        ORDER BY sequence_number
    """, trail_id)

    points = [
        {
            "latitude": p.latitude,
            "longitude": p.longitude,
            "sequence_number": p.sequence_number
        }
        for p in cur.fetchall()
    ]

    conn.close()

    trail = trail_schema.dump(Trail(
        trail_id=row.trail_id,
        trail_name=row.trail_name,
        description=row.description,
        difficulty=row.difficulty,
        length=float(row.length),
        elevation_gain=row.elevation_gain,
        estimated_time=row.estimated_time,
        route_type=row.route_type,
        location_id=row.location_id,
        user_id=row.user_id,
        created_at=row.created_at
    ))

    trail["trail_points"] = points

    return jsonify(trail), 200


# -------------------------------------------------
# POST /trails (Admin only)
# -------------------------------------------------
def create():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    # 1. Authentication
    if not authenticate_user(email, password):
        return make_response(jsonify({"error": "Invalid credentials"}), 401)

    # 2. Authorisation
    if get_local_user_role(email) != "admin":
        return make_response(jsonify({"error": "Forbidden - admin only"}), 403)

    # 3. Validate required fields
    required_fields = [
        "trail_name", "difficulty", "length",
        "route_type", "location_id", "user_id"
    ]

    for f in required_fields:
        if f not in data:
            return make_response(jsonify({"error": f"Missing field: {f}"}), 400)

    trail_points = data.get("trail_points", [])

    conn = get_connection()
    cur = conn.cursor()

    try:
        # 4. FK validation
        cur.execute("SELECT 1 FROM CW2.Location WHERE location_id = ?", data["location_id"])
        if not cur.fetchone():
            return make_response(jsonify({"error": "Location not found"}), 404)

        cur.execute("SELECT 1 FROM CW2.[User] WHERE user_id = ?", data["user_id"])
        if not cur.fetchone():
            return make_response(jsonify({"error": "User not found"}), 404)

        # 5. Insert Trail
        cur.execute("""
            EXEC CW2.InsertTrail ?, ?, ?, ?, ?, ?, ?, ?, ?
        """, (
            data["trail_name"],
            data.get("description"),
            data["difficulty"],
            data["length"],
            data.get("elevation_gain"),
            data.get("estimated_time"),
            data["route_type"],
            data["location_id"],
            data["user_id"]
        ))

        row = cur.fetchone()
        trail_id = int(row[0])

        # 6. Insert Trail Points
        for tp in trail_points:
            cur.execute("""
                INSERT INTO CW2.Trail_Point
                (trail_id, latitude, longitude, sequence_number)
                VALUES (?, ?, ?, ?)
            """, (
                trail_id,
                tp["latitude"],
                tp["longitude"],
                tp["sequence_number"]
            ))

        conn.commit()

        return jsonify({
            "message": "Trail created successfully",
            "trail_id": trail_id
        }), 201

    except Exception as e:
        conn.rollback()
        raise e

    finally:
        conn.close()


# -------------------------------------------------
# PUT /trails/{id} (Admin only)
# -------------------------------------------------
def update(trail_id):
    data = request.get_json()

    if not authenticate_user(data.get("email"), data.get("password")):
        return make_response(jsonify({"error": "Invalid credentials"}), 401)

    if get_local_user_role(data.get("email")) != "admin":
        return make_response(jsonify({"error": "Forbidden - admin only"}), 403)

    trail_points = data.get("trail_points", [])

    conn = get_connection()
    cur = conn.cursor()

    try:
        # check trail exists
        cur.execute("SELECT 1 FROM CW2.Trail WHERE trail_id = ?", trail_id)
        if not cur.fetchone():
            return make_response(jsonify({"error": "Trail not found"}), 404)

        # 1. update Trail
        cur.execute("""
            EXEC CW2.UpdateTrail ?, ?, ?, ?, ?, ?, ?, ?, ?
        """, (
            trail_id,
            data["trail_name"],
            data.get("description"),
            data["difficulty"],
            data["length"],
            data.get("elevation_gain"),
            data.get("estimated_time"),
            data["route_type"],
            data["location_id"]
        ))

        # 2. reset Trail_Point
        cur.execute(
            "DELETE FROM CW2.Trail_Point WHERE trail_id = ?",
            trail_id
        )

        # 3. re-insert points
        for tp in trail_points:
            cur.execute("""
                INSERT INTO CW2.Trail_Point
                (trail_id, latitude, longitude, sequence_number)
                VALUES (?, ?, ?, ?)
            """, (
                trail_id,
                tp["latitude"],
                tp["longitude"],
                tp["sequence_number"]
            ))

        conn.commit()
        return jsonify({"message": "Trail updated successfully"}), 200

    except Exception:
        conn.rollback()
        raise

    finally:
        conn.close()


# -------------------------------------------------
# DELETE /trails/{id} (Admin only)
# -------------------------------------------------
def delete(trail_id):
    data = request.get_json()

    if not authenticate_user(data.get("email"), data.get("password")):
        return make_response(jsonify({"error": "Unauthorized"}), 401)

    if get_local_user_role(data.get("email")) != "admin":
        return make_response(jsonify({"error": "Forbidden - admin only"}), 403)

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT 1 FROM CW2.Trail WHERE trail_id = ?", trail_id)
    if not cur.fetchone():
        conn.close()
        return make_response(jsonify({"error": "Trail not found"}), 404)

    cur.execute("EXEC CW2.DeleteTrail ?", trail_id)

    conn.commit()
    conn.close()

    return jsonify({"message": "Trail deleted"}), 200
