/*
* Chapter 4;
*/
/* Create a temporary data set with subject ages, sex, and weight to demonstrate
sorting using PROC SORT 
The DESCENDING keyword in the PROC SORT BY statement must come BEFORE the variable
to sort */

DATA weights;
	INPUT age sex $ weight ;
	DATALINES;
18	Male	201
18	Female	188
18	Male	183
18	Female	121
18	Female	150
16	Female	109
23	Male	210
33	Female	198
12	Female	78
14	Male	98
;
RUN;

PROC SORT data = weights out = weights_sort;
	BY age descending sex descending weight;
RUN;

PROC PRINT data = weights_sort;
RUN;

* Option to PROC SORT to tell SAS to sort the following names in alphabetical order ;
DATA lastnames;
	INPUT lastname $ 1-10;
	DATALINES;
de Bie
De Leon
deVere
DeMesa
Dewey
;
RUN;

* SORTSEQ = LINGUISTIC to ignore upper and lowercase when sorting;
PROC SORT data = lastnames out = answera
SORTSEQ = LINGUISTIC (STRENGTH = PRIMARY);
	BY  lastname;
RUN;

* Change sort order from EBCDIC (blank lowercase uppercase numeral
to ASCII (blank numerical uppercase lowercase);
PROC SORT data = lastnames out = answerb
SORTSEQ = ASCII;
	BY  lastname;
RUN;

PROC SORT data = lastnames out = answerc
NODUPKEY;
	BY  lastname;
RUN;

PROC PRINT data = answera;
	TITLE1 "Data sorted with SORTSEQ = LINGUISTIC";
RUN; 

PROC PRINT data = answerb;
	TITLE1 "Data sorted with SORTSEQ = ASCII";
RUN; 

PROC PRINT data = answerc;
	TITLE1 "Data sorted with NODUPKEY";
RUN; 

DATA random;
	INPUT Q1 Q2 Q3 Q4;
	DATALINES;
12	66	58	11
12	88	66	75
16	66	55	84
13	54	37	89
;
RUN;

*PROC PRINT, no options;
PROC PRINT data = random;
	TITLE1 "PROC PRINT with no VAR statement";
RUN;

* Has errors ;
PROC PRINT data = random;
	TITLE1 "Var Q1, Q2, Q3";
	VAR Q1, Q2, Q3;
RUN;

* This one is correct and will run with no errors. ;
PROC PRINT data = random;
	TITLE1 "Var Q1 Q2 Q3";
	VAR Q1 Q2 Q3;
RUN;

* Has errors. ;
PROC PRINT data = random;
	TITLE1 "Var (Q1 to Q3)";
	VAR (Q1 to Q3);
RUN;

* Show format for displaying 5678 as 5,678.00 ;
* Addition of one comma, one decimal, and precision of 2 ;
* requires that the output should have COMMA8.2 format. ;
DATA random;
	INPUT 	Original 
		 	COMMA6_2 
			COMMA_7_2
			COMMA_7_3
			COMMA8_2
	;
	FORMAT
			COMMA6_2 COMMA6.2
			COMMA_7_2 COMMA7.2
			COMMA_7_3 COMMA7.3
			COMMA8_2 COMMA8.2
	;
	DATALINES;
5678	5678	5678	5678	5678
;
RUN;

*Show how each value displays after formatting ;
PROC PRINT data = random;
	TITLE1 "Display 5678 as 5,678.00";
RUN;


* Show that the CLASS statement in PROC MEANS can be used to calculate ;
* summary statistics on an unsorted data set.  If the data is sorted the ;
* BY statement can be used instead.  Arguments for BY and CLASS should be ;
* A categorical variable ;

DATA test;
	INPUT Gender $ Age;
	DATALINES;
Male 33
Female 15
Male 55
Female 29
Male 12
Female 88
Female 46
Male 60
;
RUN;

PROC MEANS data = test;
	CLASS Gender;
	VAR	Age;
	TITLE1 "PROC MEANS using CLASS on unsorted data";
RUN;
	
* Note: this procedure WILL NOT work!  The following error message is generated;
* in the SAS log:  ERROR: Data set WORK.TEST is not sorted in ascending sequence.;
* The current BY group has Gender = Male and the next BY group has  Gender = Female.;
PROC MEANS data = test;
	BY Gender;
	VAR	Age;
	TITLE1 "PROC MEANS using BY on unsorted data";
RUN;

* Example of an output statistic list.  Mean age of males and females ;
* is calculated and output to new variables FemaleAge and MaleAge ;

* Number of variables input into the statistic must match the number of ;
* variables in the output list ;
DATA test;
	INPUT Males Females;
	DATALINES;
12 56
15 88
79 56
14 67
46 55
37 46
12 7
44 65
;
RUN;

PROC MEANS data = test;
	OUTPUT OUT = test_means
	MEAN(Females Males) = FemaleAge MaleAge;
RUN;
	
PROC PRINT data = test_means;
	TITLE1 "PROC MEANS data with output statistic list";
RUN;

* Show different behaviors of PROC REPORT with no options depending on what ;
* data is used ;

DATA test;
	INPUT Age Weight;
	DATALINES;
33 189
15 145
55 177
29 112
12 110
88 123
46 180
60 199
;
RUN;

DATA test2;
	INPUT Sex $ Age Weight;
	DATALINES;
Male 33 189
Male 15 145
Male 55 177
Female 29 112
Female 12 110
Female 88 123
Female 46 180
Male 60 199
;
RUN;

PROC REPORT data = test;
RUN;

PROC REPORT data = test2;
RUN;

libname ch4 '/home/u49657251/little_sas_book/data/';

/* Variable attributes can be viewed with either PROT CONTENTS or
by looking at the proporties of the data set in Explorer pane 
Label for Color is "Crayon name" and the format is $26.*/
PROC CONTENTS data = ch4.crayons;
RUN;

/* 1949 issued the highest number of new colors at 40 */
PROC FREQ data = ch4.crayons;
	TABLES Issued;
RUN;

PROC SORT data = ch4.crayons out = crayons_sort SORTSEQ = LINGUISTIC (NUMERIC_COLLATION = ON);
	BY RGB;
RUN;

PROC PRINT data = crayons_sort NOOBS;
	VAR Color RGB;
RUN;


* Read data from DAT file ;
DATA donations;
	INFILE "/home/u49657251/little_sas_book/data/Donations.dat" TRUNCOVER;
	INPUT id 1-4 first $ 6-19 last $ 20-33 address $ 34-58 city $ 59-88 zip $ 94-98 amount 101-105 month 106-107 ;
RUN;

* Use RETAIN to fill in missing data down columns ;
DATA donations_fill;
	SET donations;

	RETAIN _first _last _address _city _zip;
	IF NOT MISSING(first) THEN _first = first;
	IF NOT MISSING(last) THEN _last = last;
	IF NOT MISSING(address) THEN _address = address;
	IF NOT MISSING(city) THEN _city = city;
	IF NOT MISSING(zip) THEN _zip = zip;

	first = _first;
	last = _last;
	address = _address;
	city = _city;
	zip = _zip;

	DROP _:;
RUN;

PROC MEANS data = donations_fill NOPRINT; 
	VAR amount ;
	BY id first last address city zip month;
	OUTPUT OUT = donations_summary
				sum(amount)=;
RUN;

DATA _NULL_;
	SET donations_summary;
	BY id;
	
	IF month = 1 THEN monthtext = "Jan";
	ELSE IF month = 2 THEN monthtext = "Feb";
	ELSE IF month = 3 THEN monthtext = "Mar";
	ELSE IF month = 4 THEN monthtext = "Apr";
	ELSE IF month = 5 THEN monthtext = "May";
	ELSE IF month = 6 THEN monthtext = "Jun";
	ELSE IF month = 7 THEN monthtext = "Jul";
	ELSE IF month = 8 THEN monthtext = "Aug";
	ELSE IF month = 9 THEN monthtext = "Sep";
	ELSE IF month = 10 THEN monthtext = "Oct";
	ELSE IF month = 11 THEN monthtext = "Nov";
	ELSE IF month = 12 THEN monthtext = "Dec";
	ELSE monthtext = "Unknown";
	
	FORMAT amount DOLLAR8.2;
	
	FILE "/home/u49657251/little_sas_book/data/Donations.txt" PRINT;
	TITLE;
	IF first.id THEN DO;
	PUT _PAGE_ ;
	PUT	@1 "To: " first " " last /
	    @5 address /
	    @5 city " " zip //

	    @5 "Thank you for your support!  Your donations help us save hundreds of cats and dogs each year" /
		@5 "Donations to Coastal Humane Society" /
		@5 "(Tax ID: 99-5551212)" ;
	end;
	/* Forward slash not needed, as a new line will print on each iteration */
	PUT	@5 monthtext " " amount;
	
RUN;

libname ch4 '/home/u49657251/little_sas_book/data/';

/* GasPrice :U.S. average price of unleaded regular gasoline (per gallon) 
Numeric variable length 8. */
PROC CONTENTS data = ch4.gas;
RUN;

/* Calculate min, max, mean, and std with default PROC MEANS */
PROC MEANS data = ch4.gas
	MAXDEC=2;
	BY Year;
	VAR GasPrice;
RUN;

/* Create a new dataset with quarter */
DATA gas_qtr;
	SET ch4.gas;
	DummyDate = MDY(Month, 01, Year);
	Qtr = QTR(DummyDate);
	DROP DummyDate;
RUN;

/* Re-run PROC MEANS by Year and Qtr and create new dataset
Drop _FREQ_ and _TYPE_ when creating new dataset */
PROC MEANS data = gas_qtr
	MAXDEC=2;
	BY Year Qtr;
	VAR GasPrice;
	OUTPUT OUT = gas_summary(DROP = _FREQ_ _TYPE_)
		MEAN(GasPrice) = AveragePrice 
		STD(GasPrice) = StdDev
	;
	FORMAT AveragePrice DOLLAR6.2
		   StdDev DOLLAR6.2;
RUN;
	

LIBNAME ch4 "/home/u49657251/little_sas_book/data/";

* Part A - Character Variables ;
* Country (length 30), Continent (length 13) ;
PROC CONTENTS data = ch4.sff varnum;
RUN;

* Part B - Count the number of countries within each continent. ;
PROC FREQ data = ch4.sff;
	TABLES Continent;
	TITLE "Frequency of Countries by Continent";
RUN; 

* Part C - Count the number of countries per continent that reported no ;
* cases during the first month of outbreak (April) versus those that had at ;
* least one outbreak.  Do the same for August ;

* No April outbreaks ;
PROC FREQ data = ch4.sff;
	TABLES Continent;
	TITLE "Frequency of Countries with No Outbreaks in April by Continent";
	WHERE Apr = .;
RUN; 

* 1+ April outbreaks ;
PROC FREQ data = ch4.sff;
	TABLES Continent;
	TITLE "Frequency of Countries with 1+ Outbreaks in April by Continent";
	WHERE Apr > 0;
RUN; 

* No August outbreaks ;
PROC FREQ data = ch4.sff;
	TABLES Continent;
	TITLE "Frequency of Countries with No Outbreaks in August by Continent";
	WHERE Aug = .;
RUN; 

* 1+ August outbreaks ;
PROC FREQ data = ch4.sff;
	TABLES Continent;
	TITLE "Frequency of Countries with 1+ Outbreaks in August by Continent";
	WHERE Aug > 0;
RUN; 

* Part D - Create a report of countries that reported a first death date but ;
* did not a first case date.  Only include continent, country, first case date, ;
* last reported number of cases, and first death date ;
PROC PRINT data = ch4.sff;
	VAR Continent Country FirstCase FirstDeath;
	WHERE FirstCase = . AND FirstDeath <> .;
	TITLE "Countries with FirstDeath Date and no First Case Date";
	FORMAT FirstDeath MMDDYY10.;
RUN;

* Part E - Same as part D but format dates and sort output by continent;
PROC SORT data = ch4.sff out = sffsort;
	BY Continent;
RUN;

PROC PRINT data = sffsort;
	VAR Continent Country FirstCase FirstDeath;
	WHERE FirstCase = . AND FirstDeath <> .;
	TITLE "Countries with FirstDeath Date and no First Case Date";
	FOOTNOTE "Sorted by Continent";
	FORMAT FirstDeath MMDDYY10.;
RUN;

LIBNAME ch4 "/home/u49657251/little_sas_book/data/";

* Part A - What is the variable type for Rating? ;
* Numeric ;
PROC CONTENTS data = ch4.pizzaratings varnum;
RUN;

* Part B - Use PROC FORMAT to convert numeric ratings to ;
* text description of each rating ;
PROC FORMAT;
	VALUE rating 
	. = "N/A"
	1 = "Never"
	2 = "Might"
	3 = "At least once"
	4 = "Occasionally"
	5 = "Often"
	;
RUN;

PROC PRINT data = ch4.pizzaratings;
	FORMAT Rating rating.;
	TITLE "Pizza Topping Survey Data";
RUN;

* Part C - Count non-missing observations and calculate average ;
* Rating.  Count should be a whole number, and report average to ;
* three decimal places ;
PROC SORT data = ch4.pizzaratings out = pizzasort;
	BY Topping;
	WHERE Rating <> .;
RUN;

PROC MEANS data = pizzasort maxdec= 3;
	BY Topping;
	VAR Rating;
	TITLE "Mean Pizza Topping Rating Using PROC MEANS";
RUN;


* Part D - Accomplish the same task in Part D using a different ;
* procedure ;
PROC TABULATE data = ch4.pizzaratings FORMAT = 5.3;
	CLASS Topping;
	VAR Rating;
	TABLE Topping, MEAN*Rating;
	TITLE "Mean Pizza Topping Rating Using PROC TABULATE";
RUN;

LIBNAME ch4 "/home/u49657251/little_sas_book/data/";

* Part A - count the total guests by registration type ;
PROC TABULATE data = ch4.conference;
	CLASS RegType;
	TABLES RegType;
RUN;

* Part B - create a format that will display VegMeal variable 
as either Yes or No and apply to data. ;
PROC FORMAT;
	VALUE needsveg
	0 = "No"
	1 = "Yes"
	;
RUN;

PROC PRINT data = ch4.conference;
	VAR FirstName LastName VegMeal;
	FORMAT VegMeal needsveg.;
	TITLE "Meal Requirements for Conference Participants";
RUN;

* Part C - create a table that shows total fees paid per area code and 
registration type within the area code.  Report using dollar format
to two decimal places ;
PROC TABULATE data = ch4.conference FORMAT = DOLLAR9.2;
	CLASS AreaCode RegType;
	VAR Rate;
	TABLE AreaCode, SUM=''*Rate=''*RegType="Registration Type";
	TITLE "Total Fees Collected Per Area Code and Registration Type";
RUN;

* Part D - create a table of total number of attendees and overall
percentage per area code and registration type, as well as total and percent
for each area code. Present only these statistics and report percentage to 
two decimal places;
PROC FREQ data = ch4.conference;
	TABLES AreaCode * RegType /
		LIST NOCUM;
	TITLE "Total and Percent Attendees by Area Code and Registration Type with PROC FREQ";
RUN;

* Part E - repeat part D using a different method. ;
PROC TABULATE data = ch4.conference;
	CLASS AreaCode RegType;
	TABLE AreaCode, N='Total Count'*RegType='Registration Type' PCTN='Overall Percentage'*RegType='Registration Type';
	TITLE "Total and Percent Attendees by Area Code and Registration Type with PROC TABULATE";
RUN;

LIBNAME ch4 "/home/u49657251/little_sas_book/data/";

* Part A - Calculate the mean shipping cost per state, excluding California ;
PROC TABULATE data = ch4.elliptical;
	CLASS State;
	VAR Shipping;
	TABLE State, MEAN='Average Shipping Cost'*Shipping='';
	WHERE State <> "California";
	TITLE "Mean Shipping Rates by State";
	FOOTNOTE "Note: table does not include shipping rates to California";
RUN;

* Part B - Use a procedure to calcuate the total cost including tax and shipping
and present this total cost for each purchase organized by state;
PROC REPORT data = ch4.elliptical NOWINDOWS;
	COLUMN Machine State Cost Tax Shipping TotalCost;
	DEFINE TotalCost / COMPUTED 'Total Cost';
	COMPUTE TotalCost;
	TotalCost = SUM(Cost.SUM, Tax.SUM, Shipping.SUM);
	ENDCOMP;
	TITLE "Total Cost Per Order using PROC REPORT";
RUN;

* Part C - Modify code from Part B to calculate total cost for heart rate monitors only
and display grand total for heart rate monitors by region.  Also show number of purchases
per region by type of heart rate machine ;
PROC FORMAT;
	VALUE $coast
	"California" = "West Coast"
	"Oregon" = "West Coast"
	"Washington" = "West Coast"
	other = "East Coast"
	;
RUN;
	
PROC REPORT data = ch4.elliptical MISSING NOWINDOWS;
	COLUMN State Machine Cost Tax Shipping TotalCost;
	DEFINE State /
		GROUP 'Region';
	DEFINE TotalCost / COMPUTED 'Total Cost' FORMAT=DOLLAR10.2;
		COMPUTE TotalCost;
		TotalCost = SUM(Cost.SUM, Tax.SUM, Shipping.SUM);
		ENDCOMP;
	DEFINE Machine /
		ACROSS;
	TITLE "Total Units Sold Per Region with Overall Total Cost";
	FORMAT	State $coast.
			Cost DOLLAR10.2
			Tax DOLLAR10.2
			Shipping DOLLAR10.2
	;
	WHERE Machine CONTAINS "HRT";
RUN;

LIBNAME ch4 "/home/u49657251/little_sas_book/data/";

* Part A - Compute the overall mean, minimum, and maximum of Score1 and Score2;
PROC MEANS data = ch4.diving MAXDEC=2 MEAN MIN MAX;
	VAR Score1 Score2;
	TITLE "Overall Mean, Minimum, and Maximum of Scoring Methods";
RUN;

* Part B - Sum the 6 new scoring method scores per driver, output the results to
a new data set, and add a comment for the top three scores ;
PROC MEANS data = ch4.diving MAXDEC=2 SUM NOPRINT;
	BY Name;
	VAR Score2;
	OUTPUT OUT = divingsum(drop=_FREQ_ _TYPE_) SUM(Score2) = Score2Sum;
RUN;

* Qin Kai = Gold
He Chong = Silver
Hausdin Patrick = Bronze ;
PROC REPORT data = divingsum;
	COLUMN Name Score2Sum;
	DEFINE Score2Sum /
		DESCENDING ORDER 'Overall Score';
	TITLE "Overall Score Per Diver";
RUN;

* Part C - Count scores per diver after recoding scores;
PROC FORMAT;
	VALUE scorerecode
	LOW - 0.5 = "Completely Failed"
	0.5 -< 2.5 = "Unsatisfactory"
	2.5 -< 5.0 = "Deficient"
	5.0 -< 7.0 = "Satisfactory"
	7.0 -< 8.5 = "Good"
	8.5 -< 9.5 = "Very Good"
	9.5 - HIGH = "Excellent"
	;
RUN;


PROC FREQ data = ch4.diving;
	TABLES Name * J1-J7;
	FORMAT J1-J7 scorerecode.;
	TITLE "Scores Given By Judge";
RUN;

* Part D - Calculate the minimum and maximum score per dive for each diver.
Present results by diver and in dive number order;
PROC REPORT data = ch4.diving;
	COLUMN Name Dive J1-J7 MinVal MaxVal;
	DEFINE Name / GROUP;
	DEFINE Dive / GROUP;
	DEFINE J1-J7 / NOPRINT;
	DEFINE MinVal /	COMPUTED;
		COMPUTE MinVal;
			MinVal = MIN(J1.SUM, J2.SUM, J3.SUM, J4.SUM, J5.SUM, J6.SUM, J7.SUM);
		ENDCOMP;
	DEFINE MaxVal / COMPUTED;
		COMPUTE MaxVal;
			MaxVal = MAX(J1.SUM, J2.SUM, J3.SUM, J4.SUM, J5.SUM, J6.SUM, J7.SUM);
		ENDCOMP;
	TITLE "Minimum and Maximum Scores Per Dive";
RUN;

