-- *** Updater DS IC Tech Assessment *** ---


-- PROMPT: Generate a report that shows a daily breakdown of:

-- Move date 
-- Number of moves that happened on that date
-- Total revenue for these moves
-- Average revenue per user
-- Average revenue per revenue-generating user
-- Highest revenue-generating move (identified by its id)


-- UPDATER CASE STUDY
DROP TABLE IF EXISTS moves;
DROP TABLE IF EXISTS revenue;

CREATE TABLE moves(move_id INT
, user_id INT NOT NULL
, move_date DATE NOT NULL
, from_state VARCHAR(30) NOT NULL
, to_state VARCHAR(30) NOT NULL
);

-- revenue is aggregated for each move
CREATE TABLE revenue(move_id INT NOT NULL
, revenue_amount FLOAT NOT NULL);

INSERT INTO moves VALUES(123, 456, '2020-01-06', 'New York', 'Illinois');
INSERT INTO moves VALUES(429, 457, '2019-01-01', 'Florida', 'Indiana');
INSERT INTO moves VALUES(193, 458, '2022-03-08', 'New Mexico', 'Montana');
INSERT INTO moves VALUES(125, 456, '2020-01-06', 'Illinois', 'California');
INSERT INTO moves VALUES(499, 457, '2019-01-01', 'Indiana', 'Texas');
INSERT INTO moves VALUES(195, 458, '2022-03-08', 'Montana', 'Rhode Island');

INSERT INTO revenue VALUES(123, 263.7);
INSERT INTO revenue VALUES(429, 300.9);
INSERT INTO revenue VALUES(193, 220.7);
INSERT INTO revenue VALUES(125, 888.7);
INSERT INTO revenue VALUES(499, 350.9);
INSERT INTO revenue VALUES(195, 223.7);

COMMIT;

SELECT * FROM moves;

SELECT * FROM revenue;



SELECT mv.move_date 
, mv.user_id
, SUM(r.revenue_amount) AS total_revenue 
, COUNT(mv.move_id) AS numb_moves
FROM moves mv
JOIN revenue r ON mv.move_id = r.move_id
GROUP BY mv.move_date, mv.user_id;







