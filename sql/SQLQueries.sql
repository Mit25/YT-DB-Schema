-- Q1) List the most subscribed channel.

CREATE OR REPLACE VIEW no_subscription AS
	(SELECT count(subscribed_by.uid) as sum, subscribed_by.cid FROM subscribed_by GROUP BY subscribed_by.cid );

SELECT channel.cname FROM (SELECT R2.cid FROM((SELECT max(sum) as ans FROM  no_subscription ) as R1 JOIN no_subscription as R2 ON R1.ans=R2.sum)) as R3 NATURAL JOIN channel 
 
-- Q2) List videos viewed by all user in given time span (10 days).

SELECT distinct uid from seen_by where timestamp>'21-10-2020' and timestamp<'21-10-2021' order by uid

-- Q3) List the most trending videos depending upon likes and views of videos.

CREATE OR REPLACE VIEW trend AS
        (SELECT sum(r3.like1*0.5+r3.view1*0.5) as ans, r3.vid FROM (select * from((select vid, count(DISTINCT uid) as like1 from likedislike where likedislike=true group by vid) as R1 NATURAL JOIN(SELECT vid, count(DISTINCT uid) as view1 from seen_by group by vid) as R2)) AS r3 group by r3.vid)

SELECT trend.vid from ((SELECT max(trend.ans) as R1 from trend) as r join trend on trend.ans=r.R1)

-- Q4) List the most liked video from all channel.

SELECT cid,MAX(likecount) AS maxlikecount FROM ((SELECT vid, count(likedislike) as likecount from (video NATURAL JOIN likedislike)  group by vid ) AS R1 NATURAL JOIN video) GROUP BY cid ORDER BY cid

-- Q5) Find users who have seen videos having given tags.

SELECT uid from seen_by join tagvideo on seen_by.vid=tagvideo.vid EXCEPT (SELECT uid from ((SELECT uid,tag from seen_by cross join tagvideo where tagvideo.tag='sad') EXCEPT (SELECT uid,tag from seen_by join tagvideo on seen_by.vid=tagvideo.vid)) as r3)

-- Q6) List recommended videos depending upon subscription (videos uploaded in last 3 months) and tags of particular user. Order the recommended video by count of likes and views.

select r4.vid from (select distinct vid from (select vid from ((select tag from tagvideo join (select vid from seen_by where uid=35) as r1 on tagvideo.vid=r1.vid) as r2 join tagvideo on r2.tag=tagvideo.tag) as r3) as r4 natural join video where video.timestamp>'2014-6-1') as r4 join trend on trend.vid=r4.vid order by trend.ans

-- Q7) List a video liked by maximum female users.

SELECT vid,count(uid) FROM (SELECT * FROM "user" WHERE gender='F') AS R1 NATURAL JOIN likedislike WHERE likedislike=true GROUP BY vid ORDER BY vid



-- Q8) List the videos liked by all users.

select vid from (select vid from likedislike where likedislike=true) as r3 except (select vid from (select uid,vid from "user" cross  join (select vid from likedislike where likedislike=true) AS r2 except (select uid,vid from likedislike where likedislike=true)) as r1) order by vid

-- Q9) List trending videos for users of particular age group (age from 31 Dec 2022).  

CREATE OR REPLACE VIEW trend1 AS
(SELECT vid, count(uid) AS likecount from (SELECT vid from seen_by NATURAL JOIN "user" where dob<'2006-1-1' AND dob>'2000-1-1') AS R1 NATURAL JOIN likedislike where likedislike=true group by vid)

CREATE OR REPLACE VIEW trend2 AS
(SELECT vid, count(uid) AS viewcount from (SELECT vid from seen_by NATURAL JOIN "user" where dob<'2006-1-1' AND dob>'2000-1-1')AS R2 NATURAL JOIN seen_by group by vid)
SELECT vid,sum(likecount*0.5+viewcount*0.5) as rank from trend1 NATURAL JOIN trend2 group by vid ORDER BY rank

-- Q10) List most viewed advertisement in Mexico and United States.

SELECT advid,count(uid)as adClick from pop NATURAL JOIN (SELECT * from "user" where country='Mexico' OR country='United States') as R1 group by advid ORDER BY adClick

-- Q11) Most profit making video during Diwali of 2020.

SELECT vid,sum(costperview)AS profit from Advertisement NATURAL JOIN (SELECT * from pop where timestamp>'2020-10-1' and timestamp<'2020-11-30') AS R1 group by vid ORDER BY profit

-- Q12) Calculate revenue generated for each channel specifically.

SELECT sum(rev) as revenue,cid from (select r1.count*costperview as rev ,ad.advid,cid from (select count(uid) as count,advid,cid from video join pop on video.vid=pop.vid group by advid,cid) as r1 join Advertisement as ad on r1.advid=ad.advid) as r2 group by r2.cid order by r2.cid

-- Q13) List videos, having zero comment and number of likes>0 from given set of users.

(select distinct vid from video except (select vid from comment_by where uid>=17 and uid<=18))INTERSECT (select vid from likedislike where likedislike=true except	(select  vid from (	select * from ( (select uid from "user" where (uid>=17 and uid<=18) ) as p cross join (select vid from likedislike where likedislike=true) as r1) as w except (select uid,vid from likedislike where likedislike=true AND uid>=17 and uid<=18) ) as r3))