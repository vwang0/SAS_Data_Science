
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