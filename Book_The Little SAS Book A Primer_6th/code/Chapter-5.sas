/*
* Chapter 5;
*/
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
