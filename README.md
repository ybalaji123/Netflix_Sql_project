# Netflix Movies and TV Shows Data Analysis using SQL(SSMS)

![Netflix Logo](https://github.com/ybalaji123/Netflix_Sql_project/blob/main/Netflix_Logo1.png)

# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions. Used SSMS(SQL Server management Studio) 

# Process of Installing
The Below is help to install the SSMS(SQL Server management Studio)
- **Install Link:** [youtube link](https://youtu.be/iaUXjTL_F9U?si=d7W8YSLWPdoSDOK0)
  
# Objective
1) Analyze the distribution of content types (movies vs TV shows).
2) Identify the most common ratings for movies and TV shows.
3) List and analyze content based on release years, countries, and durations.
4) Explore and categorize content based on specific criteria and keywords.

# Dataset
The data for this project is sourced from the Kaggle dataset
- **Dataset Link:** [DataSet](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

# Schema
```sql
CREATE TABLE datanetflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
# Business Problems and Solutions

# 1. Count the Number of Movies vs TV Shows
```sql
select 
	type,
	count(*) as total_count
from datanetflix
group by type
```
**Objective:** Determine the distribution of content types on Netflix.
# 2. Find the Most Common Rating for Movies and TV Shows
```sql
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
```
**Objective:** Identify the most frequently occurring rating for each type of content.
# 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
select *
from datanetflix
where type = 'Movie' and release_year = '2020'
```
**Objective:** Retrieve all movies released in a specific year.
# 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT TOP 5
    LTRIM(RTRIM(value)) AS country,
    COUNT(*) AS total_content
FROM netflixdata
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL AND value != ''
GROUP BY LTRIM(RTRIM(value))
ORDER BY total_content DESC;
```
**Objective:** Identify the top 5 countries with the highest number of content items.
# 5. Identify the Longest Movie
```sql
SELECT *
FROM datanetflix
WHERE type = 'Movie'
ORDER BY 
    CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;
```
**Objective:** Find the movie with the longest duration.
# 6. Find Content Added in the Last 5 Years
```sql
SELECT *
FROM datanetflix
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());
```
**Objective:** Retrieve content added to Netflix in the last 5 years.
# 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select *	
from datanetflix
where director = 'Rajiv Chilaka'
```
**Objective:** List all content directed by 'Rajiv Chilaka'.
# 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM datanetflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;
```
**Objective:** Identify TV shows with more than 5 seasons.
# 9. Count the Number of Content Items in Each Genre
```sql
SELECT 
    LTRIM(RTRIM(value)) AS genre,
    COUNT(*) AS total_content
FROM datanetflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY LTRIM(RTRIM(value));
```
**Objective:** Count the number of content items in each genre.
# 10.Find each year and the average numbers of content release in India on netflix.
```sql
SELECT TOP 5
    YEAR(TRY_CONVERT(datetime, date_added, 107)) as year,
    COUNT(*) as content_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM datanetflix WHERE country = 'India')) as avg_content_percent
FROM datanetflix
WHERE country = 'India'
GROUP BY YEAR(TRY_CONVERT(datetime, date_added, 107))
ORDER BY content_count DESC;
```
**Objective:** Calculate and rank years by the average number of content releases by India.
# 11. List All Movies that are Documentaries
```sql
select *
from datanetflix
where listed_in like '%documentaries%'
```
**Objective:** Retrieve all movies classified as documentaries.
# 12. Find All Content Without a Director
```sql
select *
from datanetflix
where director is null
```
**Objective:** List content that does not have a director.
# 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT *
FROM datanetflix
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.
# 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT TOP 10
    LTRIM(RTRIM(value)) AS actor,
    COUNT(*) AS appearance_count
FROM datanetflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India'
GROUP BY LTRIM(RTRIM(value))
ORDER BY appearance_count DESC;
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.
# 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
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
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion
**Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
**Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
**Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

# Author - Zero Analyst
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
