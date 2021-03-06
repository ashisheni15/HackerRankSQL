--Asian Population
SELECT SUM(CT.POPULATION) FROM CITY CT, COUNTRY CN WHERE CT.COUNTRYCODE = CN.CODE AND CN.CONTINENT ='Asia';

--African Cities
SELECT CT.NAME FROM CITY CT, COUNTRY CN WHERE CT.COUNTRYCODE = CN.CODE AND CN.CONTINENT ='Africa';

--Average Population of Each Continent
SELECT CN.CONTINENT,FLOOR(AVG(CT.POPULATION)) FROM CITY CT, COUNTRY CN WHERE CT.COUNTRYCODE = CN.CODE GROUP BY CN.CONTINENT;

--The Report
SELECT
  CASE
    WHEN G.GRADE < 8 THEN NULL
    ELSE S.NAME
  END,
  G.GRADE,
  S.MARKS
FROM STUDENTS AS S
JOIN GRADES AS G
ON S.MARKS >= G.MIN_MARK AND S.MARKS <= G.MAX_MARK
ORDER BY G.GRADE DESC, S.NAME ASC;

--Top Competitors

SELECT S.HACKER_ID, H.NAME 
FROM HACKERS H, SUBMISSIONS S, DIFFICULTY D, CHALLENGES C
WHERE S.HACKER_ID = H.HACKER_ID
AND C.CHALLENGE_ID = S.CHALLENGE_ID
AND D.DIFFICULTY_LEVEL = C.DIFFICULTY_LEVEL
AND S.SCORE = D.SCORE
GROUP BY  S.HACKER_ID, H.NAME HAVING COUNT(S.HACKER_ID)>1 ORDER BY COUNT(S.HACKER_ID) DESC,HACKER_ID;

--Ollivander's Inventory
SELECT W.ID,WP.AGE,W.COINS_NEEDED, W.POWER FROM WANDS W, WANDS_PROPERTY WP
WHERE W.CODE =WP.CODE 
AND WP.IS_EVIL = 0
AND (W.POWER, W.CODE, W.COINS_NEEDED) IN (
        SELECT POWER, CODE, MIN(COINS_NEEDED)
          FROM WANDS
        GROUP BY POWER, CODE
       )
ORDER BY W.POWER DESC,WP.AGE DESC;

--Challenges
SELECT H.hacker_id,
       H.NAME,
       C.challenge_CREATED 
FROM Hackers H,
    (SELECT HACKER_ID,COUNT(challenge_id) challenge_CREATED FROM Challenges GROUP BY HACKER_ID) C
WHERE H.hacker_id = C.hacker_id
HAVING challenge_CREATED IN (SELECT MAX(challenge) 
                            FROM (SELECT HACKER_ID,COUNT(challenge_id) challenge 
                                    FROM Challenges 
                                    GROUP BY HACKER_ID) AS TBL
UNION 
SELECT challenge 
                            FROM (SELECT HACKER_ID,COUNT(challenge_id) challenge
                                    FROM Challenges 
                                    GROUP BY HACKER_ID) AS TBL
                                    GROUP BY challenge
                                    HAVING COUNT(challenge)=1)
ORDER BY C.challenge_CREATED DESC,H.hacker_id;

--Contest Leaderboard
SELECT HACKER_ID,NAME,SUM(SCORE_MAX) FROM (SELECT H.HACKER_ID,H.NAME, S.CHALLENGE_ID,MAX(S.SCORE) SCORE_MAX
FROM Hackers H, Submissions S 
WHERE H.HACKER_ID = S.HACKER_ID
AND S.SCORE >0
GROUP BY H.HACKER_ID,H.NAME, S.CHALLENGE_ID) 
GROUP BY HACKER_ID,NAME
ORDER BY SUM(SCORE_MAX) DESC,HACKER_ID;

