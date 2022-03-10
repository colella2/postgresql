-- *** Meta DS IC Tech Assessment *** ---


-- PROMPT: How many users initiated a call with more than 2 people in the past 7 days?


DROP TABLE IF EXISTS video_calls;

CREATE TABLE video_calls(caller INT
						, recipient INT
						, ds TEXT
						, call_id INT
						, duration float)
							
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(123, 456, '2019-01-01', 4325, 864.4);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(032, 789, '2019-01-01', 9395, 263.7);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(456, 032, '2022-01-01', 0879, 22.0);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(244, 789, '2022-03-01', 9398, 263.7);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(459, 032, '2022-03-01', 0870, 22.0);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(244, 786, '2022-03-01', 9398, 263.7);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(459, 032, '2022-03-01', 0870, 22.0);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(244, 788, '2022-03-01', 9398, 263.7);
INSERT INTO video_calls(caller, recipient, ds, call_id, duration) VALUES(459, 189, '2022-03-01', 0870, 22.0);
COMMIT;

								
SELECT * FROM video_calls;

SELECT v.call_id, v.caller, v.recipient
FROM video_calls v
ORDER BY v.call_id ASC;

SELECT v.caller, COUNT(DISTINCT v.call_id) AS numb_calls
FROM video_calls v
GROUP BY v.caller
ORDER BY v.caller ASC;


-- DDL approach: didn't use
-- ALTER TABLE video_calls
-- ALTER COLUMN DS TYPE DATE USING ds::date;


-- SOLUTION
SELECT COUNT(DISTINCT x.caller)
FROM
	(SELECT v.call_id, v.caller, COUNT(DISTINCT v.recipient) as numb_recipients
	FROM video_calls v
	WHERE TO_DATE(v.ds, 'YYYY-MM-DD') >= NOW() - interval '7 DAY'
	GROUP BY v.call_id, v.caller
	HAVING COUNT(DISTINCT v.recipient) > 2) x;



-- PERSONAL EXPLORATION --

-- how many calls w/ more than 2 people were initiated by a user in the past 7 days
SELECT COUNT(1)
FROM
	(SELECT v.call_id, v.caller, COUNT(DISTINCT v.recipient) as numb_recipients
	FROM video_calls v
	WHERE TO_DATE(v.ds, 'YYYY-MM-DD') >= NOW() - interval '7 DAY'
	GROUP BY v.call_id, v.caller
	HAVING COUNT(DISTINCT v.recipient) > 2) x;
