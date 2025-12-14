/* ===============================
   Create View for Trail (CW2)
   =============================== */
CREATE VIEW CW2.Trail_View AS
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

    -- aggregated suitability types (comma separated)
    (
      SELECT STRING_AGG(s.suitability_name, ', ')
      FROM CW2.Trail_Suitability ts
      JOIN CW2.Suitability_Type s ON ts.suitability_id = s.suitability_id
      WHERE ts.trail_id = t.trail_id
    ) AS suitability_types,

    -- aggregated attraction types
    (
      SELECT STRING_AGG(a.attraction_name, ', ')
      FROM CW2.Trail_Attraction ta
      JOIN CW2.Attraction_Type a ON ta.attraction_id = a.attraction_id
      WHERE ta.trail_id = t.trail_id
    ) AS attraction_types,

    -- aggregated activity types
    (
      SELECT STRING_AGG(ac.activity_name, ', ')
      FROM CW2.Trail_Activity ta2
      JOIN CW2.Activity_Type ac ON ta2.activity_id = ac.activity_id
      WHERE ta2.trail_id = t.trail_id
    ) AS activity_types,

    -- aggregated top sights
    (
      SELECT STRING_AGG(ts2.topsight_name, ', ')
      FROM CW2.Trail_TopSight tts
      JOIN CW2.TopSight_Type ts2 ON tts.topsight_id = ts2.topsight_id
      WHERE tts.trail_id = t.trail_id
    ) AS top_sights,

    -- start latitude/longitude (first sequence_number)
    (
      SELECT TOP 1 latitude
      FROM CW2.Trail_Point tp
      WHERE tp.trail_id = t.trail_id
      ORDER BY tp.sequence_number ASC
    ) AS start_latitude,

    (
      SELECT TOP 1 longitude
      FROM CW2.Trail_Point tp
      WHERE tp.trail_id = t.trail_id
      ORDER BY tp.sequence_number ASC
    ) AS start_longitude

FROM CW2.Trail t
JOIN CW2.[User] u ON t.user_id = u.user_id
JOIN CW2.Location l ON t.location_id = l.location_id;
GO

SELECT * FROM CW2.Trail_View;
GO