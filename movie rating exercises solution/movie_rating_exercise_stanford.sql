-- Movie-Rating 

-- Link to the exercise:
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

-- q1
-- Find the titles of all movies directed by Steven Spielberg.

select title
from movie
where director='Steven Spielberg'; 


-- q2
-- Find all years that have a movie that received a rating of 4 or 5, 
and sort them in increasing order.

select year
from movie
where
mID in (select mID
	from rating
	where stars=4 OR stars=5
	)
order by year asc;


-- q3
-- Find the titles of all movies that have no ratings.

select title
from movie
where mID not in(select mID 
		from rating);


-- q4
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

select name from reviewer where rID in(select rID from rating where ratingDate is null);


-- q5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select r.name,m.title, rt.stars,ratingdate
from movie m,reviewer r, rating rt
where
rt.mID = m.mID
and
rt.rID = r.rID
order by name,title,stars;


-- q6
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

select name, title
from
(reviewer join Rating using (rID)),movie
where
movie.mid = rating.mid
and
exists
(select *
From Rating R2
where Rating.mid = R2.mid and Rating.rid = R2.rid and Rating.stars < R2.stars and R2.ratingdate > Rating.ratingdate);


-- q7
-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

select m.title,
       t.max_stars
from (select r.mID, 
       max(r.stars) as max_stars
      from Rating r
      where r.stars IS NOT NULL
      group by r.mID) t
join movie m
ON t.mID = m.mID
order by m.title;


-- q8
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select m.title, t.rating_spread
from
(select r.mid, (max(r.stars)-min(r.stars)) as rating_spread
from rating r
where r.stars is not null
group by r.mid) t
join
movie m
on t.mid=m.mid
order by t.rating_spread desc, m.title;


-- q9
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

select avg(t1.in_avg_before)-avg(t2.in_avg_after)
from (select m.year, avg(r.stars) as in_avg_before
from rating r, movie m 
where m.mid=r.mid and m.year<1980 
group by r.mid) t1,
(select m.year, avg(r.stars) as in_avg_after
from rating r, movie m 
where m.mid=r.mid and m.year>1980 
group by r.mid) t2;
