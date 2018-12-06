-- Movie Rating Modification

-- Link to the course:
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_mod/

-- q1
-- Add the reviewer Roger Ebert to your database, with an rID of 209.

insert into reviewer(rID, name) values(209, 'Roger Ebert');


-- q2
-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

insert into rating(rID, mID, stars)
select (select rID from reviewer where name='James Cameron'),mID, '5'
from movie;


-- q3
-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
-- (Update the existing tuples; don't insert new tuples.)

update movie
set year=year+25
where
mId in(select mID from (select mID, avg(stars) as avg_ from rating group by mID) where avg_>=4);


-- q4
-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

delete from rating
where
mId in(select mId from movie where year<1970 or year>2000) and stars<4;
