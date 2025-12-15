# TrailService Micro-service

Author: Low Jia Hui  
Module: MAL2018 Information Management & Retrieval

## Introduction
This repository contains the implementation of the TrailService micro-service developed for
CW2 of the MAL2018 Information Management & Retrieval - Assessment 2. The microservice is part
of a wider well-being Trail Application and provides RESTful CRUD operations
for managing trail data.

## Overview
TrailService is a RESTful micro-service that manages trail information, supporting
CRUD operations and integrating with an external Authenticator API for secure access control.

## Technologies
- Python (Flask + Connexion)
- Microsoft SQL Server (CW2 schema)
- pyodbc
- Marshmallow
- OpenAPI (Swagger)

## Features
- CRUD operations on Trails
- Integration with University of Plymouth Authenticator API
- Swagger API documentation
- JSON output for all endpoints

## Project Structure
- `app.py` - Main entry point
- `config.py` - Configure database credentials
- `models.py` - Trail data model & Marshmallow schema
- `trails.py` - CRUD API endpoints for Trails
- `auth.py` - Integration with the Authenticator API
- `swagger.yml` - API documentation
- `templates/home.html` - Home page template

## API Endpoints
- GET /trails
- GET /trails/{trail_id}
- POST /trails (Admin only)
- PUT /trails/{trail_id} (Admin only)
- DELETE /trails/{trail_id} (Admin only)

## How to Run the Application
1. Clone the repository
2. Configure database credentials in config.py
3. Install dependencies: `pip install -r requirements.txt`
4. Run: `python app.py`
5. Access:
   - Swagger UI: `http://localhost:8000/ui`
   - Home page: `http://localhost:8000/`

## GitHub Link
[https://github.com/lowjiahui0127-prog/MAL2018-CW2]

