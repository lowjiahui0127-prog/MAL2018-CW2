CREATE SCHEMA CW2;
GO

/* ===============================
   Create Tables under CW2
   =============================== */

-- Table: User
CREATE TABLE CW2.[User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL DEFAULT 'user',
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);

-- Table: Location
CREATE TABLE CW2.Location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL
);
GO

-- Table: Trail
CREATE TABLE CW2.Trail (
    trail_id INT IDENTITY(1,1) PRIMARY KEY,
    trail_name VARCHAR(255) NOT NULL,
    description VARCHAR(2000) NULL,
    difficulty VARCHAR(50) NOT NULL CHECK (difficulty IN ('Easy','Moderate','Hard')),
    length DECIMAL(5,2) NOT NULL CHECK (Length > 0),
    elevation_gain INT NULL CHECK (elevation_gain >= 0),
    estimated_time VARCHAR(100) NULL,
    route_type VARCHAR(50) NOT NULL CHECK (route_type IN ('Out & Back','Loop','Point to point')),
    location_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (location_id) REFERENCES CW2.Location(location_id),
    FOREIGN KEY (user_id) REFERENCES CW2.[User](user_id)
);
GO

-- Table: Suitability_Type
CREATE TABLE CW2.Suitability_Type (
    suitability_id INT IDENTITY(1,1) PRIMARY KEY,
    suitability_name VARCHAR(100) NOT NULL
);
GO

-- Link Table: Trail_Suitability
CREATE TABLE CW2.Trail_Suitability (
    trail_id INT NOT NULL,
    suitability_id INT NOT NULL,
    PRIMARY KEY (trail_id, suitability_id),
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE,
    FOREIGN KEY (suitability_id) REFERENCES CW2.Suitability_Type(suitability_id)
);
GO

-- Table: Attraction_Type
CREATE TABLE CW2.Attraction_Type (
    attraction_id INT IDENTITY(1,1) PRIMARY KEY,
    attraction_name VARCHAR(100) NOT NULL
);
GO

-- Link Table: Trail_Attraction
CREATE TABLE CW2.Trail_Attraction (
    trail_id INT NOT NULL,
    attraction_id INT NOT NULL,
    PRIMARY KEY (trail_id, attraction_id),
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE,
    FOREIGN KEY (attraction_id) REFERENCES CW2.Attraction_Type(attraction_id)
);
GO

-- Table: TopSight_Type
CREATE TABLE CW2.TopSight_Type (
    topsight_id INT IDENTITY(1,1) PRIMARY KEY,
    topsight_name VARCHAR(200) NOT NULL
);
GO

-- Link Table: Trail_TopSight
CREATE TABLE CW2.Trail_TopSight (
    trail_id INT NOT NULL,
    topsight_id INT NOT NULL,
    PRIMARY KEY (trail_id, topsight_id),
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE,
    FOREIGN KEY (topsight_id) REFERENCES CW2.TopSight_Type(topsight_id)
);
GO

-- Table: Activity_Type
CREATE TABLE CW2.Activity_Type (
    activity_id INT IDENTITY(1,1) PRIMARY KEY,
    activity_name VARCHAR(100) NOT NULL
);
GO

-- Link Table: Trail_Activity
CREATE TABLE CW2.Trail_Activity (
    trail_id INT NOT NULL,
    activity_id INT NOT NULL,
    PRIMARY KEY (trail_id, activity_id),
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES CW2.Activity_Type(activity_id)
);
GO

-- Table: Trail_Point
CREATE TABLE CW2.Trail_Point (
    trail_point_id INT IDENTITY(1,1) PRIMARY KEY,
    trail_id INT NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NULL,
    sequence_number INT NOT NULL,
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE
);
GO

-- Table: Review
CREATE TABLE CW2.Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    trail_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(500) NULL,
    date_posted DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (trail_id) REFERENCES CW2.Trail(trail_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES CW2.[User](user_id)
);
GO

-- Table: Trail_Log
CREATE TABLE CW2.Trail_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    trail_id INT NOT NULL,
    added_by INT NOT NULL,
    added_at DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

/* ===============================
   CW2 Insert Demo Data
   =============================== */

-- Users
INSERT INTO CW2.[User] (user_name, email, role)
VALUES
('Ada Lovelace', 'grace@plymouth.ac.uk', 'admin'),
('Tim Berners-Lee', 'tim@plymouth.ac.uk', 'user'),
('Ada Lovelace', 'ada@plymouth.ac.uk', 'user');
GO

-- Locations
INSERT INTO CW2.Location (city, region, country)
VALUES
('Plymouth', 'Devon', 'England'),
('Exeter', 'Devon', 'England'),
('Dartmoor', 'Devon', 'England');
GO  

-- Trails
INSERT INTO CW2.Trail (trail_name, description, difficulty, length, elevation_gain, estimated_time, route_type, location_id, user_id)
VALUES 
(   
    'Plymbridge Circular', 
    'This is a gentle circular walk through ancient oak woodlands, beside the beautiful River Plym. Within the woods 
    are remains of the area’s industrial past and there are breathtaking views across the valley from the viaduct.', 
    'Easy', 
    5.00, 
    147, 
    '1h 45m', 
    'Loop', 
    1, 
    1
),
(   
    'Plymbridge Woods Family Cycle Trail', 
    'Enjoy this delightful trail, which follows the path of an old Great Western Railway track. The route begins from 
    Plymbridge Woods and takes you through a beautiful woodland area before opening into the stunning countryside.', 
    'Easy', 
    12.10, 
    340, 
    '1h 30m', 
    'Out & Back', 
    1, 
    2
),
(   
    'Drake Trail', 
    'Drake Trail is a 21-mile cycling and walking route connecting Plymouth and Tavistock, taking you along the edge of 
    Dartmoor National Park through wooded river valleys and open moorland and up past many areas of historical and natural significance.', 
    'Hard', 
    23.5, 
    688, 
    '7h 30m', 
    'Point to point', 
    3, 
    3
);
GO

-- Suitability Types
INSERT INTO CW2.Suitability_Type (suitability_name)
VALUES
('Dog-friendly'),
('Kid-friendly'),
('Wheelchair-friendly'),
('Paved'),
('Partially paved');
GO

-- Link Trail ↔ Suitability
INSERT INTO CW2.Trail_Suitability (trail_id, suitability_id)
VALUES
(1, 1),
(1, 2),
(1, 5),
(2, 2),
(2, 4),
(2, 5),
(3, 5);
GO

-- Attraction Types
INSERT INTO CW2.Attraction_Type (attraction_name)
VALUES
('Forests'),
('River'),
('Wildlife'),
('Views'),
('Historic sites'),
('Rail trails'),
('Waterfalls'),
('Caves');
GO

-- Link Trail ↔ Attraction
INSERT INTO CW2.Trail_Attraction (trail_id, attraction_id)
VALUES
(1, 1),  
(1, 2),  
(1, 3),  
(1, 4), 
(1, 6), 
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 4),
(3, 6);
GO

-- Top Sight Types
INSERT INTO CW2.TopSight_Type (topsight_name)
VALUES
('Plymbridge Bridge'),
('River Plym'),
('Peregrine Falcon viewing spot'),
('Falcon Watchpoint'),
('River Meavy'),
('Old Quarry Remains'),
('Plym Valley Viewpoint');
GO

-- Link Trail ↔ Top Sight
INSERT INTO CW2.Trail_TopSight (trail_id, topsight_id)
VALUES
(1, 2),  
(2, 2),
(2, 3),
(3, 2),
(3, 3),
(3, 5);
GO

-- Activity Types
INSERT INTO CW2.Activity_Type (activity_name)
VALUES
('Hiking'),
('Walking'),
('Running'),
('Cycling'),
('Birding'),
('Road biking'),
('Bike touring');
GO

-- Link Trail ↔ Activity
INSERT INTO CW2.Trail_Activity 
VALUES
(1, 1),  
(1, 2),  
(1, 3),  
(1, 5), 
(1, 7), 
(2, 6),
(2, 7),
(3, 1),
(3, 2),
(3, 3),
(3, 6);
GO

-- Trail Points
INSERT INTO CW2.Trail_Point (trail_id, latitude, longitude, sequence_number)
VALUES
(1, 50.403210, -4.123456, 1),
(1, 50.403900, -4.124300, 2),
(1, 50.404500, -4.124900, 3),
(2, 50.405200, -4.125500, 1),
(2, 50.404000, -4.122100, 2),
(2, 50.404900, -4.121800, 3),
(3, 50.405800, -4.120900, 1),
(3, 50.407200, -4.119500, 2),
(3, 50.408900, -4.118000, 3);
GO

-- Review
INSERT INTO CW2.Review (trail_id, user_id, rating, comment)
VALUES
(1, 1, 5, 'Beautiful forest walk with great wildlife.'),
(2, 2, 4, 'Lovely easy walk, good for families!'),
(2, 3, 4, 'Peaceful, scenic route by the river.'),
(3, 2, 5, 'Fantastic cycling trail with great views!!');
GO

/* ===============================
   Verify Tables and Data (CW2)
   =============================== */

SELECT * FROM CW2.[User];
SELECT * FROM CW2.Location;
SELECT * FROM CW2.Trail;
SELECT * FROM CW2.Suitability_Type;
SELECT * FROM CW2.Trail_Suitability;
SELECT * FROM CW2.Attraction_Type;
SELECT * FROM CW2.Trail_Attraction;
SELECT * FROM CW2.TopSight_Type;
SELECT * FROM CW2.Trail_TopSight;
SELECT * FROM CW2.Activity_Type;
SELECT * FROM CW2.Trail_Activity;
SELECT * FROM CW2.Trail_Point;
SELECT * FROM CW2.Review;
GO