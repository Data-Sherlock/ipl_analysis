-- Top 10 batsmen based on past 3 years total runs scored.
select  batsmanName,sum(runs)as highest_runs_scored
from batting_summary 
group by batsmanName
order by highest_runs_scored desc
limit 10;


-- Top 10 batsmen based on past 3 years batting average. (min 60 balls faced in each season)

SELECT 
  batsmanName,round(sum(runs) / count(case dismissal_status when dismissal_status = 'not_out' then 0 when dismissal_status ='out' then 1 end),2) 
  AS batting_average
FROM batting_summary
where balls >= 60
GROUP BY batsmanName
order by batting_average desc
limit 10
;







-- Top 10 batsmen based on past 3 years strike rate (min 60 balls faced in each season)

select  batsmanName,round(avg(SR),2)as average_sr
from batting_summary 
where balls >= 60
group by batsmanName
order by average_sr desc
limit 10;


-- Top 5 batsmen based on past 3 years boundary % (fours and sixes)

SELECT
  batsmanName,
 round( ((sum(6s) * 6 + sum(4s) * 4) / (sum(runs) - (sum(6s) * 6 + sum(4s) * 4))) * 100,2) AS boundary_percentage
FROM batting_summary
GROUP BY batsmanName
HAVING sum(runs) > 1000  -- Minimum runs threshold
ORDER BY boundary_percentage DESC
LIMIT 5;


-- Top 10 bowlers based on past 3 years total wickets taken.


SELECT  bowlerName, sum(wickets) as total_wickets
 FROM bowling_summary
 group by bowlerName
 order by total_wickets desc
 limit 10;
 
 
 --  Top 10 bowlers based on past 3 years bowling average. (min 60 balls bowled ineach season)

select bowlerName, round(sum(runs)/sum(wickets),2 ) as bowling_avg 
from bowling_summary
group by bowlerName
having sum(overs) >= 10     -- 10 overs contains 60 balls 
order by bowling_avg desc
limit 10;



-- Top 10 bowlers based on past 3 years economy rate. (min 60 balls bowled in each season)

select bowlerName,round( sum(runs)/sum(overs),2)  as bowling_economy 
from bowling_summary
group by bowlerName
having sum(overs) >= 10     -- 10 overs contains 60 balls 
order by bowling_economy desc
limit 10;

--  Top 5 bowlers based on past 3 years dot ball %.


select bowlerName, round((sum(0s)/(sum(overs)* 6))* 100 ,2) as dot_percentages
from bowling_summary
group by bowlerName
order by dot_percentages desc
limit 5;

-- Top 4 teams based on past 3 years winning %.


WITH RankedTeams AS (
  SELECT
    team1 AS team,
    COUNT(CASE WHEN winner = team1 THEN 1 END) AS wins,
    COUNT(*) AS total_matches
  FROM match_summary
  GROUP BY team1

  UNION ALL

  SELECT
    team2 AS team,
    COUNT(CASE WHEN winner = team2 THEN 1 END) AS wins,
    COUNT(*) AS total_matches
  FROM match_summary
  GROUP BY team2
)
SELECT
  team,
  ROUND(CAST(wins AS FLOAT) / total_matches * 100, 2) AS winning_percentage
FROM RankedTeams
ORDER BY winning_percentage DESC
LIMIT 4;

-- Top 2 teams with the highest number of wins achieved by chasing targets over the past 3 years.

SELECT team1 AS team, COUNT(*) AS wins
FROM match_summary
WHERE winner = team1 AND margin > 0 
GROUP BY team1

UNION ALL

SELECT team2 AS team, COUNT(*) AS wins
FROM match_summary
WHERE winner = team2 AND margin < 0
GROUP BY team2

ORDER BY wins DESC
LIMIT 2;
