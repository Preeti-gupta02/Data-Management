/* 1. Write a SELECT statement that returns following columns from the Title table: genre, 
title, publisher, number_of_pages.  Then, run this statement to make sure it works correctly.
Add an ORDER BY clause to this statement that sorts the result set by number_of_pages in ascending order. 
Then, run this statement again to make sure it works correctly. This is a good way to build and test a statement, 
one clause at a time. */

SELECT genre, 
       title, 
       publisher, 
       number_of_pages 
FROM Title 
ORDER BY number_of_pages;

/* 2.Write a SELECT statement that returns one column from the Author table named author_full_name that combines the first_name and last_name columns.  
Leave out middle name for now.
Format this column with the first name, a space, and last name like this:
Michael Jordan
Sort the result set by last name in descending sequence.
Use the “IN” operator to return only the authors whose first name begins with letters of A, B, or C.*/

SELECT first_name || ' ' || last_name  AS author_full_name 
FROM Author 
WHERE first_name LIKE 'A%' OR first_name LIKE 'B%' OR first_name LIKE 'C%'
ORDER BY last_name DESC;


-- Another way to do this 

SELECT first_name || ' ' || last_name  AS author_full_name 
FROM Author 
WHERE lower(SUBSTR(first_name, 0, 1)) IN ('a', 'b', 'c', 'd')
ORDER BY last_name DESC;

        
/*3. Write a SELECT statement that returns these columns from the Checkouts patron_id, 
title_copy_id, date_out, due_back_date, and date_in. Return only the rows for checkouts 
that went out in Feb 2021.  That means to filter where only date_out between the beginning 
Feb 1st and Feb 28th.  Use the BETWEEN operator. Sort the result by date_in and the date_out 
so we can see which are in first and then which  are not in. */


SELECT patron_id, 
       title_copy_id, 
       date_out, 
       due_back_date, 
       date_in 
FROM Checkouts 
WHERE date_out BETWEEN TO_DATE('01-02-21') AND TO_DATE('28-02-21') 
ORDER BY date_in , date_out;

/*4.Create a duplicate of the previous query but this time update the WHERE clause to use only the 
following operators (<, >, <=, or >=). Keep the rest of the query the same.
*/
SELECT patron_id, 
       title_copy_id, 
       date_out, 
       due_back_date, 
       date_in 
FROM Checkouts 
WHERE date_out >= TO_DATE('01-02-21') AND date_out <= TO_DATE('28-02-21') 
ORDER BY date_in , date_out;


/* 5.Write a SELECT statement that returns these column names and data from the Checkouts table:	
checkout_id		The checkout_id column
title_copy_id	The title_copy_id column  
renewals_left	This is calculated as 2 minus the times_renewed.  Assign an alias of renewals_left
Use the ROWNUM pseudo column so the result set contains only the first 5 rows from the table.
Sort the result set by the column alias renewals_left in ascending order.
  */

SELECT checkout_id, 
       title_copy_id, 
       times_renewed - 2 AS renewals_left 
FROM Checkouts 
WHERE ROWNUM < 6 
ORDER BY renewals_left ;

/* 6.Write a SELECT statement that returns the title and genre from Title table and also a third column called “Book_Level”.  
The book level is calculated by dividing the number_of_pages by 100 and the rounding it to have 1 decimal.  
So a book that is around 100 pages would be a level 1, ea book that is 500 pages would be level 5, etc…  
Once you have this filter to only show books that are greater than a level 9 */

SELECT title, 
       genre, 
       ROUND(number_of_pages/100, 1) AS Book_Level 
FROM Title
WHERE ROUND(number_of_pages/100, 1) > 9;

/*7.Write a SELECT statement that returns these columns from the Author: first_name, middle_name, last_name. 
Return only rows for users that have a value in middle_name using a NULL operator. 
Sort by column positions 2 and then 3 in ascending order*/

SELECT first_name, 
       middle_name, 
       last_name 
FROM Author  
WHERE middle_name IS NOT NULL 
ORDER BY 2 , 3;

/*8.Using the DUAL table write a SELECT statement that uses SYSDATE function to create a row with these columns:
today_unformatted	The SYSDATE function unformatted
today_formatted	The SYSDATE function in this format: MM/DD/YYYY
This displays a number for the month, a number for the day, and a four-digit year. 
Use a FROM clause that specifies the Dual table. Hint: You will need to implement the TO_CHAR function to format the sysdate in the format designated above.
After you write this add the following columns to the row:
Days_Late	5
Late_fee	.25
Total_late_fees	5 * .25
Late_fees_until_lock	5-(5*.25).  This assumes that after you accrue $5 in late fees, your account locks
 
Your result table contains only one row.*/
SELECT 5  AS Days_Late,
       .25 AS Late_fee,
       5 * .25 Total_late_fees,
       5-(5*.25) Late_fees_until_lock     
FROM dual;


/*9.Write a query that returns a distinct list of genres form the title table sorted by genre ascending
*/

SELECT DISTINCT genre 
FROM TITLE 
ORDER BY genre;

/*10.Write a query that returns all the rows from Titles for books that contains the word ‘Bird’. 
The problem is that we don’t know if the word will be capitalized in the title or not so in your 
where clause use the LOWER() function to compare the lowercase version of title to filter only rows that contain the word ‘bird’
*/

SELECT *
FROM title 
WHERE lower(title) LIKE '%bird%';


