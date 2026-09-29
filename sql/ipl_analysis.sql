create database ipl_analysis;
use ipl_analysis;
select * from ipl_clean;

-- 1. total matches

select count(distinct id) as total_matches
from ipl_clean;

-- 2. total seasons

select count(distinct season) as total_seasons
from ipl_clean;

-- 3. which team has won more matches

select winner ,count(*) as wins
from ipl_clean
where winner is not null
group by winner 
order by wins desc;

-- 4. which venue hosted more matches

select venue, count(*) as no_of_times
from ipl_clean
where venue is not null
group by venue
order by no_of_times desc;

-- TOSS ANALYSIS
-- 5. what team chouse after winning toss

select toss_decision, count(*) as total_toss_wins
from ipl_clean
where toss_decision is not null
group by toss_decision;

-- DOES WINNING TOSS LEAD TO WINNING MATCH
-- 6. compare toss win with match winner
SELECT
    CASE
        WHEN toss_winner = winner THEN 'Toss Winner Won Match'
        ELSE 'Toss Winner Lost Match'
    END AS result,
    COUNT(*) AS total_matches
FROM ipl_clean
WHERE toss_winner IS NOT NULL
  AND winner IS NOT NULL
GROUP BY
    CASE
        WHEN toss_winner = winner THEN 'Toss Winner Won Match'
        ELSE 'Toss Winner Lost Match'
    END;
    
-- 7. whether the team batting first or chasing won more matches.
select result ,count(*) as total_matches
from ipl_clean
where result is not null
group by result
order by total_matches desc;

-- 8. team wins by season
-- How many matches did each team win in each IPL season?
select season,winner as team,count(*) as total_wins
from ipl_clean
where winner is not null
group by season,winner
order by season,total_wins desc;

-- 9. most player of the match award

select player_of_match,count(*) as no_of_matches
from ipl_clean
group by player_of_match
order by no_of_matches desc
limit 10;


-- 10. Teams With More Wins Than Average
SELECT
    winner AS team,
    COUNT(*) AS total_wins
FROM ipl_clean
WHERE winner IS NOT NULL
GROUP BY winner
HAVING COUNT(*) >
       (
           SELECT AVG(total_wins)
           FROM (
               SELECT COUNT(*) AS total_wins
               FROM ipl_clean
               WHERE winner IS NOT NULL
               GROUP BY winner
           ) AS team_wins
       )
ORDER BY total_wins DESC;

-- 11. Season-wise Team Ranking
WITH team_wins AS (
    SELECT season,winner AS team,COUNT(*) AS wins
    FROM ipl_clean
    WHERE winner IS NOT NULL
    GROUP BY season, winner)
SELECT
    season,
    team,
    wins,
    RANK() OVER (PARTITION BY season ORDER BY wins DESC) AS team_rank
FROM team_wins
ORDER BY season, team_rank;