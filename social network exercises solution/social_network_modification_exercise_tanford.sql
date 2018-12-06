-- Social Network Modification Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_mod/

-- Question 1:
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from highschooler
where
grade='12';

-- Question 2:
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from likes
where
likes.id1 in (select friend.id2 from friend where friend.id1=likes.id2)
and
likes.id2 in (select l.id2 from likes l where l.id1=likes.id1)
and
likes.id1 not in (select l.id2 from likes l where l.id1=likes.id2);

-- Question 3:
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C.
-- Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a
-- bit challenging; congratulations if you get it right.)

insert into friend(id1, id2)
select distinct f1.id1 as id1, f3.id1 as id2
from friend f1, friend f2, friend f3
where 
f2.id1 in (select friend.id2 from friend where friend.id1 = f1.id1)
and 
f2.id1 in (select friend.id2 from friend where friend.id1 = f3.id1)
and
f3.id1 not in(select friend.id2 from friend where friend.id1 = f1.id1)
and
f1.id1<>f3.id1;
