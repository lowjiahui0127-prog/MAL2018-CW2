/* ============================================
   CW2: Stored Procedure (Get Trail By ID)
   ============================================ */
CREATE PROCEDURE CW2.GetTrailByID
    @trail_id INT
AS
BEGIN
    SELECT * FROM CW2.Trail WHERE trail_id = @trail_id;
END;
GO

