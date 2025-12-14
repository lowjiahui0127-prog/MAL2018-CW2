# auth.py
import requests
import pyodbc
from config import DB_CONFIG

AUTH_URL = "https://web.socem.plymouth.ac.uk/COMP2001/auth/api/users"

def authenticate_user(email: str, password: str) -> bool:
    """
    Validate user via Plymouth external authenticator.
    """
    if not email or not password:
        return False

    try:
        resp = requests.post(
            AUTH_URL,
            json={
                "email": email,
                "password": password
            },
            timeout=6
        )

        if resp.status_code != 200:
            return False

        data = resp.json()
        print("AUTH RESPONSE:", data) 

        if isinstance(data, list):
            if len(data) == 2 and data[0] == "Verified":
                return str(data[1]).lower() == "true"
            return False

        if isinstance(data, dict):
            verified = data.get("Verified") or data.get("verified")
            if isinstance(verified, str):
                return verified.lower() == "true"
            return verified is True

        return False

    except Exception as e:
        print("Authentication error:", e)
        return False

def get_local_user_role(email: str):
    """
    Fetch user role from CW2.[User].
    """
    conn_str = (
        f"DRIVER={{{DB_CONFIG['DRIVER']}}};"
        f"SERVER={DB_CONFIG['SERVER']};"
        f"DATABASE={DB_CONFIG['DATABASE']};"
        f"UID={DB_CONFIG['UID']};"
        f"PWD={DB_CONFIG['PWD']};"
        "TrustServerCertificate=yes;"
    )

    try:
        conn = pyodbc.connect(conn_str)
        cur = conn.cursor()
        cur.execute("SELECT role FROM CW2.[User] WHERE email = ?", email)
        row = cur.fetchone()
        conn.close()
        return row[0] if row else None
    except Exception as e:
        print("Local user lookup error:", e)
        return None
