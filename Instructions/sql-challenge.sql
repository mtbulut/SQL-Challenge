use sakila;
-- getting the table actor.
select * from actor;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor ;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name , ' ' , last_name) as "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name from actor
where last_name like "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order: 
select actor_id, first_name, last_name from actor
where last_name like "%LI%"
order by last_name,first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select * from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
--  so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).

ALTER TABLE actor
add COLUMN description blob;


-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
drop COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as count_last_name from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors
select last_name, count(last_name) as "count_last_name" from actor 
group by last_name
having count_last_name >1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name='HARPO'
WHERE last_name='WILLIAMS' and first_name = "GROUCHO";

select * from actor
where first_name = "HARPO" and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct
--  name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name='GROUCHO'
WHERE last_name='WILLIAMS' and first_name = "HARPO";

select * from actor
where first_name = "GROUCHO" and last_name = 'WILLIAMS';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
describe sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:

select s.first_name, s.last_name, a.address from staff s
left join address a on s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select p.staff_id, s.first_name, s.last_name, sum(p.amount) as total_amount ,p.payment_date from staff s
inner join payment p on s.staff_id = p.staff_id
where p.payment_date like '2005-08%'
group by p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(fa.actor_id) as count_actor from film f
inner join film_actor fa on f.film_id = fa.film_id
group by title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- select * from inventory;
select f.title, count(i.inventory_id) as number_films  from film f
inner join inventory i on f.film_id = i.inventory_id
where f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:


select * from payment;
select * from customer;
select c.first_name, c.last_name, sum(p.amount) as "Total Amount Paid" from customer c
inner join payment p on c.customer_id = p.customer_id
group by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles 
-- of movies starting with the letters K and Q whose language is English.
-- select * from film;
select f.title from film f
where f.language_id in (select language_id 
						from language 
                        where name = 'English' ) 
and (f.title like 'K%') or (f.title like 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor;
select a.actor_id, a.first_name, a.last_name from actor a
where actor_id in (select actor_id from film_actor where film_id in (select film_id from film where title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information.

select c.first_name, c.last_name, c.email,cl.country from customer c
join customer_list cl on c.customer_id = cl.ID
where cl.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as family films.


-- select * from film_list;
select fl.title, fl.category from film_list fl
where fl.category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(*) as num_rating from film f, inventory i, rental r
where f.film_id =i.film_id and r.inventory_id = i.inventory_id
group by i.film_id 
order by count(*) desc, f.title asc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.



-- 7g. Write a query to display for each store its store ID, city, and country.

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

-- 8b. How would you display the view that you created in 8a?

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
                




