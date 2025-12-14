/* ============================================
   CW2: Stored Procedure (Delete Trail)
   ============================================ */
CREATE PROCEDURE CW2.DeleteTrail
    @trail_id INT
AS
BEGIN
    DELETE FROM CW2.Trail WHERE trail_id = @trail_id;
END;
GO
