create database Netflix

-- Data imported from excel, let see the full data usig below code 
select * from datanetflix


--1. Count the Number of Movies vs TV Shows
select 
	type,
	count(*) as total_count
from datanetflix
group by type


--2. Find the Most Common Rating for Movies and TV Shows
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM datanetflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
	

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select 
	*
from datanetflix
where type = 'Movie' and release_year = '2020'


--4. Find the Top 5 Countries with the Most Content on Netflix
SELECT TOP 5
    LTRIM(RTRIM(value)) AS country,
    COUNT(*) AS total_content
FROM netflixdata
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL AND value != ''
GROUP BY LTRIM(RTRIM(value))
ORDER BY total_content DESC;


-- 5. Identify the Longest Movie
SELECT *
FROM datanetflix
WHERE type = 'Movie'
ORDER BY 
    CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;


-- 6. Find Content Added in the Last 5 Years
SELECT *
FROM datanetflix
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select 
	*	
from datanetflix
where director = 'Rajiv Chilaka'

-- 8. List All TV Shows with More Than 5 Seasons
SELECT *
FROM datanetflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;

-- 9. Count the Number of Content Items in Each Genre
SELECT 
    LTRIM(RTRIM(value)) AS genre,
    COUNT(*) AS total_content
FROM datanetflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY LTRIM(RTRIM(value));


-- 10.Find each year and the average numbers of content release in India on netflix.
SELECT TOP 5
    YEAR(TRY_CONVERT(datetime, date_added, 107)) as year,
    COUNT(*) as content_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM datanetflix WHERE country = 'India')) as avg_content_percent
FROM datanetflix
WHERE country = 'India'
GROUP BY YEAR(TRY_CONVERT(datetime, date_added, 107))
ORDER BY content_count DESC;


-- 11. List All Movies that are Documentaries
select *
from datanetflix
where listed_in like '%documentaries%'


-- 12. Find All Content Without a Director
select *
from datanetflix
where director is null


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT *
FROM datanetflix
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10;


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT TOP 10
    LTRIM(RTRIM(value)) AS actor,
    COUNT(*) AS appearance_count
FROM datanetflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India'
GROUP BY LTRIM(RTRIM(value))
ORDER BY appearance_count DESC;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

with Categorigation as (
	select *,
		case 
			when description LIKE '%kill%' OR description LIKE '%violence%' then 'bad'
			else 'Good'
		end as CategorieContent
	from datanetflix
) 
select 
	CategorieContent,
	count(*) as count_of_Category
from Categorigation
group by CategorieContent




