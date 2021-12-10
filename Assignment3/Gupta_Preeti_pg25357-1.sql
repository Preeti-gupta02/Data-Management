/* Joins and multi-table SELECT problems:
1.Write a query that returns the first_name, last name, email, and accrued_fees of all patrons from the
“Northeast Central” branch.  Filter out any patrons with no accrued fees. Sort results to show the patrons 
with highest fees first. Hint on how to write this query and others in the future. Build step by step.
Start by writing a query that joins Location to Patron and pulls all columns.
Then add a WHERE to filter down to patrons from the right branch with accrued fees.  
Then last step is to pick the appropriate columns in your SELECT and add in the Sort (i.e. Order by).   
 */
 -- Since the branch name contains branch word at the end of every branch name: I am using LiKE operator instead of the 
 -- = , assuming that I am not aware of the way names are stored , similar can be done with = , just an  individual case.
 
 -- Join way of doing this:
 


SELECT patron.first_name, patron.last_name, patron.email, patron.accrued_fees 
FROM location INNER JOIN patron
ON location.branch_id = patron.primary_branch
WHERE lower(location.Branch_Name) LIKE 'northeast central%'
      AND patron.accrued_fees > 0
      ORDER BY patron.accrued_fees DESC;
 
 --- Subquery way of doing this
 SELECT branch_id 
 FROM Location 
 WHERE lower(Branch_Name) LIKE 'northeast central%';
 
SELECT first_name, last_name, email, accrued_fees 
FROM Patron 
WHERE primary_branch = ( SELECT branch_id FROM Location WHERE lower(Branch_Name) LIKE 'northeast central%')
       AND accrued_fees > 0
ORDER BY accrued_fees DESC;



/*  2.Write a query that joins the appropriate tables in order to show the title of a book,
number of pages, and the author’s full name.  Only include titles that are in ‘Book’ format (i.e. ‘B’) and
ignore others like Audiobooks or DVD.  Also only pull books that are of the ‘Fiction’ genre (i.e. FIC). 
I expected something like the following but with more rows. Sort results first by the author_name using the column
alias and then by title. FYI: 
If I don’t specify that the sort is in a certain order or in descending, you can assume it’s an ascending order sort. */


SELECT title.title as fiction_title,
       title.number_of_pages, 
       author.first_name ||' ' || COALESCE(author.middle_name, '') || ' ' || author.last_name AS author_name
FROM author
INNER JOIN Title_Author_Linking
ON Title_Author_Linking.author_id = author.author_id
INNER JOIN title
ON title.title_id = Title_Author_Linking.title_id
WHERE lower(title.format) ='b' 
      AND lower(title.genre) = 'fic'
ORDER BY author_name, title.title;
 
/*
3.Write a query that pulls Title, Format, Genre, and ISBN of all the titles that currently do not have holds.  
While there are ways to do this using a subquery, I’d like you to use an outer join to accomplish this to show 
you understand how to properly use them.  Sort results by genre and title ascending.
*/


SELECT title.title, title.format, title.genre, title.ISBN
FROM title
FULL OUTER JOIN Patron_Title_Holds
ON title.title_id = Patron_Title_Holds.title_id
WHERE Patron_Title_Holds.hold_id IS null
ORDER BY title.genre, title.title;



/*4.Write a query that generates results to show the title, publisher, number of pages, and 
genre of all titles that are either a book or e-book format (i.e. ‘B’, ‘E’). 
Please also include an additional column called “Reading_Level” that indicates the reading level
of the book which can be ‘College’, ‘High School’, or ‘Middle School’. 
The reading level is determined simply by the number of pages.
-If a book is more than 700 pages, its level is ‘College’
-If a book is more than 250 page but less than 700, its level is ‘High School’
-If a book is less than 250 pages, its level is ‘Middle School’*/

SELECT 'College' AS reading_level,
       title, 
       publisher, 
       number_of_pages,
       genre
       
FROM title
WHERE format IN ('B', 'E') AND number_of_pages >700
UNION 
SELECT 'High School' AS reading_level,
       title, 
       publisher, 
       number_of_pages,
       genre
       
FROM title
WHERE format IN ('B', 'E') AND number_of_pages <700 AND number_of_pages >250
UNION 
SELECT 'Middle School' AS reading_level,
       title, 
       publisher, 
       number_of_pages,
       genre  
FROM title
WHERE format IN ('B', 'E') AND number_of_pages <250
ORDER BY reading_level, title;



/*Summary Problems:
5.Write a query that pulls patrons and their associated checkouts. 
Filter records down to just the checkouts that are not flagged as “Late” 
(i.e. ignore is late_flag is ‘Y’).  Summarize the data to return just two columns named as follows:
Zip – the zip column from patron
Average_Accrued_Fees – the average of accrued_fees for each zip.  Round the results to nearest 2 decimals.
Order results by average_accrued_fee from highest to lowest
*/

SELECT patron.zip, ROUND(AVG(Accrued_Fees), 2) as Average_Accrued_Fees
FROM patron
INNER JOIN checkouts
ON checkouts.patron_id = patron.patron_id
WHERE checkouts.late_flag != 'Y'
GROUP BY patron.zip
ORDER BY Average_Accrued_Fees DESC;



/*6.Find all the titles that have more than 1 author and then return the title, 
genre, and author_count for that book.  Sort your results by genre descending and the title ascending.
You’ll need to find the count of authors for each title and then filter out titles that has author counts of 1. 
*/
  -- I AM Taking out the titel id of the books with more than one author and then finding title, genre and author count for thioe title ids




SELECT title, genre, author_count
FROM title 
INNER JOIN (SELECT title_id, count(author.author_id) as author_count
FROM Title_Author_Linking
INNER JOIN 
author
ON author.author_id = title_author_linking.author_id
WHERE lower(author.last_name) LIKE ('%phd%')
GROUP BY title_id) table_2
ON title.title_id = table_2.title_id
WHERE author_count > 1  
ORDER BY genre DESC, title ASC;


/*Subquery Problems:
7.Write a SELECT statement that answers this question: Which titles have a higher than average number of pages? 
i.e. Just find the books that have a number of pages greater than the average number of pages for all books.   
Return the title, publisher, number_of_pages, genre for each title that fit this criteria.
Sort the results by the genre ascending and then by number_of_pages decsending.*/


SELECT title,  publisher, number_of_pages, genre
FROM title
WHERE number_of_pages > (SELECT AVG(number_of_pages) FROM title)
ORDER BY genre ASC, number_of_pages DESC;




/* 8.Here’s a Real-World Business Scenario!  Lots of times you may to look at a list 
of values and figure out which values are not in another list.  So in this situation, 
the Library Member Outreach team would like to know all the Patron’s that currently 
do not have a phone on file with us. Write a SELECT statement that returns the first_name, 
last_name, and email from the Patron table for each patron that has a Patron record but does
not have a phone records on Patron_Phone. Sort final results by the last_name.  Hint:
Use a subquery that pulls a list of patron_ids from Patron_Phone that you then use as part of an
IN clause for a separate query from Patron.  
*/

SELECT first_name, 
       last_name,
       email 
FROM patron
WHERE patron_id NOT IN (SELECT patron_id FROM PATRON_PHONE)
ORDER BY last_name;



/*
9.Please write a checkout status report for patrons that have any checkouts.
The report should format the data to be more user-friendly and clear for volunteers to understand.  
It should return the following four columns:
PATRON – a combination of the patron’s first and last name
CHECKOUT_DUE_BACK – Concatenate text and the appropriate columns to return a record
for each checkout and when it’s due back. See examples below
RETURN_STATUS – If the checkout has not been returned (i.e. date_in is null) show 
“Not returned yet”, otherwise show “Returned”.
FEES – Concatenate the text and the patron’s accrued fees while formatting fees as a currency to match examples below
Sort by retruned_status and due_back_date. 
*/


SELECT  first_name || ' ' || last_name as patron,
'Checkout ' || checkout_id ||  ' due back on ' || to_char(due_back_date, 'dd-Mon-yy') 
as checkout_due_back,
CASE         
    WHEN (date_in IS NULL) THEN 'Not returned yet'        
    ELSE 'Returned'
END  
AS return_status , 
'Accrued fee total is: $' || accrued_fees as fees
FROM patron
INNER JOIN Checkouts
ON Checkouts.patron_id = patron.patron_id
ORDER BY return_status, due_back_date;


/*
10.Write a query that uses the appropriate string parsing functions to return 
the branch_id, a “District” column based on the first word in the branch_name,
and also divides the address into two columns called street number and street name. 
Street number is the first numbers on the address and everything that follows the 
first space is considered the street name.  Results should look something like the following but for all branches
*/

SELECT * FROM LOCATION ;

SELECT branch_id, 
SUBSTR(branch_name, 1, (INSTR(branch_name, ' ')-1)) AS District,
SUBSTR(Address, 1, (INSTR(Address, ' ') - 1)) AS street_number,
SUBSTR(Address, (INSTR(Address, ' ') + 1)) AS street_name
FROM LOCATION ;

/*
11.Write a single SELECT that returns the same results that the UNION query did on a #4 
above but this time use a CASE statement to dynamically change the reading_level column. 
Make sure your new query returns the same results as the union query. 
*/


SELECT title, publisher, number_of_pages, 
CASE         
    WHEN (number_of_pages >700) THEN 'College'        
    WHEN (number_of_pages <700 AND number_of_pages >250) THEN 'High School'
    ELSE 'Middle School'
END  
AS reading_level
FROM title
WHERE format IN ('B', 'E')
ORDER BY reading_level, title;



/*
12.Write a SELECT statement that pulls all books and their number of checkouts.  
Include a column called row_number that uses row_number function to create a row number. 
That means, do not use the rownum pseudo colomn that only works in the WHERE clause. 
Include all books, even ones that have no checkouts.  Results should show the following columns for all titles.
Popularity_Rank – Use dense_rank based on the count of distinct checkouts.
Title
Number_of_Checkouts – Count the distinct checkout_ids attributed to this title if there are any
Note: Since the library system is new at Guillory, they don’t have a lot of checkouts across all the times, so it’s quite possible that some many books will have the same number of checkouts in cases where the titles have only been checked out once.  That’s okay.  As times goes one and more checkouts occur, this report will become more helpful in identifying popular and unpopular titles.
Once you have your query running, as a final step sort results by number_of_checks descending then title ascending.

After you complete this query, make it an in-line subquery and select * from it like a table but only return row_number 58 like so to reveal one of Clint’s favorite books
Row_Number	Title	Number_of_Checkouts
*/

SELECT * FROM 
(SELECT  ROW_NUMBER() OVER
    (ORDER BY COUNT(DISTINCT checkouts.checkout_id) DESC) AS row_number,
title.title, COUNT(DISTINCT checkouts.checkout_id) AS number_of_checkouts
FROM title   
LEFT JOIN title_loc_linking  
ON title.title_id = title_loc_linking.title_id 
FULL OUTER JOIN checkouts 
ON title_loc_linking.title_copy_id = checkouts.title_copy_id
GROUP BY title.title
ORDER BY number_of_checkouts DESC, title.title)
WHERE row_number=58;





















