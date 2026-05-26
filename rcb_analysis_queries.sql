SELECT "Match_ID", "Match_Name", "Date", "Innings", "Batting_Team", "Bowling_Team", "Batter", "Bowler", "Runs ", "Total_Balls ", "Extras", "Boundary", "Overs", "Wickets", "Total_Runs "
FROM public.deliveries;

ALTER TABLE public.deliveries ALTER COLUMN "Date" TYPE date USING "Date"::date;


select * from public.deliveries d limit 10;

select count(*) from deliveries d ;

--> Serching That How RCB written.
select distinct "Batting_Team" from deliveries d order by "Batting_Team" ;

--> We are having same entries for team because of space so we trim that space.
UPDATE public.deliveries 
SET "Batting_Team"  = TRIM("Batting_Team");

--> Total Runs Of RCB.
select "Batting_Team", sum("Runs ") as "Teams_Total_Runs" 
from deliveries d 
where "Batting_Team" = 'RCB'
group by "Batting_Team";

--> Top RCB Batsmen
select distinct "Batting_Team", "Batter" from deliveries d 
where "Batting_Team" = 'RCB'
order by "Batting_Team" ;

--> We have multiple entries of batters so we are clearing that.
update public.deliveries 
set "Batter" = replace ("Batter", 'Kunal Pandya ', 'Krunal Pandya' );

update public.deliveries 
set "Batter" = replace ("Batter", 'Phillip Salt', 'Philip Salt' );

update public.deliveries 
set "Batter" = replace ("Batter", 'Devdat Paddikal', 'Devdutt Padikkal' );

update public.deliveries 
set "Batter" = trim("Batter"); 

--> RCB Batters Total Runs.
select "Batter", sum("Batsmen_Runs") as "Batsmen_Total_Runs" 
from deliveries d 
where "Batting_Team" = 'RCB'
group by "Batter" 
order by "Batsmen_Total_Runs" desc ;

--> RCB Total Extras while Batting.
select "Batting_Team" , sum("Extras") as "total_extras"  from deliveries d 
where "Batting_Team" = 'RCB'
group by "Batting_Team" ;

--> Top RCB Bowler.
select distinct "Bowler" from deliveries d 
where "Bowling_Team" = 'RCB';

update public.deliveries 
set "Bowler" = trim("Bowler");

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Abhinandan Sigh', 'Abhinandan Singh')

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Kunal Pandya', 'Krunal Pandya')

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Bhuvneswar Kumar', 'Bhuvneshwar Kumar')

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Bhuvneshvar Kumar', 'Bhuvneshwar Kumar')

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Josh Hazelewood', 'Josh Hazlewood')

update public.deliveries 
set "Bowler" = replace ("Bowler", 'Jos Hazlewood', 'Josh Hazlewood')


--> Extras Given By RCB Bowlers.
select "Bowling_Team" , sum("Extras") as "total_extras_bowler"  from deliveries d 
where "Bowling_Team" = 'RCB'
group by "Bowling_Team" ;

--> Total Runs Given By RCB.
select "Bowling_Team" ,sum("Runs ") as Total_Runs
from deliveries d 
where "Bowling_Team" = 'RCB'
group by "Bowling_Team" ;

--> Runs Given By Bowlers Of RCB.
select "Bowler" , sum("Runs ") as runs_bowler  
from deliveries d 
where "Bowling_Team" = 'RCB'
group by "Bowler" 
order by runs_bowler desc ;

--> Strike Rate Analysis
select "Batter" ,sum("Batsmen_Runs") as "Total_Runs" , count("Total_Balls ") as "Total_Ball_Faced", 
round(sum("Batsmen_Runs")/count("Total_Balls ")*100) as Strike_Rate 
from deliveries d 
where "Batting_Team" = 'RCB'
group by "Batter" 
order by strike_rate desc ;

--> Boundary Analysis.
--> Total Fours By RCB Batters.
select "Batter" ,
count("Boundary") as "Total_Fours"
from deliveries d
where "Boundary" = 4 and "Batting_Team" = 'RCB'
group by "Batter" 
order by "Total_Fours" desc ;

--> Total Sixes By RCB Batters.
select "Batter" ,
count("Boundary") as "Total_Sixes"
from deliveries d
where "Boundary" = 6 and "Batting_Team" = 'RCB'
group by "Batter" 
order by "Total_Sixes" desc ;

--> Dot Ball Analysis.
select "Batter", count("Runs ") as "dot_balls" 
from deliveries d
where "Batting_Team" = 'RCB' and "Runs " = 0
group by "Batter" 
order by dot_balls desc ;

--> PowerPlay Analysis. (Total Runs + Top Run Scorer + Boundries + Strikerate)
select "Batting_Team" , sum("Runs ") as Total_PowerPlay_Runs from deliveries d 
where "Overs" >= 0 and "Overs" <= 6 and "Batting_Team" = 'RCB' 
group by "Batting_Team" ;

select distinct "Batter" , 
sum("Batsmen_Runs") as PowerPlay_runs,
count("Total_Balls ") as "Total_Balls_Faced " ,
sum(case when "Boundary" = 4 then 1 else 0 end) as total_fours , 
sum(case when "Boundary" = 6 then 1 else 0 end) as total_sixes ,
sum(case when "Boundary" = 4 or "Boundary" = 6 then 1 else 0 end) as total_boundary,
round(sum("Batsmen_Runs")/count("Total_Balls ")*100) as Strike_Rate
from deliveries d 
where "Overs" >= 0 and "Overs" <= 6 and "Batting_Team" = 'RCB' 
group by "Batter"
order by PowerPlay_runs  desc ;

--> PowerPlay Analysis Bowlers (Total Runs + Top Bowler  + Ecconomy) 
select "Bowling_Team" , sum("Runs ") as PowerPlayRuns_Given 
from deliveries d 
where "Overs" >= 0 and "Overs" <= 6 and "Bowling_Team" = 'RCB'
group by "Bowling_Team" ;

select distinct "Bowler" ,
sum("Runs ") as PowerPlay_runs ,
count("Total_Balls ") as Total_Balls_Bowled,
sum(case when "Bowler_Wickets" >= 1 then 1 else 0 end) as total_wickets,
sum("Runs ")/(count("Total_Balls ")/6) as Ecconomy 
from deliveries d 
where "Overs" >= 0 and "Overs" <= 6 and "Bowling_Team" = 'RCB'
group by "Bowler" 
order by total_wickets desc;


--> Deathover Analysis (Total Runs + Top Run Scorer + Boundries + Strikerate)
select "Batting_Team" , sum("Runs ") as total_deathover_runs
from deliveries d 
where "Overs" >= 16 and "Overs" <= 20 and "Batting_Team" = 'RCB'
group by "Batting_Team" ;

select distinct "Batter" ,
sum("Batsmen_Runs") as DeathOver_runs ,
count("Total_Balls ") as "Total_Balls_Faced " ,
sum(case when "Boundary" = 4 then 1 else 0 end) as total_fours , 
sum(case when "Boundary" = 6 then 1 else 0 end) as total_sixes ,
sum(case when "Boundary" = 4 or "Boundary" = 6 then 1 else 0 end) as total_boundary,
round(sum("Batsmen_Runs")/count("Total_Balls ")*100) as Strike_Rate
from deliveries d 
where "Overs" >= 16 and "Overs" <= 20 and "Batting_Team" = 'RCB'
group by "Batter" 
order by DeathOver_runs desc ;

--> Death Over Analysis Bowlers (Total Runs + Top Bowler + Ecconomy) 
select "Bowling_Team" , sum("Runs ") as DeathOverRuns_Given 
from deliveries d 
where "Overs" >= 16 and "Overs" <= 20 and "Bowling_Team" = 'RCB'
group by "Bowling_Team" ;

select distinct "Bowler" ,
sum("Runs ") as DeathOverRuns_Given  ,
count("Total_Balls ") as Total_Balls_Bowled,
sum(case when "Bowler_Wickets" >= 1 then 1 else 0 end) as total_wickets

from deliveries d 
where "Overs" >= 16 and "Overs" <= 20 and "Bowling_Team" = 'RCB'
group by "Bowler" 
order by total_wickets desc ;
