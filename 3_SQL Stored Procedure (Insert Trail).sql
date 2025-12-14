/* ============================================
   CW2: Stored Procedure (Insert Trail)
   ============================================ */
CREATE PROCEDURE CW2.InsertTrail
    @trail_name VARCHAR(255),
    @description VARCHAR(2000),
    @difficulty VARCHAR(50),
    @length DECIMAL(5,2),
    @elevation_gain INT,
    @estimated_time VARCHAR(100),
    @route_type VARCHAR(50),
    @location_id INT,
    @user_id INT
AS
BEGIN
    INSERT INTO CW2.Trail
        (trail_name, description, difficulty, length, elevation_gain, estimated_time, route_type, location_id, user_id)
    VALUES
        (@trail_name, @description, @difficulty, @length, @elevation_gain, @estimated_time, @route_type, @location_id, @user_id);
END;
GO
