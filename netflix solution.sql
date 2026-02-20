DROP TABLE I
CREATE TABLE netflix(
show_id varchar(10),
type varchar(10),
title varchar(150),
director varchar(210),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in	varchar(25),
description varchar(260)
)

-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

select type,count(*) as total_count
from netflix 
group by 1;


2. Find the most common rating for movies and TV shows
select type,rating 
from(
select
type,
rating,
count(*),
rank() over(partition by type order by  count(*) desc ) as ranking
from netflix
group by 1,2) as t1
where ranking=1;

3. List all movies released in a specific year (e.g., 2020)

select * 
from netflix 
where type='Movie' and release_year=2020;

4. Find the top 5 countries with the most content on Netflix

select 
unnest(string_to_array(country,',')) as new_country,
count (show_id ) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

5. Identify the longest movie

select * 
from netflix
where type='Movie'
and duration= (select max(duration) from netflix);

6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

8. List all TV shows with more than 5 seasons

select * 
from netflix
where type='TV Show'
and 
split_part(duration,' ',1)::numeric>5;
9. Count the number of content items in each genre

SELECT unnest(string_to_array(listed_in,',')) as genre, 
COUNT(*) AS genre_count
FROM netflix
GROUP BY listed_in
ORDER BY genre_count DESC;

10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!

SELECT release_year,
       COUNT(*) AS total_content,
       ROUND(COUNT(*) / 12.0, 2) AS avg_per_month
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_per_month DESC
LIMIT 5;

11. List all movies that are documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

12. Find all content without a director.

select * 
from netflix 
where director is null;

13. Find in how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(*) AS total_movies
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND release_year>=extract(year from current_date)-10;


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(casts,',')) as cast,count(*) as total_content
from netflix
where type='Movie' and 
country ilike '%India%'
group by 1
order by 2 desc
limit 10;

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE 
        WHEN description ILIKE '%kill%' 
             OR description ILIKE '%violence%' 
        THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY category;