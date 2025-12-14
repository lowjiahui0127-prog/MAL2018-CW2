/* ============================================
   CW2: Stored Procedure (Update Trail)
   ============================================ */
CREATE PROCEDURE CW2.UpdateTrail
    @trail_id INT,
    @trail_name VARCHAR(255),
    @description VARCHAR(2000),
    @difficulty VARCHAR(50),
    @length DECIMAL(5,2),
    @elevation_gain INT,
    @estimated_time VARCHAR(100),
    @route_type VARCHAR(50),
    @location_id INT
AS
BEGIN
    UPDATE CW2.Trail
    SET 
        trail_name = @trail_name,
        description = @description,
        difficulty = @difficulty,
        length = @length,
        elevation_gain = @elevation_gain,
        estimated_time = @estimated_time,
        route_type = @route_type,
        location_id = @location_id
    WHERE trail_id = @trail_id;
END;
GO
