-- *** Meta DS Leadership Tech Assessment *** ---


-- PROMPT: Calculate the same day acceptance rate over the last 7 days.


-- Definition: ACCEPTANCE RATE = accepted / total_requests
-- NULL suggests the friend request was not accepted


DROP TABLE IF EXISTS friending;

CREATE TABLE friending(sender_id INT
						, sent_date TEXT
						, receiver_id INT
						, accepted_date TEXT);
							
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(123, '2019-01-01', 432, '2019-02-03');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(032, '2019-01-01', 939, '2019-01-01');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(456, '2022-01-01', 879, '2022-01-01');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(244, '2022-03-01', 938, NULL);
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(244, '2022-03-03', 936, NULL);
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(456, '2022-03-08', 879, '2022-03-08');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(455, '2022-03-09', 879, '2022-03-09');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(222, '2022-03-07', 834, '2022-03-09');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(289, '2022-03-07', 889, '2022-03-09');
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(292, '2022-03-06', 811, NULL);
INSERT INTO friending(sender_id, sent_date, receiver_id, accepted_date) VALUES(292, '2022-03-06', 801, '2022-03-07');
COMMIT;

SELECT * FROM friending ORDER BY accepted_date;

SELECT COUNT(*) FROM friending;


SELECT COUNT(*) FROM friending F WHERE F.accepted_date IS NULL;

SELECT SUM(CASE WHEN f.accepted_date IS NULL THEN 1 ELSE 0 END)
FROM friending f;


SELECT COUNT(*) FROM friending F WHERE f.accepted_date IS NOT NULL;


SELECT COUNT(1)
FROM friending f
WHERE f.accepted_date = f.sent_date;


-- SOLUTION
SELECT f.sent_date
, COUNT(1) AS total_calls
, SUM(CASE WHEN f.accepted_date IS NULL THEN 1 ELSE 0 END) AS unaccepted_calls
, SUM(CASE WHEN f.accepted_date IS NOT NULL THEN 1 ELSE 0 END) AS accepted_calls
, (SUM(CASE WHEN f.accepted_date IS NOT NULL THEN 1 ELSE 0 END) / CAST(COUNT(1) AS FLOAT))*100 AS overall_acceptance_rate
, (SUM(CASE WHEN f.sent_date = f.accepted_date THEN 1 ELSE 0 END) / CAST(COUNT(1) AS FLOAT))*100 AS same_day_acceptance_rate
FROM friending f
WHERE (CAST(f.sent_date AS DATE) >= CURRENT_TIMESTAMP - interval '7 day')
GROUP BY f.sent_date
ORDER BY f.sent_date;



-- PERSONAL EXPLORATION --

-- overall daily acceptance rate
SELECT f.sent_date, COUNT(1) AS total_calls
, SUM(CASE WHEN f.accepted_date IS NULL THEN 1 ELSE 0 END) AS unaccepted_calls
, SUM(CASE WHEN f.accepted_date IS NOT NULL THEN 1 ELSE 0 END) AS accepted_calls
, (SUM(CASE WHEN f.accepted_date IS NOT NULL THEN 1 ELSE 0 END) / CAST(COUNT(1) AS FLOAT))*100 AS overall_acceptance_rate
FROM friending f
WHERE (CAST(f.sent_date AS DATE) >= CURRENT_TIMESTAMP - interval '7 day')
GROUP BY f.sent_date
ORDER BY f.sent_date;