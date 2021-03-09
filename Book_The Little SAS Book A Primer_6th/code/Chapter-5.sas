/*
* Chapter 5;
*/


/* Section 5.2 */

/* First Program */	
 DATA giant; 
    INFILE '/home/u49657251/little_sas_book/Tomatoes.dat' DSD; 
    INPUT Name :$15. Color $ Days Weight; 
/*  */
/* * Trace PROC MEANS; */
/* ODS TRACE ON; */
/* PROC MEANS DATA = giant; */
/*    BY Color; */
/* RUN; */
/* ODS TRACE OFF; */

/* Second Program */	

PROC MEANS DATA = giant;
   BY Color;
   TITLE 'Red Tomatoes';
ODS SELECT Means.ByGroup1.Summary;
RUN;

/* Section 5.3 */
/* Program */

DATA giant;
   INFILE '/home/u49657251/little_sas_book/Tomatoes.dat' DSD;
   INPUT Name :$15. Color $ Days Weight;
PROC TABULATE DATA = giant;
   CLASS Color;
   VAR Days Weight;
   TABLE Color ALL, (Days Weight) * MEAN;
   TITLE 'Standard TABULATE Output';
ODS OUTPUT Table = tabout;
RUN;
PROC PRINT DATA = tabout;
   TITLE 'OUTPUT SAS Data Set from TABULATE';
RUN;

/* Section 5.4 */

/* Program */
* Create the HTML files and remove procedure name;
ODS HTML FILE = '/home/u49657251/little_sas_book/Marine.html'; 
ODS NOPROCTITLE;
DATA marine;
   INFILE '/home/u49657251/little_sas_book/SeaLife.dat';
   INPUT Name $ Family $ Length @@;
RUN;
PROC MEANS DATA = marine MEAN MIN MAX;
   CLASS Family;
   TITLE 'Whales and Sharks';
RUN;
PROC PRINT DATA = marine;
RUN;
* Close the HTML files;
ODS HTML CLOSE;


/* Section 5.5 */
/* Program */

* Create an RTF file;
ODS RTF FILE = '/home/u49657251/little_sas_book/Marine.rtf' BODYTITLE COLUMNS=2;
ODS NOPROCTITLE;
DATA marine;
   INFILE '/home/u49657251/little_sas_book/SeaLife.dat';
   INPUT Name $ Family $ Length @@;
RUN;
PROC MEANS DATA = marine MEAN MIN MAX;
   CLASS Family;
   TITLE 'Whales and Sharks';
RUN;
PROC PRINT DATA = marine;
RUN;
* Close the RTF file;
ODS RTF CLOSE;

/* Section 5.6 */
/* Program */

* Create the PDF file;
ODS PDF FILE = 'c:\MyPDFFiles\Marine.pdf' STARTPAGE = NO;
ODS NOPROCTITLE;
DATA marine;
   INFILE '/home/u49657251/little_sas_book/SeaLife.dat';
   INPUT Name $ Family $ Length @@;
RUN;
PROC MEANS DATA = marine MEAN MIN MAX;
   CLASS Family;
   TITLE 'Whales and Sharks';
RUN;
PROC PRINT DATA = marine;
RUN;
* Close the PDF file;
ODS PDF CLOSE;




/* Section 5.8 */

/* First Program */

ODS HTML FILE='/home/u49657251/little_sas_book/results.htm';
DATA skating;
  INFILE '/home/u49657251/little_sas_book/Women.csv' DSD MISSOVER;
  INPUT Year Name :$20. Country $ 
        Time $ Record $;
RUN;
PROC PRINT DATA=skating;
  TITLE 'Women''s 5000 Meter Speed Skating';
  ID Year;
RUN;
ODS HTML CLOSE;


/* Second Program */

ODS HTML FILE='c:\MyHTML\results2.htm';
PROC PRINT DATA=skating 
     STYLE(DATA)={BACKGROUND=white};
  TITLE 'Women''s 5000 Meter Speed Skating';
  ID Year;
RUN;
ODS HTML CLOSE;

/* Third Program */

ODS HTML FILE='/home/u49657251/little_sas_book/results3.htm';
PROC PRINT DATA=skating 
     STYLE(DATA)={BACKGROUND=white};
  TITLE 'Women''s 5000 Meter Speed Skating';
  VAR Name Country Time;
  VAR Record/STYLE(DATA)=
       {FONT_STYLE=italic FONT_WEIGHT=bold};
  ID Year;
RUN;
ODS HTML CLOSE;

/* Section 5.9 */

/* First Program */
DATA skating;
   INFILE 'c:\MyRawData\Speed.dat' DSD;
   INPUT Name :$20. Country $ 
      NumYears NumGold @@;
RUN;
ODS HTML FILE='c:\MyHTML\speed.htm';
PROC REPORT DATA = skating NOWINDOWS;
   COLUMN Country Name NumGold;
   DEFINE Country / GROUP;
   TITLE 'Olympic Women''s '
      'Speed Skating';
RUN;
ODS HTML CLOSE;


/* Second Program */

* STYLE= option in PROC statement;
ODS HTML FILE='c:\MyHTML\speed2.htm';
PROC REPORT DATA = skating NOWINDOWS 
   SPANROWS  STYLE(COLUMN) = 
   {FONT_WEIGHT = bold JUST = center};
   COLUMN Country Name NumGold;
   DEFINE Country / GROUP;
   TITLE 'Olympic Women''s '
      'Speed Skating';
RUN;
ODS HTML CLOSE;

/* Third Program */

* STYLE= option in DEFINE statement;
ODS HTML FILE='c:\MyHTML\speed3.htm';
PROC REPORT DATA = skating NOWINDOWS
   SPANROWS;
   COLUMN Country Name NumGold;
   DEFINE Country / GROUP STYLE(COLUMN) = 
      {FONT_WEIGHT = bold JUST = center};
   TITLE 'Olympic Women''s '
      'Speed Skating';
RUN;
ODS HTML CLOSE;


/* Section 5.10 */

/* First Program */

ODS HTML FILE='c:\MyHTML\table.htm';
DATA skating;
  INFILE 'c:\MyData\Records.dat';
  INPUT Year  Event $ Record $ @@;
RUN;
PROC TABULATE DATA=skating;
  CLASS Year Record;
  TABLE Year='',Record*N='';
  TITLE 'Men''s Speed Skating';
  TITLE2 'Records Set at Olympics';
RUN;
ODS HTML CLOSE;

/* Second Program */

ODS HTML FILE='c:\MyHTML\table2.htm';
PROC TABULATE DATA=skating
     STYLE={JUST=center BACKGROUND=white};
  CLASS Year Record;
  TABLE Year='',Record*N='';
  TITLE 'Men''s Speed Skating';
  TITLE2 'Records Set at Olympics';
RUN;
ODS HTML CLOSE;


/* Section 5.11 */

/* First Program */

ODS HTML FILE='c:\MyHTML\mens.html';
DATA results;
  INFILE
     'c:\MyRawData\Mens5000.dat' DSD;
  INPUT Place Name :$20.
        Country :$15. Time ;
RUN;
PROC PRINT DATA=results;
  ID Place;
  TITLE 'Men''s 5000m Speed Skating';
  TITLE2 '2002 Olympic Results';
RUN;
ODS HTML CLOSE;


/* Second Program */	

ODS HTML FILE='c:\MyHTML\mens2.html';
PROC FORMAT;
  VALUE rec 0 -< 378.72 ='red'
            378.72 -< 382.20 = 'orange'
            382.20 - HIGH = 'white';
RUN;
PROC PRINT DATA=results;
  ID Place;
  VAR Name Country;
  VAR Time/STYLE={BACKGROUND=rec.};
  TITLE 'Men''s 5000m Speed Skating';
  TITLE2 '2002 Olympic Results';
RUN;
ODS HTML CLOSE;

LIBNAME ch5 "/home/u49657251/little_sas_book/data/";

* Part A - Count the total number of earthquakes by state that were greater than or
equal to 7.0 magnitude;
PROC FREQ data = ch5.earthquakes;
	WHERE Magnitude >= 7.0;
	TABLE State;
	TITLE "Frequency of Magnitude 7.0 or Higher Earthquakes By State";
RUN;

* Part B - Add an ODS statement that will capture the count data as a new data set.;
ODS TRACE ON;
PROC FREQ data = ch5.earthquakes;
	WHERE Magnitude >= 7.0;
	TABLE State;
	TITLE "Frequency of Magnitude 7.0 or Higher Earthquakes By State";
	ODS OUTPUT OneWayFreqs = quakefreq;
RUN;
ODS TRACE OFF;

* Part C - Using the output of Part B, create a PDF report listing the states with
at least two major to great (>= 7.0) quakes.  Remove the ANALYSIS style, include only
variables for state and count, and add a title;
ODS PDF FILE = "U:\exercise_5_24_frequency.pdf" STYLE = ANALYSIS;
PROC PRINT data = quakefreq;
	WHERE Frequency >= 2;
	VAR State Frequency;
	TITLE "Frequency of Magnitude 7.0 or Higher Earthquakes By State";
RUN;
ODS PDF CLOSE;

* Part D - Using output from part C, also list the earthquakes of 
magnitude 7.0 or higher since the year 2000.;
ODS PDF FILE = "U:\exercise_5_24_frequency_and_listing.pdf" STYLE = ANALYSIS;
PROC PRINT data = quakefreq;
	WHERE Frequency >= 2;
	VAR State Frequency;
	TITLE "Frequency of Magnitude 7.0 or Higher Earthquakes By State";
RUN;

PROC PRINT data = ch5.earthquakes;
	WHERE Year >= 2000 AND Magnitude >= 7.0;
	TITLE "Listing of Earthquakes of Magnitude 7.0 or Greater Since 2000";
RUN;
ODS PDF CLOSE;


LIBNAME ch5 "/home/u49657251/little_sas_book/data/";

* Part A - Create a table of counts by year of issue.  Create a second report with
color hex and year of issue for each crayon.  Send reports to default destination;
PROC FREQ data = ch5.crayons;
	TABLE Issued;
	TITLE "Number of Crayon Colors Issued by Year";
RUN;

PROC PRINT data = ch5.crayons;
	VAR Color Hex Issued;
	TITLE "Listing of Crayons with Hexidecimal Color Codes";
RUN;

* Part B - Save Part A as text.;
ODS LISTING FILE = "U:\crayons.txt";
ODS NOPROCTITLE;
PROC FREQ data = ch5.crayons;
	TABLE Issued;
	TITLE "Number of Crayon Colors Issued by Year";
RUN;

PROC PRINT data = ch5.crayons;
	VAR Color Hex Issued;
	TITLE "Listing of Crayons with Hexidecimal Color Codes";
RUN;
ODS LISTING CLOSE;

* Part C - Save Part A as HTML.;
ODS HTML FILE = "U:\crayons.html";
ODS NOPROCTITLE;
PROC FREQ data = ch5.crayons;
	TABLE Issued;
	TITLE "Number of Crayon Colors Issued by Year";
RUN;

PROC PRINT data = ch5.crayons;
	VAR Color Hex Issued;
	TITLE "Listing of Crayons with Hexidecimal Color Codes";
RUN;
ODS HTML CLOSE;

* Part D - Save Part A as RTF.;
ODS RTF FILE = "U:\crayons.rtf";
ODS NOPROCTITLE;
PROC FREQ data = ch5.crayons;
	TABLE Issued;
	TITLE "Number of Crayon Colors Issued by Year";
RUN;

PROC PRINT data = ch5.crayons;
	VAR Color Hex Issued;
	TITLE "Listing of Crayons with Hexidecimal Color Codes";
RUN;
ODS RTF CLOSE;

* Part E - Save Part A as PDF.;
ODS PDF FILE = "U:\crayons.pdf";
ODS NOPROCTITLE;
PROC FREQ data = ch5.crayons;
	TABLE Issued;
	TITLE "Number of Crayon Colors Issued by Year";
RUN;

PROC PRINT data = ch5.crayons;
	VAR Color Hex Issued;
	TITLE "Listing of Crayons with Hexidecimal Color Codes";
RUN;
ODS PDF CLOSE;
