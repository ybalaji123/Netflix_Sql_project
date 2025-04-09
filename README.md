# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/ybalaji123/Netflix_Sql_project/blob/main/Netflix_Logo1.png)

# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions. Used SSMS(SQL Server management Studio) 


# Objective
1) Analyze the distribution of content types (movies vs TV shows).
2) Identify the most common ratings for movies and TV shows.
3) List and analyze content based on release years, countries, and durations.
4) Explore and categorize content based on specific criteria and keywords.

# Dataset
The data for this project is sourced from the Kaggle dataset:
-#Dataset: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

#Schema
...sql

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
...
