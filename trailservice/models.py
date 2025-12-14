# models.py
import pytz
from datetime import datetime
from marshmallow_sqlalchemy import fields
from config import db, ma

class Trail(db.Model):
    __tablename__ = "Trail"
    __table_args__ = {"schema": "CW2"}

    trail_id = db.Column(db.Integer, primary_key=True)
    trail_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(2000))
    difficulty = db.Column(db.String(50), nullable=False)
    length = db.Column(db.Numeric(5,2), nullable=False)
    elevation_gain = db.Column(db.Integer)
    estimated_time = db.Column(db.String(100))
    route_type = db.Column(db.String(50), nullable=False)
    location_id = db.Column(db.Integer)
    user_id = db.Column(db.Integer)
    created_at = db.Column(
        db.DateTime,
        default=lambda: datetime.now(pytz.timezone('Asia/Kuala_Lumpur')),
        onupdate=lambda: datetime.now(pytz.timezone('Asia/Kuala_Lumpur'))
    )

class TrailSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Trail
        load_instance = True
        include_fk = True

trail_schema = TrailSchema()
trails_schema = TrailSchema(many=True)
