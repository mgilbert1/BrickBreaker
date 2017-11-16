# SQLite Music

## Questions

2.1. ArtistID is said to be a "foreign key" because it references ArtistID in the Artist table. A column that references a column in
        another table is said to be a foreign key

2.2. An artist can have multiple albums, while an album has only one artist. It makes much more sense to match each album in Album
        with its artist in Artist by using the ArtistID rather than trying to match each artist with their unknown number of albums
        by adding AlbumID to Artist.

2.3. It is better to use an INTEGER like CustomerID as the PRIMARY KEY because an integer takes up just four bytes while an email
        takes up significantly more because it is a long string, so using an INTEGER is much more efficient.

2.4. SELECT SUM(Total) FROM Invoice

2.5. SELECT Name FROM Track WHERE TrackID IN (SELECT TrackID FROM InvoiceLine WHERE InvoiceID IN (SELECT InvoiceID FROM Invoice WHERE CustomerID = 50))

2.6. Create a new table called "Composer" that has columns "ComposerID" and "Name". Then replace the "Composer" column in Track with
        "ComposerID", which is a FOREIGN KEY that references "ComposerID" in Composer.

## Debrief

a. CS50 Lecture, CS50 Lecture Notes
    https://www.w3resource.com/sql/subqueries/nested-subqueries.php
    https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
    https://www.w3schools.com/sql/sql_count_avg_sum.asp
    https://stackoverflow.com/questions/2628159/sql-add-up-all-row-values-of-one-column-in-a-singletable


b. 60 minutes
