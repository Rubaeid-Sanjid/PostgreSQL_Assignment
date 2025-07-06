CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(80),
    region VARCHAR(80)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id),
    species_id INT REFERENCES species (species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(80),
    notes VARCHAR(200)
);

INSERT INTO rangers VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

INSERT INTO species VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings VALUES
(1, 1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(4, 1, 2, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);

-- Problem 1
INSERT INTO rangers (name, region) VALUES('Derek Fox', 'Coastal Plains');

-- Problem 2
SELECT count(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Problem 3
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- Problem 4
SELECT r.name, count(s.sighting_id) AS total_sightings FROM rangers r INNER JOIN sightings s ON r.ranger_id = s.ranger_id GROUP BY r.name;

-- Problem 5
SELECT common_name FROM species WHERE species_id NOT IN (SELECT DISTINCT species_id FROM sightings);

-- Problem 6
SELECT sp.common_name, s.sighting_time, r.name FROM sightings s JOIN species sp ON s.species_id = sp.species_id JOIN rangers r ON s.ranger_id = r.ranger_id ORDER BY s.sighting_time DESC LIMIT 2;

-- Problem 7
UPDATE species SET conservation_status = 'Historic' WHERE discovery_date < '1800-01-01'; 

-- Problem 8
SELECT sighting_id, 
       CASE 
           WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);
