/* Chapter 3 */

/* Section 3.1 */

/* Program */

* Modify homegarden data set with assignment statements;
DATA homegarden;
   INFILE 'c:\MyRawData\Garden.dat';
   INPUT Name $ 1-7 Tomato Zucchini Peas Grapes;
   Zone = 14;
   Type = 'home';
   Zucchini = Zucchini * 10;
   Total = Tomato + Zucchini + Peas + Grapes;
   PerTom = (Tomato / Total) * 100;
RUN;
PROC PRINT DATA = homegarden;
   TITLE 'Home Gardening Survey';
RUN;

/* Section 3.2 */

/* Section 3.2 */
/* Program */

DATA contest;
   INFILE 'c:\MyRawData\Pumpkin.dat';
   INPUT Name $16. Age 3. +1 Type $1. +1 Date MMDDYY10.
         (Scr1 Scr2 Scr3 Scr4 Scr5) (4.1);
   AvgScore = MEAN(Scr1, Scr2, Scr3, Scr4, Scr5);
   DayEntered = DAY(Date);
   Type = UPCASE(Type);
RUN;
PROC PRINT DATA = contest;
   TITLE 'Pumpkin Carving Contest';
RUN;


/* Section 3.5 */

/* Program */

DATA sportscars;
   INFILE 'c:\MyRawData\UsedCars.dat';
   INPUT Model $ Year Make $ Seats Color $;
   IF Year < 1975 THEN Status = 'classic';
   IF Model = 'Corvette' OR Model = 'Camaro' THEN Make = 'Chevy';
   IF Model = 'Miata' THEN DO;
      Make = 'Mazda';
      Seats = 2;
   END;
RUN;
PROC PRINT DATA = sportscars;
   TITLE "Eddy�s Excellent Emporium of Used Sports Cars";
RUN;

/* Section 3.6 */

/* Program */

* Group observations by cost;
DATA homeimprovements;
   INFILE 'c:\MyRawData\Home.dat';
   INPUT Owner $ 1-7 Description $ 9-33 Cost;
   IF Cost = . THEN CostGroup = 'missing';
      ELSE IF Cost < 2000 THEN CostGroup = 'low';
      ELSE IF Cost < 10000 THEN CostGroup = 'medium';
      ELSE CostGroup = 'high';
RUN;
PROC PRINT DATA = homeimprovements;
   TITLE 'Home Improvement Cost Groups';
RUN;


/* Section 3.7 */

/* Program */

* Choose only comedies;
DATA comedy;
   INFILE 'c:\MyRawData\Shakespeare.dat';
   INPUT Title $ 1-26 Year Type $;
   IF Type = 'comedy';
RUN;
PROC PRINT DATA = comedy;
   TITLE 'Shakespearean Comedies';
RUN;

/* Section 3.8 */

/* Program */

DATA librarycards;
   INFILE 'c:\MyRawData\Library.dat' TRUNCOVER;
   INPUT Name $11. + 1 BirthDate MMDDYY10. +1 IssueDate ANYDTDTE10.
      DueDate DATE11.;
   DaysOverDue = TODAY() - DueDate;
   Age = INT(YRDIF(BirthDate, TODAY(), 'ACTUAL'));
   IF IssueDate > '01JAN2008'D THEN NewCard = 'yes';
RUN;
PROC PRINT DATA = librarycards;
   FORMAT Issuedate MMDDYY8. DueDate WEEKDATE17.;
   TITLE 'SAS Dates without and with Formats';
RUN;


/* Section 3.10 */

/* Program */

* Using RETAIN and sum statements to find most runs and total runs;
DATA gamestats;
   INFILE '/home/u49596266/little_sas_book/Games.dat';
   INPUT Month 1 Day 3-4 Team $ 6-25 Hits 27-28 Runs 30-31;
   RETAIN MaxRuns;
   MaxRuns = MAX(MaxRuns, Runs);
   RunsToDate + Runs;
RUN;
PROC PRINT DATA = gamestats;
   TITLE "Season's Record to Date";
RUN;

/* Section 3.11*/

/* Program */

* Change all 9s to missing values;
DATA songs;
   INFILE 'c:\MyRawData\WBRK.dat';
   INPUT City $ 1-15 Age domk wj hwow simbh kt aomm libm tr filp ttr;
   ARRAY song (10) domk wj hwow simbh kt aomm libm tr filp ttr;
   DO i = 1 TO 10;
      IF song(i) = 9 THEN song(i) = .;
   END;
RUN;
PROC PRINT DATA = songs;
   TITLE 'WBRK Song Survey';
RUN;



/* Section 3.12 */
/* Program */

DATA songs;    
   INFILE 'c:\MyRawData\WBRK.dat';    
   INPUT City $ 1-15 Age domk wj hwow simbh kt aomm libm tr filp ttr;
   ARRAY new (10) Song1 - Song10;
   ARRAY old (10) domk -- ttr;
   DO i = 1 TO 10;
      IF old(i) = 9 THEN new(i) = .;
         ELSE new(i) = old(i);
   END;
   AvgScore = MEAN(OF Song1 - Song10);
PROC PRINT DATA = songs;
   TITLE 'WBRK Song Survey';
RUN;
