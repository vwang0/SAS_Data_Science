/* Chapter 4 */

/* Section 4.2 */

/* First Program */

DATA 'c:\MySASLib\style';
   INFILE 'c:\MyRawData\Artists.dat';
   INPUT Name $ 1-21 Genre $ 23-40 Origin $ 42;
RUN;
/* Second Program */

PROC PRINT DATA = 'c:\MySASLib\style';
   WHERE Genre = 'Impressionism';
   TITLE 'Major Impressionist Painters';
   FOOTNOTE 'F = France N = Netherlands U = US';
RUN;

/* Section 4.3 */

/* Program */

DATA marine;
   INFILE 'c:\MyRawData\Lengths.dat';
   INPUT Name $ Family $ Length @@;
RUN;
* Sort the data;
PROC SORT DATA = marine OUT = seasort NODUPKEY;
   BY Family DESCENDING Length;
PROC PRINT DATA = seasort;
   TITLE 'Whales and Sharks';
RUN;


/* Section 4.4 */

/* Program */

DATA sales;    
   INFILE 'c:\MyRawData\Candy.dat';    
   INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. CandyType $
      Quantity;
   Profit = Quantity * 1.25;
PROC SORT DATA = sales;
   BY Class;
PROC PRINT DATA = sales;
   BY Class;
   SUM Profit;
   VAR Name DateReturned CandyType Profit;
   TITLE 'Candy Sales for Field Trip by Class';
RUN;

/* Section 4.5 */

/* Program */

DATA sales;    
   INFILE 'c:\MyRawData\Candy.dat';    
   INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. CandyType $
         Quantity;    
   Profit = Quantity * 1.25; 
PROC PRINT DATA = sales;    
VAR Name DateReturned CandyType Profit;
   FORMAT DateReturned DATE9. Profit DOLLAR6.2;
   TITLE 'Candy Sale Data Using Formats';
RUN;


/* Section 4.7 */

/* Program */

DATA carsurvey;    
   INFILE 'c:\MyRawData\Cars.dat';
   INPUT Age Sex Income Color $;
PROC FORMAT;
   VALUE gender 1 = 'Male'
                2 = 'Female';
   VALUE agegroup 13 -< 20 = 'Teen'
                  20 -< 65 = 'Adult'
                  65 - HIGH = 'Senior';
   VALUE $col  'W' = 'Moon White'
               'B' = 'Sky Blue'
               'Y' = 'Sunburst Yellow'
               'G' = 'Rain Cloud Gray';
* Print data using user-defined and standard (DOLLAR8.) formats;
PROC PRINT DATA = carsurvey;
   FORMAT Sex gender. Age agegroup. Color $col. Income DOLLAR8.;
   TITLE 'Survey Results Printed with User-Defined Formats';
RUN;


/* Section 4.8 */

/* Program */

* Write a report with FILE and PUT statements;
DATA _NULL_;
   INFILE 'c:\MyRawData\Candy.dat';
   INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10. 
         CandyType $ Quantity;
   Profit = Quantity * 1.25;
   FILE 'c:\MyRawData\Student.txt' PRINT;
   TITLE;
   PUT @5 'Candy sales report for ' Name 'from classroom ' Class
     // @5 'Congratulations!  You sold ' Quantity 'boxes of candy'
     / @5 'and earned ' Profit DOLLAR6.2 ' for our field trip.';
   PUT _PAGE_;
RUN;

/* Section 4.9 */

/* Program */

DATA sales;    
   INFILE 'c:\MyRawData\Flowers.dat';    
   INPUT CustomerID $ @9 SaleDate MMDDYY10. Petunia SnapDragon
         Marigold;    
   Month = MONTH(SaleDate); 
PROC SORT DATA = sales;    
   BY Month; 

* Calculate means by Month for flower sales;
PROC MEANS DATA = sales;    
   BY Month;    
   VAR Petunia SnapDragon Marigold;
   TITLE 'Summary of Flower Sales by Month';
RUN;



/* Section 4.10 */
/* Program */

DATA sales;    
   INFILE 'c:\MyRawData\Flowers.dat';
   INPUT CustomerID $ @9 SaleDate MMDDYY10. Petunia SnapDragon Marigold;
PROC SORT DATA = sales;
   BY CustomerID;

* Calculate means by CustomerID, output sum and mean to new data set;
PROC MEANS NOPRINT DATA = sales;
   BY CustomerID;
   VAR Petunia SnapDragon Marigold;
   OUTPUT OUT = totals  MEAN(Petunia SnapDragon Marigold) =
          MeanPetunia MeanSnapDragon MeanMarigold
      SUM(Petunia SnapDragon Marigold) = Petunia SnapDragon Marigold;
PROC PRINT DATA = totals;
   TITLE 'Sum of Flower Data over Customer ID';
   FORMAT MeanPetunia MeanSnapDragon MeanMarigold 3.;
RUN;

/* Section 4.11 */

/* Program */

DATA orders;
   INFILE '/home/u49596266/little_sas_book/Coffee.dat';
   INPUT Coffee $ Window $ @@;

* Print tables for Window and Window by Coffee;
PROC FREQ DATA = orders;
   TABLES Window  Window * Coffee;
   RUN;

/* Section 4.12 */

/* Program */

DATA boats;
   INFILE '/home/u49596266/little_sas_book/Boats.dat';
   INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 
      Price 32-36;
RUN;

* Tabulations with three dimensions;
PROC TABULATE DATA = boats;
   CLASS Port Locomotion Type;
   TABLE Port, Locomotion, Type;
   TITLE 'Number of Boats by Port, Locomotion, and Type';
RUN;

/* Section 4.13 */
/* Program */

DATA boats;
   INFILE '/home/u49596266/little_sas_book/Boats.dat';
   INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 
      Price 32-36;
RUN;

* Tabulations with two dimensions and statistics;
PROC TABULATE DATA = boats;
   CLASS Locomotion Type;
   VAR Price;
   TABLE Locomotion ALL, MEAN*Price*(Type ALL);
   TITLE 'Mean Price by Locomotion and Type';
RUN;
PROC TABULATE DATA = boats;
   CLASS Locomotion Type;
   VAR Price;
   TABLE MEAN*Price*(Locomotion ALL), Type ALL;
   TITLE 'Mean Price by Locomotion and Type';
RUN;
/* Section 4.14 */
/* Program */

DATA boats;
   INFILE 'c:\MyRawData\Boats.dat';
   INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 
      Price 32-36;
RUN;

* PROC TABULATE report with options;
PROC TABULATE DATA = boats FORMAT=DOLLAR9.2;
   CLASS Locomotion Type;
   VAR Price;
   TABLE Locomotion ALL, MEAN*Price*(Type ALL)
      /BOX='Full Day Excursions' MISSTEXT='none';
   TITLE;
RUN;


/* Section 4.15 */
/* Program */

DATA boats;
   INFILE '/home/u49596266/little_sas_book/Boats.dat';
   INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 
      Price 32-36;
RUN;

* Changing headers;
PROC FORMAT;
   VALUE $typ  'cat' = 'catamaran'
               'sch' = 'schooner'
               'yac' = 'yacht';
RUN;
PROC TABULATE DATA = boats FORMAT=DOLLAR9.2;
   CLASS Locomotion Type;
   VAR Price;
   FORMAT Type $typ.;
   TABLE Locomotion='' ALL, 
      MEAN=''*Price='Mean Price by Type of Boat'*(Type='' ALL)
      /BOX='Full Day Excursions' MISSTEXT='none';
   TITLE;
RUN;

/* Section 4.16 */

/* Program */
DATA boats;
   INFILE '/home/u49596266/little_sas_book/Boats2.dat';
   INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 
      Price 32-36 Length 38-40;
RUN;

* Using the FORMAT= option in the TABLE statement;
PROC TABULATE DATA = boats;
   CLASS Locomotion Type;
   VAR Price Length;
   TABLE Locomotion ALL, 
      MEAN * (Price*FORMAT=DOLLAR6.2 Length*FORMAT=6.0) * (Type ALL);
   TITLE 'Price and Length by Type of Boat';
RUN;
 

/* Section 4.17 */

/* Program.dat */

DATA natparks;
   INFILE 'c:\MyRawData\Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   TITLE 'Report with Character and Numeric Variables';
RUN;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Museums Camping;
   TITLE 'Report with Only Numeric Variables';
RUN;

/* Section 4.18 */
/* Program */

DATA natparks;
   INFILE '/home/u49596266/little_sas_book/Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

* PROC REPORT with ORDER variable, MISSING option, and column header;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE MISSING;
   COLUMN Region Name Museums Camping;
   DEFINE Region / ORDER;
   DEFINE Camping / ANALYSIS 'Camp/Grounds';
   TITLE 'National Parks and Monuments Arranged by Region';
RUN;



/* Section 4.19 */
/* Program */
DATA natparks;
   INFILE 'c:\MyRawData\Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

* Region and Type as GROUP variables;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Region Type Museums Camping;
   DEFINE Region / GROUP;
   DEFINE Type / GROUP;
   TITLE 'Summary Report with Two Group Variables';
RUN;

* Region as GROUP and Type as ACROSS with sums;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Region Type,(Museums Camping);
   DEFINE Region / GROUP;
   DEFINE Type / ACROSS;
   TITLE 'Summary Report with a Group and an Across Variable';
RUN;

/* Section 4.20 */
/* Program */

DATA natparks;
   INFILE 'c:\MyRawData\Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

* PROC REPORT with breaks;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Name Region Museums Camping;
   DEFINE Region / ORDER;
   BREAK AFTER Region / SUMMARIZE OL SKIP;
   RBREAK AFTER / SUMMARIZE OL SKIP;
   TITLE 'Detail Report with Summary Breaks';
RUN;




/* Section 4.21 */
/* Program */

DATA natparks;
   INFILE 'c:\MyRawData\Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

*Statistics in COLUMN statement with two group variables;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Region Type N (Museums Camping),MEAN;
   DEFINE Region / GROUP;
   DEFINE Type / GROUP;
   TITLE 'Statistics with Two Group Variables';
RUN;

*Statistics in COLUMN statement with group and across variables;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Region N Type,(Museums Camping),MEAN;
   DEFINE Region / GROUP;
   DEFINE Type / ACROSS;
   TITLE 'Statistics with a Group and Across Variable';
RUN;

/* Section 4.22 */
/* Program */
DATA natparks;
   INFILE 'c:\MyRawData\Parks.dat';
   INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

* COMPUTE new variables that are numeric and character;
PROC REPORT DATA = natparks NOWINDOWS HEADLINE;
   COLUMN Name Region Museums Camping Facilities Note;
   DEFINE Museums / ANALYSIS SUM NOPRINT;
   DEFINE Camping / ANALYSIS SUM NOPRINT;
   DEFINE Facilities / COMPUTED 'Camping/and/Museums';
   DEFINE Note / COMPUTED;
   COMPUTE Facilities;
      Facilities = Museums.SUM + Camping.SUM;
   ENDCOMP;
   COMPUTE Note / CHAR LENGTH = 10;
      IF Camping.SUM = 0 THEN Note = 'No Camping';
   ENDCOMP;
   TITLE 'Report with Two Computed Variables'; 
RUN;

/* Section 4.23 */
/* Program */

DATA books;
   INFILE 'c:\MyRawData\LibraryBooks.dat';
   INPUT Age BookType $ @@;
RUN;

*Define formats to group the data;
PROC FORMAT;
   VALUE agegpa
         0-18    = '0 to 18'
         19-25   = '19 to 25'
         26-49   = '26 to 49'
         50-HIGH = '  50+ ';
   VALUE agegpb
         0-25    = '0 to 25'
         26-HIGH = '  26+ ';
   VALUE $typ
        'bio','non','ref' = 'Non-Fiction'
        'fic','mys','sci' = 'Fiction';
RUN;

*Create two way table with Age grouped into four categories;
PROC FREQ DATA = books;
   TITLE 'Patron Age by Book Type: Four Age Groups';
   TABLES BookType * Age / NOPERCENT NOROW NOCOL;
   FORMAT Age agegpa. BookType $typ.;
RUN;

*Create two way table with Age grouped into two categories;
PROC FREQ DATA = books;
   TITLE 'Patron Age by Book Type: Two Age Groups';
   TABLES BookType * Age / NOPERCENT NOROW NOCOL;
   FORMAT Age agegpb. BookType $typ.;
RUN;