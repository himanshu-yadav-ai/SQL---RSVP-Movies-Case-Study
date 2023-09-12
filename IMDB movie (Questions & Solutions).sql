USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*) AS "Total Rows"
FROM   genre;

SELECT Count(*) AS "Total Rows"
FROM   movie;

SELECT Count(*) AS "Total Rows"
FROM   names;

SELECT Count(*) AS "Total Rows"
FROM   ratings;

SELECT Count(*) AS "Total Rows"
FROM   role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS "ID Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS "Title Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS "Year Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS "DatePublished Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS "Duration Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS "Country Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS "WorldWide Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS "Language Column (NULL(1) or NOT(0)",
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS "Production Company Column (NULL(1) or NOT(0)"
FROM   movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year,
       Count(id) as number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year;

SELECT Month(date_published) month_num,
       Count(id) as number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(DISTINCT id) AS number_of_movies,
       year
FROM   movie
WHERE  country IN ('India','USA')
       AND year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre
FROM   genre,
       movie
WHERE  movie_id = id
GROUP  BY genre
ORDER  BY Count(id) DESC
LIMIT  1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre_movie
     AS (SELECT id,
                Count(genre)
         FROM   genre,
                movie
         WHERE  movie_id = id
         GROUP  BY id
         HAVING Count(genre) = 1)
SELECT Count(id)
FROM   one_genre_movie;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie,
       genre
WHERE  movie_id = id
GROUP  BY genre
ORDER  BY avg_duration DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_rank
     AS (SELECT genre,
                Count(id) AS movie_count,
                Rank()
			  OVER(ORDER BY Count(id) DESC) AS genre_rank
         FROM   genre,
                movie
         WHERE  movie_id = id
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = "Thriller";



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT Min(avg_rating) AS min_avg_rating,
       Max(avg_rating) AS max_avg_rating,
       Min(total_votes) AS min_total_votes,
       Max(total_votes) AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH avg_rating_analysis
     AS (SELECT m.title, r.avg_rating,
                Dense_rank() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id)
SELECT *
FROM   avg_rating_analysis
WHERE  movie_rank <= 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_analysis
     AS (SELECT m.production_company,
                Count(r.movie_id) AS movie_count,
                Dense_rank() OVER ( ORDER BY Count(r.movie_id) ) AS prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  r.avg_rating > 8
                AND m.production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   production_analysis;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       Count(m.id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.country LIKE '%USA%'
       AND m.year = 2017
       AND Month(m.date_published) = 3
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY Count(m.id) DESC;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.title LIKE 'The%'
       AND r.avg_rating > 8
ORDER  BY r.avg_rating;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT Count(m.id) AS movie_released,
       r.median_rating
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.median_rating = 8
       AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY r.median_rating;



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.country,
       Sum(r.total_votes) AS "Total Votes"
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.country IN ( 'Germany', 'Italy' )
GROUP  BY m.country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select
sum(case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genre AS
(
           SELECT     genre,
                      Count(g.movie_id) AS "Count of Movies"
           FROM       genre g
           INNER JOIN ratings r
           ON         r.movie_id = g.movie_id
           WHERE      r.avg_rating > 8
           GROUP BY   genre
           ORDER BY   Count(g.movie_id) DESC limit 3 ),
top_director AS
(
           SELECT     n.NAME AS "Director Name",
                      Count(d.movie_id) AS "Count of Movies",
                      Rank() OVER (ORDER BY Count(d.movie_id) DESC) AS "RANK of Director"
           FROM       director_mapping d
           INNER JOIN names n
           ON         n.id = d.name_id
           INNER JOIN genre g
           ON         g.movie_id = d.movie_id
           INNER JOIN ratings r
           ON         r.movie_id = g.movie_id
           INNER JOIN top_3_genre t3
           ON         t3.genre = g.genre
           WHERE      r.avg_rating > 8
           AND        g.genre IN (t3.genre)
           GROUP BY   n.NAME )
SELECT "Director Name",
       "Count of Movies"
FROM   top_director
WHERE  "RANK of Director" <=3 
LIMIT 3;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT n.name,
       Count(m.id) AS "Count of Movies"
FROM   names n
       INNER JOIN role_mapping r
               ON r.name_id = n.id
       INNER JOIN movie m
               ON m.id = r.movie_id
       INNER JOIN ratings rate
               ON rate.movie_id = m.id
WHERE  rate.median_rating >= 8
       AND r.category = 'actor'
GROUP  BY n.name
ORDER  BY Count(m.id) DESC
LIMIT  2;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT   production_company,
         Sum(total_votes),
         Dense_rank() OVER(ORDER BY Sum(total_votes) DESC) prod_comp_rank
FROM     movie M,
         ratings R
WHERE    m.id = r.movie_id
GROUP BY production_company
ORDER BY Sum(total_votes) DESC 
LIMIT 3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT N.NAME as actor_name,
       Sum(R.total_votes) as total_votes,
       Count(R.movie_id) as movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
       Rank() OVER( ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes), 2) DESC) AS actor_rank
FROM   ratings R,
       names N,
       movie M,
       role_mapping RM
WHERE  M.id = R.movie_id
       AND M.id = RM.movie_id
       AND RM.name_id = N.id
       AND RM.category = 'actor'
       AND M.country LIKE '%India%'
GROUP  BY actor_name
HAVING Count(R.movie_id) >= 5
ORDER  BY actor_avg_rating DESC,
          Sum(R.total_votes) DESC;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT N.NAME as actor_name,
       Sum(R.total_votes) as total_votes,
       Count(R.movie_id) as movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
       AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes), 2) DESC)
       AS
       actor_rank
FROM   ratings R,
       names N,
       movie M,
       role_mapping RM
WHERE  M.id = R.movie_id
       AND M.id = RM.movie_id
       AND RM.name_id = N.id
       AND RM.category = 'actress'
       AND M.country LIKE '%India%'
       AND M.languages LIKE '%Hindi%'
GROUP  BY actor_name
HAVING Count(R.movie_id) >= 3
ORDER  BY actor_avg_rating DESC,
          Sum(R.total_votes) DESC;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title as "Title",
       avg_rating as "Average Rating",
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS Classify
FROM   genre G,
       ratings R,
       movie M
WHERE  G.movie_id = M.id
       AND R.movie_id = M.id
       AND G.movie_id = R.movie_id
       AND G.genre = 'thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT G.genre AS genre,
       Round(Avg(M.duration),2),
       Sum(Avg(M.duration))
         OVER (ORDER BY G.genre) AS running_total_duration,
       Avg(Avg(M.duration))
         OVER (ORDER BY G.genre) AS moving_avg_duration
FROM   movie M,
       genre G
WHERE  M.id = G.movie_id
GROUP  BY G.genre;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre AS
(
         SELECT   genre,
                  Count(movie_id) movie_count
         FROM     genre
         GROUP BY genre
         ORDER BY movie_count DESC limit 3 ), top_movie_yearly AS
(
         SELECT   genre,
                  year,
                  title AS movie_name,
                  worlwide_gross_income,
                  Dense_rank() OVER(partition BY year ORDER BY worlwide_gross_income DESC)  as movie_rank
         FROM     genre,
                  movie
         WHERE    id = movie_id
         AND      genre IN
                  (
                         SELECT genre
                         FROM   top_genre) )
SELECT *
FROM   top_movie_yearly
WHERE  movie_rank<=5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT   production_company,
         Count(id) as movie_count,
         Rank() over(ORDER BY count(id) DESC) AS prod_comp_rank
FROM     movie,
         ratings
WHERE    id = movie_id
AND      position(',' IN languages)>0
AND      median_rating >= 8
AND      production_company IS NOT NULL
GROUP BY production_company
LIMIT    2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT   n.name AS actress_name,
         Sum(r.total_votes) as total_votes,
         Count(r.movie_id) AS movie_count,
         Avg(r.avg_rating) AS actress_avg_rating,
         Row_number() over(ORDER BY count(r.movie_id) DESC) as actress_rank
FROM     ratings r,
         role_mapping rm,
         names n,
         genre g
WHERE    r.movie_id = rm.movie_id
AND      rm.name_id = n.id
AND      g.movie_id = r.movie_id
AND      g.movie_id = rm.movie_id
AND      r.avg_rating>8
AND      category = 'actress'
AND      g.genre = 'Drama'
GROUP BY actress_name
LIMIT    3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_details
AS
  (
           SELECT   dm.name_id AS director_id,
                    n.name     AS director_name,
                    m.id       AS movie_id,
                    r.avg_rating,
                    r.total_votes,
                    m.duration,
                    m.date_published,
                    lead(m.date_published,1) over(partition BY dm.name_id ORDER BY date_published, m.id) AS next_movie_date
           FROM     movie m,
                    director_mapping dm,
                    ratings r,
                    names n
           WHERE    m.id = dm.movie_id
           AND      m.id = r.movie_id
           AND      dm.name_id = n.id ), 

director_details_date
AS
  (
         SELECT *,
                datediff(next_movie_date, date_published) AS next_movie_gap
         FROM   director_details)
  SELECT   director_id,
           director_name,
           count(movie_id)              AS number_of_movies,
           round(avg(next_movie_gap),2) AS avg_inter_movie_days,
           round(avg(avg_rating),2)     AS avg_rating,
           sum(total_votes)             AS total_votes,
           min(avg_rating)              AS min_rating,
           max(avg_rating)              AS max_rating,
           sum(duration)                AS total_duration
  FROM     director_details_date
  GROUP BY director_id
  ORDER BY number_of_movies DESC
  LIMIT    9;


