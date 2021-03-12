/*
* Chapter 1;
*/
DATA animals;
	INFILE 'c:\MyRawData\Zoo.dat';
	INPUT Lions Tigers;
RUN;


* Compute the body mass index using pounds and inches;
DATA bodymass;
	Weight = 150;
	Height = 68;
	BMI = (Weight / Height ** 2) * 703;
RUN;

PROC PRINT data = bodymass;

* 2) BMI calculates to 22.804930796;
* 3) Weight, Height, and BMI are all numeric variables of length 8;


OPTIONS NOCENTER;

PROC OPTIONS;

* MISSING=.         Specifies the character to print for missing numeric values. ;
* OBS=9223372036854775807
                    Specifies the observation that is used to determine the last observation to process, or specifies the last 
                    record to process. ;
* PAPERSIZE=LETTER  Specifies the paper size to use for printing. ;
*   YEARCUTOFF=1926   Specifies the first year of a 100-year span that is used by date informats and functions to read a two-digit 
                    year. ;
* NOCENTER          Left-align SAS procedure output. ;

OPTIONS NONUMBER;

DATA info;
	City = "Sao Paulo";
	* Semicolon missing for exercise ;
	* Omitting smicolon produces 1 error, 2 warnings, and 3 notes;
	Country = "Brazil";
	CountryCode = 55;
	CityCode = 11;
RUN;

* Once corrected, the DATA step produces a data set with 1 observation and 4 variables;