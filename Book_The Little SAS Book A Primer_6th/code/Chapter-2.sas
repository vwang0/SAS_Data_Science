/*
* Chapter 2;
*/

  
* Create a small dataset with dates and test using DATEw or MMDDYYw date input and output formats ;

DATA datetest;
	INPUT date1: DATE10. date2: MMDDYY10.;
	* Note: DATE10 will produce an error since the dates are not in ddmmmyyyy format ;
	FORMAT date1-date2 MMDDYY10.;
	DATALINES;
09/01/2015 09/01/2015
10/01/2015 10/01/2015
11/01/2015 11/01/2015
12/01/2015 12/01/2015
07/04/1776 07/04/1776
;
RUN;

* Create a test dataset of names, salaries, and ages.  Select the best input statement ;
DATA salary;
	* List input truncates salary for Oprah and does not import a value for age ;
	* INPUT Name $ Salary DOLLAR11. Age;
	
	* Input modifier (:) needed to correctly import observation for Oprah;
	INPUT Name $ Salary :DOLLAR11. Age;
	
	* SAS goes to a new line after INPUT statement reaches past end of line and skips Marian observation;
	* INPUT Name $ @10 Salary DOLLAR11. Age;

	* Note that invalid salary for all observations ;
	* INPUT Name $ @'$' Salary Age;
	DATALINES;
Sally     $64,350 41
Marian    $55,550 38
Oprah     $75,000,000 59
;
RUN;

* Write an input statement for the following raw data with variables Year, City, Name1, Name2 ;

DATA cities;
	INPUT Year City $ 4-16 Name1 $ Name2 $;
	DATALINES;
18 San Diago        Rebecca  Marian
19 San Fancisco     Kathy    Ginger
20 Long Beach       Scott    Sally
21 Las Vegas        Cynthia  MaryAnne
22 San Jose         Ethan    Frank
;
RUN;

  
* Create a data set with variables named Brand, Qty, and Amount ;
DATA salary;
	INPUT Brand $ 1-18 Qty Amount :DOLLAR6.2;
	DATALINES;
Pampers            42 $44.99
Huggies             7 $34.99
Seventh Generation  7 $39.99
Nature Babycare     4 $41.99
;
RUN;

* Create a data set with variables named ID and Group ;
* Keep only subjects that belong to Groups A and C. ;
DATA testids;
	INPUT ID $ Group $ @@;
	IF Group = 'B' THEN DELETE ;
	DATALINES;
4165 A 2255 B 3312 C 5689 C
1287 A 5454 A 6672 C 8521 B
8936 C 5764 B
;
RUN;

* Note: CancerRates.dat contains a total of 10 observations and 3 variables. ;

DATA cancer;
	INFILE "/home/u49657251/little_sas_book/data/CancerRates.dat";
	INPUT ranking cancersite $ rate :3.1 ;
RUN;
	
PROC PRINT data = cancer;
RUN;


* Note, AKCbreeds.dat contains 5 variables and 173 observations. ;

DATA dogbreeds;
	INFILE "/home/u49657251/little_sas_book/data/AKCbreeds.dat";
	INPUT breed $ 1-39 rank1 40-43 rank2 45-47 rank3 50-52 rank4 55-57 ;
RUN;

PROC PRINT data = dogbreeds;
RUN;

* Note, Vaccines.dat contains 17 variables and 21 observations. ;
* List input used due to embedded spaces in vaccine and transmission variables, and blanks for missing date per country; 

DATA vaccines;
	INFILE "/home/u49657251/little_sas_book/data/Vaccines.dat";
	INPUT vaccine_name $ 1-31 disease_transmission $ 32-50 ww_incidence 51-60 ww_deaths 61-70 Chile $ 71-73 Cuba $ 77-79
	United_States $ 83-85 United_Kingdom $ 89-91 Finland $ 94-97 Germany $ 100-103 Saudi_Arabia $ 106-109 Ethiopia $ 112-115 
	Botswana $ 118-121 India $ 124-127 Australia $ 130-133 China $ 136-139 Japan $ 142-145;
RUN;

PROC PRINT data = vaccines;
RUN;

* Note: BigCompanies.dat contains a total of 100 observations and 6 variables. ;
* Had to find a solution to convertingbecause COMPRESS() is not covered in chapter 2 of TLSB5 ;


DATA companies;
	INFILE "/home/u49657251/little_sas_book/data/BigCompanies.dat";
	INPUT ranking company_name $ 6-34 country $ 34-52 _sales $ _profits $ _assets $	_market $ ;
	
 	sales = input(compress(_sales,'B'),dollar32.);
 	profits = input(compress(_profits ,'B'),dollar32.);
 	assets = input(compress(_assets ,'B'),dollar32.);
 	market = input(compress(_market ,'B'),dollar32.);
	DROP _:;
RUN;

PROC PRINT data = companies;
RUN;


* Crayons.dat contains 133 observations and 7 variables ;
* MISSOVER is used to prevent SAS from reading the next observation when data is missing for year retired ;

* Create LIBREF my_lib to save SAS7BDAT file ;
LIBNAME my_lib "/home/u49657251/little_sas_book/data/";

DATA my_lib.crayons;
	INFILE "/home/u49657251/little_sas_book/data/Crayons.dat" MISSOVER;
	INPUT number 1-3 color $ 4-31 hex $ 32-40 rgb $ 41-57 packsize issued retired ;
	FORMAT issued YEAR4. retired YEAR4.;
RUN;

* Note: Mountains.dat contains a total of 177 observations and 5 variables. ;

DATA mountains;
	INFILE "/home/u49657251/little_sas_book/data/Mountains.dat";
	INFORMAT name $39. height_m COMMA8. height_ft COMMA8. year_first_ascent $9. prominence_m COMMA8.;
	INPUT name $ 1-39 height_m height_ft year_first_ascent $ prominence_m;
	IF year_first_ascent = "unclimbed" THEN year_first_ascent = "" ;
	as_year = input(year_first_ascent, YEAR4.) ;
	DROP year_first_ascent ;
	RENAME as_year = year_first_ascent ;
RUN;


* Step 1: read all observations into dataset allusers ;

DATA allusers;
	INFILE "/home/u49657251/little_sas_book/data/CompUsers.dat";
	INPUT userid group $ first $ last $ @"email:" email :$35. @"phone:" phone $ major $ @@ ;
RUN;

* Step 2: read only non-student observations ;
DATA nonstudent;
	INFILE "/home/u49657251/little_sas_book/data/CompUsers.dat";
	INPUT userid group $ first $ last $ @"email:" email :$35. @"phone:" phone $ major $ @@ ;
	IF group = "Student" THEN DELETE ;
RUN;

PROC PRINT data = allusers;
TITLE "All user accounts" ;
RUN;

PROC PRINT data = nonstudent;
TITLE "Non-Student user accounts" ;
RUN;


* Part A - Read data ;
* Part B - Add labels;
DATA swineflu;
	INFILE 	"/home/u49657251/little_sas_book/data/SwineFlu2009.dat" TRUNCOVER;

	INPUT 	id $ 1-3 cont_case $ 14-17 country $ 28-60 date_firstcase $ 61-70 cases_apr 89-95 cases_may 99-104
			cases_jun 109-114 cases_jul 119-125 cases_aug 129-135 cases_last 145-150 cont_death $ 155-158
			date_firstdeath $ 169-178 deaths_may 194-199 deaths_jun 204-209 deaths_jul 214-219 deaths_aug 224-229
			deaths_sep 234-239 deaths_oct 244-249 deaths_nov 256-261 deaths_dec 266-269; 

	LABEL
			id = "Country ID for sorting"
			cont_case = "1st Case ID (X.YY) where X represents continent X, and YY represents the YYth country with the next first case"
			country = "Country"
			date_firstcase = "Date first case reported"
			cases_apr = "Cumulative number of cases reported by the 1st of the month in April"
			cases_may = "Cumulative number of cases reported by the 1st of the month in May"
			cases_jun = "Cumulative number of cases reported by the 1st of the month in Jun"
			cases_jul = "Cumulative number of cases reported by the 1st of the month in July"
			cases_aug = "Cumulative number of cases reported by the 1st of the month in August"
			cases_last = "Last reported cumulative number of cases reported to WHO as of August 9, 2009"
			cont_death = "1st Death ID (X.YY) where X represents continent X, and YY represents the YYth country with the next first death"	
			date_firstdeath	= "Date of first death"
			deaths_may = "Cumulative number of deaths reported by the 1st of the month in May"
			deaths_jun = "Cumulative number of deaths reported by the 1st of the month in June"
			deaths_jul = "Cumulative number of deaths reported by the 1st of the month in July"
			deaths_aug = "Cumulative number of deaths reported by the 1st of the month in August"
			deaths_sep = "Cumulative number of deaths reported by the 1st of the month in September"
			deaths_oct = "Cumulative number of deaths reported by the 1st of the month in October"
			deaths_nov = "Cumulative number of deaths reported by the 1st of the month in November"
			deaths_dec = "Cumulative number of deaths reported by the 1st of the month in December"
	;
RUN;

*Part C - use PROC CONTENTS to print contents of the dataset ;
PROC CONTENTS data = swineflu varnum;
RUN;

* To be fair this is just a copy/paste of how I solved the data input for a chapter 3 programming
exercise ;

* Part A - Read data ;
DATA icecream;
	INFILE '/home/u49657251/little_sas_book/data/BenAndJerrys.dat' 
	DSD DLM = "," 
	TRUNCOVER
	ENCODING=WLATIN1; 
	INPUT flavor :$200. portion_size_g calories calories_fat fat_g saturated_fat_g trans_fat_g cholesterol_mg sodium_mg
		  carbs_g fiber_g $ sugar_g protein_g introduced_year retired_year description :$200. notes :$200.;
RUN;

* Part B - print data ;
PROC PRINT data = icecream;
RUN;