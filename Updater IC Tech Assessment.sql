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
INSERT INTO moves VALUES(125, 456, '2021-01-09', 'Illinois', 'California');
INSERT INTO moves VALUES(499, 457, '2021-01-03', 'Indiana', 'Texas');
INSERT INTO moves VALUES(195, 458, '2022-04-08', 'Montana', 'Rhode Island');
INSERT INTO moves VALUES(211, 988, '2022-04-08', 'New Jersey', 'Florida');
INSERT INTO moves VALUES(212, 990, '2022-04-08', 'New Jersey', 'New York');
INSERT INTO moves VALUES(214, 991, '2022-04-08', 'New Jersey', 'New York');


INSERT INTO revenue VALUES(123, 263.7);
INSERT INTO revenue VALUES(429, 300.9);
INSERT INTO revenue VALUES(193, 220.7);
INSERT INTO revenue VALUES(125, 888.7);
INSERT INTO revenue VALUES(499, 350.9);
INSERT INTO revenue VALUES(195, 223.7);
INSERT INTO revenue VALUES(211, 789.6);
INSERT INTO revenue VALUES(212, 0.0);
INSERT INTO revenue VALUES(214, 789.6);

COMMIT;

SELECT * FROM moves;

SELECT * FROM revenue;


WITH
	num_moves AS 
				(SELECT move_date, COUNT(move_id) AS numb_moves FROM moves GROUP BY move_date),
	tot_rev AS
				(SELECT m.move_date, SUM(r.revenue_amount) AS tot_day_rev FROM moves m JOIN revenue r ON r.move_id = m.move_id GROUP BY m.move_date),
	avg_rev AS
				(SELECT m.move_date, SUM(r.revenue_amount) / COUNT(m.user_id) AS avg_rev_per_user FROM moves m JOIN revenue r ON r.move_id = m.move_id GROUP BY m.move_date),
	avg_rev_gen AS
				(SELECT m.move_date, SUM(r.revenue_amount) / COUNT(m.user_id) AS avg_rev_per_rev_user FROM moves m JOIN revenue r ON r.move_id = m.move_id WHERE r.revenue_amount > 0 GROUP BY m.move_date),
	high_rev_mv AS
				(SELECT rev_sort.move_date, rev_sort.move_id
				FROM
					(SELECT m.move_date
					, m.move_id
					, r.revenue_amount
					, RANK() OVER(PARTITION BY m.move_date ORDER BY r.revenue_amount DESC) as rnk
					FROM moves m JOIN revenue r ON r.move_id = m.move_id
					WHERE r.revenue_amount > 0) AS rev_sort
				WHERE rev_sort.rnk = 1),
	combo AS
		(SELECT num_moves.move_date, num_moves.numb_moves, tot_rev.tot_day_rev, avg_rev.avg_rev_per_user, avg_rev_gen.avg_rev_per_rev_user, high_rev_mv.move_id
		 FROM num_moves 
		 JOIN tot_rev ON num_moves.move_date = tot_rev.move_date
		 JOIN avg_rev ON num_moves.move_date = avg_rev.move_date
		 JOIN avg_rev_gen ON num_moves.move_date = avg_rev_gen.move_date
		 JOIN high_rev_mv ON num_moves.move_date = high_rev_mv.move_date)
				
SELECT * FROM combo cb ORDER BY cb.move_date;







