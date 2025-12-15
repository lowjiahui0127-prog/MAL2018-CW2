/* ==========================================
   Update View: CW2.Trail_View (CW2 scope only)
   ========================================== */
CREATE OR ALTER VIEW CW2.Trail_View AS
SELECT
    t.trail_id,
    t.trail_name,
    t.description,
    t.difficulty,
    t.length,
    t.elevation_gain,
    t.estimated_time,
    t.route_type,

    u.user_name AS owner_name,

    l.city,
    l.region,
    l.country,

    -- start point (first Trail_Point)
    (
      SELECT TOP 1 tp.latitude
      FROM CW2.Trail_Point tp
      WHERE tp.trail_id = t.trail_id
      ORDER BY tp.sequence_number ASC
    ) AS start_latitude,

    (
      SELECT TOP 1 tp.longitude
      FROM CW2.Trail_Point tp
      WHERE tp.trail_id = t.trail_id
      ORDER BY tp.sequence_number ASC
    ) AS start_longitude

FROM CW2.Trail t
JOIN CW2.[User] u 
    ON t.user_id = u.user_id
JOIN CW2.Location l 
    ON t.location_id = l.location_id;
GO
