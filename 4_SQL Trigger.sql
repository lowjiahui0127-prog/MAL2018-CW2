/* ============================================
   CW2 Trigger: Log New Trail Creation
   ============================================ */
CREATE TRIGGER CW2.Log_Trail_Insert
ON CW2.Trail
AFTER INSERT
AS
BEGIN
    INSERT INTO CW2.Trail_Log (trail_id, added_by, added_at)
    SELECT 
        i.trail_id,
        i.user_id,
        SYSUTCDATETIME()
    FROM inserted i;
END;
GO
