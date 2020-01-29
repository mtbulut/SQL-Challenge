use sakila;
# getting the table actor.
select * from actor;
# 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor ;
# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name , ' ' , last_name) as "Actor Name" from actor;

