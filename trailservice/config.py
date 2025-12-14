# config.py
import pathlib
import connexion
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow


basedir = pathlib.Path(__file__).parent.resolve()
connex_app = connexion.App(__name__, specification_dir=basedir)

app = connex_app.app
app.config["SQLALCHEMY_DATABASE_URI"] = (
    "mssql+pyodbc:///?odbc_connect="
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=MAL2018DB;"
    "UID=SA;"
    "PWD=YourStrong!Passw0rd;"
    "TrustServerCertificate=yes;"
    "Encrypt=yes;"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
ma = Marshmallow(app)

# Provide DB config for pyodbc calls
DB_CONFIG = {
    "DRIVER": "ODBC Driver 18 for SQL Server",
    "SERVER": "localhost",
    "DATABASE": "MAL2018DB",
    "UID": "SA",
    "PWD": "YourStrong!Passw0rd"
}