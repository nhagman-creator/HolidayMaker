-- 1) Registrera en kund med namn och kontaktuppgifter samt välja en befintlig kund inför en bokning
INSERT INTO customers (name, address, email, phone)
-- VALUES ('Emma Lindqvist', 'Södergatan 8, 211 34 Malmö, Sweden', 'emma.lindqvist@example.se', '+46 70-174 06 16');
VALUES (@name, @address, @email, @phone);

SELECT * from customers;


-- Query for searching for available rooms
-- 2A) Join hotels, rooms and amenities
SELECT
    *
FROM
    rooms                       AS r
INNER JOIN hotels               AS h
    ON h.id = r.hotel_id
LEFT JOIN hotels_x_amenities    AS ha
    ON ha.hotel_id = h.id
LEFT JOIN amenities             AS a
ON a.id = ha.amenity_id;


-- 2B) Create view
CREATE VIEW view_all_rooms AS
SELECT
    h.name                                                      AS hotel,
    h.street                                                    AS street,
    h.postal                                                    AS postal_code,
    h.municipality                                              AS municipality,
    r.id                                                        AS room_id,
    r.room_number                                               AS room,
    r.max_occupants                                             AS capacity,
    r.price                                                     AS price,
    GROUP_CONCAT(a.amenity ORDER BY a.amenity SEPARATOR ', ')   AS amenities,
    h.dist_to_beach_m                                           AS beach_m,
    h.dist_to_city_center_m                                     AS city_center_m,
    h.rating                                                    AS rating
FROM
    rooms AS r
INNER JOIN hotels AS h
ON h.id = r.hotel_id
LEFT JOIN hotels_x_amenities AS ha
ON ha.hotel_id = h.id
LEFT JOIN amenities AS a
ON a.id = ha.amenity_id
GROUP BY r.id;

-- 2C Parameterized queries to avoid sql-injection, to search for municipality, check-in and check-out date, and number of guests
SET @municipality  = 'Malmö';
SET @start_date    = '2026-12-10';
SET @end_date      = '2026-12-17';
SET @max_occupants = 1;

SELECT r.hotel, r.municipality, r.room, r.capacity, r.price
FROM view_all_rooms AS r
WHERE r.municipality = @municipality
AND r.capacity    >= @max_occupants
AND NOT EXISTS (
    SELECT 1
    FROM bookings AS b
    WHERE b.room_id    = r.room_id
    AND b.start_date < @end_date      -- existing booking starts before the new stay ends
    AND b.end_date   > @start_date    -- and ends after the new stay starts
    )
ORDER BY r.price;

-- 2D Add filter to query (I) pool (II) Restaurant (III) max dist beach (IV) max dist city-center
-- TO BE DONE


-- 3 Create a booking


-- 4 Show all bookings for one customer

-- 5 Change number of guests in a booking

-- 6 Cancel booking