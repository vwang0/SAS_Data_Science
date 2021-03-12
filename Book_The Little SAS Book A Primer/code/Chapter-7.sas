/*
* Chapter 7;
*/

/* Section 7.2 */

/* Program */
%LET flowertype = Ginger;

* Read the data and subset with a macro variable;
DATA flowersales;
   INFILE 'c:\MyRawData\TropicalSales.dat';
   INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
   IF Variety = "&flowertype";
RUN;
* Print the report using a macro variable;
PROC PRINT DATA = flowersales;
   FORMAT SaleDate WORDDATE18.;
   TITLE "Sales of &flowertype";
RUN;

/* Section 7.3 */
/* Program */
* Macro to print 5 largest sales;
%MACRO sample;
   PROC SORT DATA = flowersales;
      BY DESCENDING Quantity;
   RUN;
   PROC PRINT DATA = flowersales (OBS = 5);
      FORMAT SaleDate WORDDATE18.;
      TITLE 'Five Largest Sales';
   RUN;
%MEND sample;

* Read the flower sales data;
DATA flowersales;
   INFILE 'c:\MyRawData\TropicalSales.dat';
   INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;

* Invoke the macro;
%sample

/* Section 7.4 */
/* Program */
* Macro with parameters;
%MACRO select(customer=,sortvar=);
   PROC SORT DATA = flowersales OUT = salesout;
      BY &sortvar;
      WHERE CustomerID = "&customer";
   RUN;
   PROC PRINT DATA = salesout;
      FORMAT SaleDate WORDDATE18.;
      TITLE1 "Orders for Customer Number &customer";
      TITLE2 "Sorted by &sortvar";
   RUN;
%MEND select;


* Read all the flower sales data;
DATA flowersales;
   INFILE 'c:\MyRawData\TropicalSales.dat';
   INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;

*Invoke the macro;
%select(customer = 356W, sortvar = Quantity)
%select(customer = 240W, sortvar = Variety)


/* Section 7.5 */
/* Program */
%MACRO dailyreports;
   %IF &SYSDAY = Monday %THEN %DO;
      PROC PRINT DATA = flowersales;
         FORMAT SaleDate WORDDATE18.;
         TITLE 'Monday Report: Current Flower Sales';
      RUN;
   %END;
   %ELSE %IF &SYSDAY = Tuesday %THEN %DO;
      PROC MEANS DATA = flowersales MEAN MIN MAX;
         CLASS Variety;
         VAR Quantity;
         TITLE 'Tuesday Report: Summary of Flower Sales';
      RUN;
   %END;
%MEND dailyreports;
DATA flowersales;
   INFILE 'c:\MyRawData\TropicalSales.dat';
   INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;
%dailyreports

/* Section 7.6 */
/* Program */
* Read the raw data;
DATA flowersales;
   INFILE '/home/u49657251/little_sas_book/TropicalSales.dat';
   INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
PROC SORT DATA = flowersales;
   BY DESCENDING Quantity;
RUN;
* Find biggest order and pass the customer id to a macro variable;
DATA _NULL_;
   SET flowersales;
   IF _N_ = 1 THEN CALL SYMPUT("selectedcustomer",CustomerID);
   ELSE STOP;
RUN;
PROC PRINT DATA = flowersales;
   WHERE CustomerID = "&selectedcustomer";
   FORMAT SaleDate WORDDATE18.;
   TITLE "Customer &selectedcustomer Had the Single Largest Order";
RUN;

libname ch7 '/home/u49657251/little_sas_book/data/';
OPTIONS SYMBOLGEN;

/* Macro using %LET statements */

/* Part A */
%LET tableVar=Origin;
%LET dataVal=Thailand;

PROC FREQ data = ch7.cats;
	TABLES &tableVar;
	TITLE "Cat Breeds by Origin";
RUN;

PROC PRINT DATA = ch7.cats;
	WHERE &tableVar = "&dataVal";
	TITLE "Cat Breeds with &tableVar = &dataVal";
RUN;

/* Part B */
%LET tableVar=Derivation;
%LET dataVal=Mutation;

PROC FREQ data = ch7.cats;
	TABLES &tableVar;
	TITLE "Cat Breeds by &tableVar";
RUN;

PROC PRINT DATA = ch7.cats;
	WHERE &tableVar = "&dataVal";
	TITLE "Cat Breeds with &tableVar = &dataVal";
RUN;

/* Part C */
%MACRO catanalysis(tableVar=, dataVal=);
	ODS PDF FILE = "CatRpt_&tableVar..pdf";
	PROC FREQ data = ch7.cats;
		TABLES &tableVar;
		TITLE "Cat Breeds by &tableVar";
	RUN;
	
	PROC PRINT DATA = ch7.cats;
		WHERE &tableVar = "&dataVal";
		TITLE "Cat Breeds with &tableVar = &dataVal";
	RUN;
	ODS PDF CLOSE;
%MEND catanalysis;

%catanalysis(tableVar=Origin, dataVal=Thailand)
%catanalysis(tableVar=Derivation, dataVal=Mutation)


libname ch7 '/home/u49657251/little_sas_book/data/';

/* Create a macro that takes a 4-digit year and 3-character airport abbreviation as an input
and outputs a dataset with 1 observation containing the airline with the greatest number of
passengers for a given airport and year */
%MACRO mostPassengersPerYear(yearVal, airportAbbr);

/* Generate sum of passengers for all airlines at an airport for given year and sort by highest
to lowest number of passengers at airport */
PROC MEANS data = ch7.airtraffic(KEEP = Year Airline Quarter &airportAbbr.:) MAXDEC=2 NOPRINT;
	BY Airline Year;
	VAR &airportAbbr.Flights &airportAbbr.Passengers;
	OUTPUT OUT = &airportAbbr._summary(DROP = _FREQ_ _TYPE_)
		SUM(&airportAbbr.Flights &airportAbbr.Passengers) = FlightsSum PassengerSum
	;
	WHERE Year = &yearVal;

PROC SORT data = &airportAbbr._summary;
	BY DESCENDING PassengerSum;
RUN;

/* Use CALL SYMPUT to set macro variable mostpassengers equal to the airline with the most
passengers */
DATA _NULL_;
	SET &airportAbbr._summary;
	IF _N_ = 1 THEN	CALL SYMPUT("mostpassengers", Airline);
	ELSE STOP;
RUN;

/* Create the output data set where airline is equal to macro variable mostpassengers */
DATA &airportAbbr._&yearVal._summary;
	SET &airportAbbr._summary;
	AirportCode = "&airportAbbr";
	WHERE Airline = "&mostpassengers";
RUN;
%MEND mostPassengersPerYear;

/* Call macro for each of the 12 airlines for a given year and save as new data set.  Check
if there is a way to call macro directly in DATA step to minimize redundant code. */
%LET yearVal = 2010;
%mostPassengersPerYear(&yearVal, ATL)
%mostPassengersPerYear(&yearVal, BOS)
%mostPassengersPerYear(&yearVal, DEN)
%mostPassengersPerYear(&yearVal, DFW)
%mostPassengersPerYear(&yearVal, EWR)
%mostPassengersPerYear(&yearVal, HNL)
%mostPassengersPerYear(&yearVal, LAX)
%mostPassengersPerYear(&yearVal, MIA)
%mostPassengersPerYear(&yearVal, ORD)
%mostPassengersPerYear(&yearVal, SAN)
%mostPassengersPerYear(&yearVal, SEA)
%mostPassengersPerYear(&yearVal, SFO)

DATA airport_summary;
	SET 
		atl_&yearVal._summary
		bos_&yearVal._summary
		den_&yearVal._summary
		dfw_&yearVal._summary
		ewr_&yearVal._summary
		hnl_&yearVal._summary
		lax_&yearVal._summary
		mia_&yearVal._summary
		ord_&yearVal._summary
		san_&yearVal._summary
		sea_&yearVal._summary
		sfo_&yearVal._summary
	;
RUN;

libname ch7 '/home/u49657251/little_sas_book/data/';

DATA study;
	SET ch7.Studytime;
	StudyRate = Time / Units;
	FORMAT StudyRate 4.2;

PROC SORT data = study;
	BY Section;
RUN;

PROC MEANS data = study MAXDEC=2 NOPRINT;
	BY Section;
	VAR StudyRate;
	OUTPUT OUT = study_summary(DROP = _FREQ_ _TYPE_)
		MEAN(StudyRate) = AvgTimePerUnit
	;
RUN;

OPTIONS SYMBOLGEN;

%MACRO printAvgPerClass(Section=);
DATA _NULL_;
	SET study_summary;
	AvgTimePerUnit = ROUND(AvgTimePerUnit, 0.01);
	CALL SYMPUT("avgstudy", AvgTimePerUnit);
	WHERE Section = &Section;
RUN;

%IF &avgstudy > 2 %THEN %DO;
PROC PRINT data = study;
	TITLE "Average Study Time Per Student of Section &Section";
	FOOTNOTE "Note: Section &Section study time meets 2 hour minimum with an average time of &avgstudy";
	WHERE Section = &Section;
RUN;
%END;

%ELSE %IF &avgstudy <= 2 %THEN %DO;
PROC PRINT data = study;
	TITLE "Average Study Time Per Student of Section &Section";
	FOOTNOTE "Note: Section &Section study time does not meet 2 hour minimum with an average time of &avgstudy";
	WHERE Section = &Section;
RUN;
%END;

%MEND printAvgPerClass;

%printAvgPerClass(Section='01');
%printAvgPerClass(Section='02');

libname ch7 '/home/u49657251/little_sas_book/data/';
OPTIONS SYMBOLGEN;

%MACRO loan_summary(Property=, LoanAmount=);

DATA subset;
	SET ch7.loanapp;
	WHERE LoanApproved = 1 AND Price >= &LoanAmount and PropType = &Property;
PROC SORT data = subset;
	BY Branch;
RUN;

%IF &Property=1 %THEN %DO;
PROC MEANS data = subset MAXDEC=2 NOPRINT;
	BY Branch;
	VAR CreditScore Interest PercentDown;
	OUTPUT OUT = property_&Property._summary(DROP = _FREQ_ _TYPE_)
	MEAN(CreditScore Interest PercentDown) = MeanCreditScore MeanInterest MeanPercentDown
	;
RUN;

DATA property_&Property._summary;
	SET property_&Property._summary;
	LENGTH HomeType $200;

	HomeType = "Primary Residence";
	Cutoff = &LoanAmount;
RUN;
%END;

%ELSE %DO;
PROC MEANS data = subset MAXDEC=2 NOPRINT;
	VAR CreditScore Interest PercentDown;
	OUTPUT OUT = property_&Property._summary(DROP = _FREQ_ _TYPE_)
	MEAN(CreditScore Interest PercentDown) = MeanCreditScore MeanInterest MeanPercentDown
	;
RUN;

DATA property_&Property._summary;
	SET property_&Property._summary;
	LENGTH HomeType $200;

	IF &Property = 2 THEN HomeType = "Secondary Residence";
	ELSE IF &Property = 3 THEN HomeType = "Investment or Rental";
	ELSE IF &Property = 4 THEN HomeType = "Commercial Property";
	ELSE HomeType = "Unknown";
	Cutoff = &LoanAmount;
RUN;
%END;

%MEND loan_summary;

%loan_summary(Property=1, LoanAmount=800000);
%loan_summary(Property=2, LoanAmount=800000);
%loan_summary(Property=3, LoanAmount=1000000);
%loan_summary(Property=4, LoanAmount=1200000);

DATA output;
	SET
		work.property_1_summary
		work.property_2_summary
		work.property_3_summary
		work.property_4_summary
	;
RUN;

PROC PRINT data = output;
	TITLE "Summary of Approved Mortgages by Property Type";
	FORMAT 
		Cutoff DOLLAR8.
		MeanInterest 4.2
		MeanCreditScore 6.2
		MeanPercentDown 5.3
	;
RUN;
