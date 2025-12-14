/* ============================================
   CW2: Stored Procedure (Get All Trails)
   ============================================ */
CREATE PROCEDURE CW2.GetAllTrails
AS
BEGIN
    SELECT * FROM CW2.Trail;
END;
GO
