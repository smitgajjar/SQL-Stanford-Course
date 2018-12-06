-- SQL Stanford Social Network
-- Link to the course exercise: https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/

-- Question 1:
-- Find the names of all students who are friends with someone named Gabriel.

select h1.name
from highschooler as h1, highschooler as h2, friend as f
where h1.id = f.id1 and h2.id = f.id2 and h2.name = 'Gabriel';


-- Question 2:
-- For every student who likes someone 2 or more grades younger than themselves, return that student's
-- name and grade, and the name and grade of the student they like.

select h1.name, h1.grade, h2.name, h2.grade from highschooler h1, highschooler h2, likes l 
where 
(h1.id=l.id1
and h2.id=l.id2
and h1.grade>=(h2.grade + 2))
or
(h1.id=l.id2
and h2.id=l.id1
and h1.grade>=(h2.grade + 2));


-- Question 3:
-- For every pair of students who both like each other, return the name and grade of both students. Include
-- each pair only once, with the two names in alphabetical order.

select name1, grade1, name2, grade2 from (select h1.name as name1, h1.grade as grade1, h2.name as name2, h2.grade as grade2
from
highschooler h1, highschooler h2, likes l1, likes l2
where
h1.id=l1.id1
and
h2.id=l1.id2
and
h1.id=l2.id2
and
h2.id=l2.id1
group by
l1.id1)
where name1<name2;


-- Question 4:
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their
-- names and grades. Sort by grade, then by name within each grade.

select distinct h.name, h.grade
from highschooler h, highschooler h1, highschooler h2, likes l
where
(h.id not in(select id1 as id_1 from likes) and h.id not in(select id2 as id_2 from likes))
and (h1.id=l.id1 and h2.id=l.id2)
order by h.grade, h.name;


-- Question 5:
-- For every situation where student A likes student B, but we have no information about whom B likes (that is,
-- B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select h1.name, h1.grade, h2.name, h2.grade
from
highschooler h1, highschooler h2, likes l
where
h1.id=l.id1
and
h2.id=l.id2
and
h2.id not in(select id1 from likes);


-- Question 6:
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade,
-- then by name within each grade.

select distinct h1.name, h1.grade
from highschooler h1, highschooler h2, friend f
where
h1.id=f.id1
and
h2.id=f.id2
and
h1.id not in(select h1.id
from highschooler h1, highschooler h2, friend f
where
h1.id=f.id1
and
h2.id=f.id2
and h1.grade<>h2.grade)
order by h1.grade, h1.name;


-- Question 7:
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common
-- (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

select * from(select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from
highschooler h1, highschooler h2, highschooler h3, friend f, likes l
where
h1.id=l.id1
and
h2.id=l.id2
and
h1.id not in(select f.id2 from friend f where h2.id=f.id1)
and
h3.id in(select f.id2 from friend f where h2.id=f.id1)
and
h3.id in(select f.id2 from friend f where h1.id=f.id1));


-- Question 8:
-- Find the difference between the number of students in the school and the number of different first names.

select count(h.name)-count(distinct h.name) 
from highschooler h;


-- Question 9:
-- Find the name and grade of all students who are liked by more than one other student.

select distinct h1.name, h1.grade
from highschooler h1, likes l
where
(select count(l.id1) from likes l where h1.id=l.id2) > 1;
