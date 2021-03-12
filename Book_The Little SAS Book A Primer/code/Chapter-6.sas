/*
* Chapter 6;
*/

/* Section 6.1 */

/* First Program */
* Create permanent SAS data set trains; 
DATA 'c:\MySASLib\trains';    
   INFILE 'c:\MyRawData\Train.dat';    
   INPUT Time TIME5. Cars People; 
RUN;
	
/* Second Program */
* Read the SAS data set trains with a SET statement;
DATA averagetrain;
   SET 'c:\MySASLib\trains';
   PeoplePerCar = People / Cars;
RUN;
PROC PRINT DATA = averagetrain;
   TITLE 'Average Number of People per Train Car';
   FORMAT Time TIME5.;
RUN;


/* Section 6.2 */
	
/* Program */	
DATA southentrance;
   INFILE 'c:\MyRawData\South.dat';
   INPUT Entrance $ PassNumber PartySize Age;
PROC PRINT DATA = southentrance;
   TITLE 'South Entrance Data';
RUN;
DATA northentrance;
   INFILE 'c:\MyRawData\North.dat';
   INPUT Entrance $ PassNumber PartySize Age Lot;
PROC PRINT DATA = northentrance;
   TITLE 'North Entrance Data';
RUN; 

* Create a data set, both, combining northentrance and southentrance;
* Create a variable, AmountPaid, based on value of variable Age;
DATA both;
   SET southentrance northentrance;
   IF Age = . THEN AmountPaid = .;
      ELSE IF Age < 3  THEN AmountPaid = 0;
      ELSE IF Age < 65 THEN AmountPaid = 35;
      ELSE AmountPaid = 27;
PROC PRINT DATA = both;
   TITLE 'Both Entrances';
RUN;


/* Section 6.3 */
/* Program */	
DATA southentrance;
   INFILE 'c:\MyRawData\South.dat';
   INPUT Entrance $ PassNumber PartySize Age;
PROC PRINT DATA = southentrance;
   TITLE 'South Entrance Data';
RUN;
DATA northentrance;
   INFILE 'c:\MyRawData\North.dat';
   INPUT Entrance $ PassNumber PartySize Age Lot;
PROC SORT DATA = northentrance;
   BY PassNumber;
PROC PRINT DATA = northentrance;
   TITLE 'North Entrance Data';
RUN;
* Interleave observations by PassNumber;
DATA interleave;
   SET northentrance southentrance;
   BY PassNumber;
PROC PRINT DATA = interleave;
   TITLE 'Both Entrances, By Pass Number';
RUN;


/* Section 6.4 */

/* Program */

DATA descriptions;     
   INFILE 'c:\MyRawData\chocolate.dat' TRUNCOVER;    
   INPUT CodeNum $ 1-4 Name $ 6-14 Description $ 15-60; 
RUN;
DATA sales;    
   INFILE 'c:\MyRawData\chocsales.dat';    
   INPUT CodeNum $ 1-4 PiecesSold 6-7; 
PROC SORT DATA = sales;
   BY CodeNum;
RUN;
* Merge data sets by CodeNum;
DATA chocolates;    
   MERGE sales descriptions;    
   BY CodeNum;
PROC PRINT DATA = chocolates;   
   TITLE "Today's Chocolate Sales"; 
RUN;

/* Section 6.5 */

/* Program */	
DATA regular;
   INFILE 'c:\MyRawData\Shoe.dat';
   INPUT Style $ 1-15 ExerciseType $ RegularPrice;
PROC SORT DATA = regular;
   BY ExerciseType;
RUN;
DATA discount;
   INFILE 'c:\MyRawData\Disc.dat';
   INPUT ExerciseType $ Adjustment;
RUN;
* Perform many-to-one match merge;
DATA prices;
   MERGE regular discount;
   BY ExerciseType;
   NewPrice = ROUND(RegularPrice - (RegularPrice * Adjustment), .01);
PROC PRINT DATA = prices;
   TITLE 'Price List for May';
RUN;


/* Section 6.6 */

/* Program */
DATA shoes;
   INFILE '/home/u49657251/little_sas_book/Shoesales.dat';
   INPUT Style $ 1-15 ExerciseType $ Sales;
PROC SORT DATA = shoes;
   BY ExerciseType;
RUN;
* Summarize sales by ExerciseType and print;
PROC MEANS NOPRINT DATA = shoes;
   VAR Sales;
   BY ExerciseType;
   OUTPUT OUT = summarydata SUM(Sales) = Total;
PROC PRINT DATA = summarydata;
   TITLE 'Summary Data Set';
RUN;
* Merge totals with the original data set;
DATA shoesummary;
   MERGE shoes summarydata;
   BY ExerciseType;
   Percent = Sales / Total * 100;
PROC PRINT DATA = shoesummary;
   BY ExerciseType;
*   ID ExerciseType;
   VAR Style Sales Total Percent;
   TITLE 'Sales Share by Type of Exercise';
RUN;
	

/* Section 6.7 */
/* Program */
DATA shoes;
   INFILE '/home/u49657251/little_sas_book/Shoesales.dat';
   INPUT Style $ 1-15 ExerciseType $ Sales;
RUN;
* Output grand total of sales to a data set and print;
PROC MEANS NOPRINT DATA = shoes;
   VAR Sales;
   OUTPUT OUT = summarydata SUM(Sales) = GrandTotal;
PROC PRINT DATA = summarydata;
   TITLE 'Summary Data Set';
RUN;
* Combine the grand total with the original data;
DATA shoesummary;
   IF _N_ = 1 THEN SET summarydata;
   SET shoes;
   Percent = Sales / GrandTotal * 100;
PROC PRINT DATA = shoesummary;
   VAR Style ExerciseType Sales GrandTotal Percent;
   TITLE 'Overall Sales Share';
RUN;

/* Section 6.8 */

/* First Program */	
LIBNAME perm '/home/u49657251/little_sas_book';
DATA perm.patientmaster;
   INFILE '/home/u49657251/little_sas_book/Admit.dat';
   INPUT Account LastName $ 8-16 Address $ 17-34
      BirthDate MMDDYY10. Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
RUN;


/* Second Program */
LIBNAME perm '/home/u49657251/little_sas_book';
DATA transactions;
   INFILE '/home/u49657251/little_sas_book/NewAdmit.dat';
   INPUT Account LastName $ 8-16 Address $ 17-34 BirthDate MMDDYY10. 
      Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
PROC SORT DATA = transactions;
   BY Account;
RUN;
* Update patient data with transactions;
DATA perm.patientmaster;
   UPDATE perm.patientmaster transactions;
   BY Account;
PROC PRINT DATA = perm.patientmaster;
   FORMAT BirthDate LastUpdate MMDDYY10.;
   TITLE 'Admissions Data';
RUN;


/* Section 6.9 */

/* Program */	
DATA morning afternoon;
   INFILE 'c:\MyRawData\Zoo.dat';
   INPUT Animal $ 1-9 Class $ 11-18 Enclosure $ FeedTime $;
   IF FeedTime = 'am' THEN OUTPUT morning;
      ELSE IF FeedTime = 'pm' THEN OUTPUT afternoon;
      ELSE IF FeedTime = 'both' THEN OUTPUT;
RUN;
PROC PRINT DATA = morning;
   TITLE 'Animals with Morning Feedings';
PROC PRINT DATA = afternoon;
   TITLE 'Animals with Afternoon Feedings';
RUN;

	
/* Section 6.10 */
/* First Program */	
* Create data for variables x and y;
DATA generate;
   DO x = 1 TO 6;
      y = x ** 2;
      OUTPUT;
   END;
PROC PRINT DATA = generate;
   TITLE 'Generated Data';
RUN;


/* Second Program */
* Create three observations for each data line read
*   using three OUTPUT statements;
DATA theaters;
   INFILE 'c:\MyRawData\Movies.dat';
   INPUT Month $ Location $ Tickets @;
   OUTPUT;
   INPUT Location $ Tickets @;
   OUTPUT;
   INPUT Location $ Tickets;
   OUTPUT;
RUN;
PROC PRINT DATA = theaters;
   TITLE 'Ticket Sales';
RUN;
	
	
/* Section 6.12 */

/* Program */
DATA customer;
   INFILE 'c:\MyRawData\CustAddress.dat' TRUNCOVER;
   INPUT CustomerNumber Name $ 5-21 Address $ 23-42;
DATA orders;
   INFILE 'c:\MyRawData\OrdersQ3.dat';
   INPUT CustomerNumber Total;
PROC SORT DATA = orders;
   BY CustomerNumber;
RUN;
* Combine the data sets using the IN= option;
DATA noorders;
   MERGE customer orders (IN = Recent);
   BY CustomerNumber;
   IF Recent = 0;
PROC PRINT DATA = noorders;
   TITLE 'Customers with No Orders in the Third Quarter';
RUN;


	
/* Section 6.13 */

/* Program */
*Input the data and create two subsets;
DATA tallpeaks (WHERE = (Height > 6000))
     american (WHERE = Continent CONTAINS (�America�)));
   INFILE 'c:\MyRawData\Mountains.dat';
   INPUT Name $1-14 Continent $15-28 Height;
RUN;
PROC PRINT DATA = tallpeaks;
   TITLE 'Members of the Seven Summits above 6,000 Meters';
PROC PRINT DATA = american; 
   TITLE 'Members of the Seven Summits in the Americas';
RUN;	

/* Section 6.14 */

/* Program */
DATA baseball;
   INFILE 'c:\MyRawData\Transpos.dat';
   INPUT Team $ Player Type $ Entry;
PROC SORT DATA = baseball;
   BY Team Player;
PROC PRINT DATA = baseball;
   TITLE 'Baseball Data After Sorting and Before Transposing';
RUN;
* Transpose data so salary and batavg are variables;
PROC TRANSPOSE DATA = baseball OUT = flipped;
   BY Team Player;
   ID Type;
   VAR Entry;
PROC PRINT DATA = flipped;
   TITLE 'Baseball Data After Transposing';
RUN;

/* Section 6.15 */

/* Program */	

DATA walkers;   
   INFILE 'c:\MyRawData\Walk.dat';   
   INPUT Entry AgeGroup $ Time @@; 
PROC SORT DATA = walkers;    
   BY Time; 
* Create a new variable, Place; 
DATA ordered;    
   SET walkers;
   Place = _N_;
PROC PRINT DATA = ordered;
  TITLE 'Results of Walk';

PROC SORT DATA = ordered;
   BY AgeGroup Time;
* Keep the first observation in each age group;
DATA winners;
   SET ordered;
   BY AgeGroup;
   IF FIRST.AgeGroup = 1;
PROC PRINT DATA = winners;
   TITLE 'Winners in Each Age Group';
RUN;

libname ch6 "/home/u49657251/little_sas_book/data/Chapter6_data";

/* Create new variable for name popularity for each input data set. 
Variable names between data sets are not the same, only labels.  Girl is
Menina in Brazil data, Devushka in Russian data set, etc.  Rename columns
by column position, first column contains girl names, second column boy names,
and observation number is the ranking. */

%macro addrank(data=,);
*Set input data set and create variables for popularity equal to obs number;
data &data._rankings;
	set ch6.&data.(obs=10);
	PopularGirl = _n_ ;
	PopularBoy = _n_ ; 
	Country = "&data.";
run;

*Transpose data such that each obseravtion is a variable name;
proc transpose data=&data._rankings(obs=0) out=vars;
   var _all_;
run;

*Create new temporary file;
filename FT76F001 temp;

*Write instructions for proc datasets to rename variables into temp text file;
data _null_;
	file FT76F001;
	set vars;
	put 'Rename ' _name_ '=Col' _n_ ';';
run;

*Use proc datasets and temp text file instructions to rename variables;
proc datasets nolist;
	modify &data._rankings;
	%inc FT76F001;
run;
quit;

%mend addrank;

/* Call macro on each data set */
%addrank(data=unitedstates);
%addrank(data=russia);
%addrank(data=india);
%addrank(data=france);
%addrank(data=brazil);
%addrank(data=australia);

/* Combine data set and sort by popularity. */
data merged_ranks(rename=(Col1=Girls Col2=Boys Col5=Country) drop=Col3 Col4);
	set unitedstates_rankings russia_rankings india_rankings
		france_rankings brazil_rankings australia_rankings;
	by  col3 col4;
run;

libname ch6 "/home/u49657251/little_sas_book/data/Chapter6_data";

/* Sort TEACHERS.  DISTRICT is already sorted */
proc sort data = ch6.teachers out = work.teachers_sort;
	by TeacherScore CurriculumGrd;
run;

/* Merge the DISTRICT and TEACHERS SAS data sets and remove observations that do not
correspond to a teacher */
data teachers_join;
	merge ch6.district (rename=(TS=TeacherScore CG=CurriculumGrd)) work.teachers_sort;
	by TeacherScore CurriculumGrd;
	if Teacher ^= "";
run;

/* Sort joined data set, overwrite original data */
proc sort data = teachers_join;
	by Teacher;
run;

libname ch6 "/home/u49657251/little_sas_book/data/Chapter6_data";

/* sort data by year and commodity for use in proc means and proc transpose */
proc sort data = ch6.aveprices out = work.prices_sort;
	by year commodity;
run;

/* part a - yearly mean of each commodity */
proc means data = work.prices_sort noprint;
	by year commodity;
	output out = price_means(drop = _type_ _freq_) mean(price) = YearMeanPrice;
run;

/* part b - transpose monthly price to new variaible */
proc transpose data = work.prices_sort prefix = Month out = work.prices_transpose(drop = _label_ _name_);
	by year commodity;
	var price;
run;

/* part c - merge data from parts a and b */
data price_merged;
	merge prices_transpose price_means;
	by year commodity;
run;

/* part d - write outputs depending on commodity using one data step */
data eggs gas milk;
	set price_merged;
	if commodity = "Egg" then output eggs;
	else if commodity = "Gas" then output gas;
	else if commodity = "Milk" then output milk;
run;

/* part e - modify part d to give better names to month variables.  This was already
done in part b using the prefix option of proc transpose */

/* part f - comment on data sets created
data sets containing monthly average price and yearly average price for eggs, gas, and
milk created. Each data set contains a variable for year, commodity, month1-month12, and
the yearly mean commodity price */

libname ch6 "/home/u49657251/little_sas_book/data/Chapter6_data";

/* part a - join visist and txgroup data sets 
*part b - address duplicate entries in txgroup before merge */

/* Examine txgroup data to find which subjects contain duplicate
entries */

proc freq data = ch6.txgroup noprint;
	by id;
	tables id tx / out = subject_duplicates;
run;

proc print data = subject_duplicates;
	title "Duplicate subjects in txgroup data set";
	where count > 1;
run;

/* Use proc sort nodup option to remove duplicate subjects
upon sorting */

proc sort data = ch6.visits out = visits_sort nodup;
	by id;
run;

proc sort data = ch6.txgroup out = txgroup_sort nodup;
	by id;
run;

/* Merge sorted data sets with duplicate subjects removed */
data complete;
	merge visits_sort txgroup_sort;
	by id;
run;

/* part c - calculate the median baseline cholesterol and group
patients into groups either above or below median baseline cholesterol */
proc means data = ch6.visits median noprint;
	var b_cholesterol;
	output out = median_cholesterol median(b_cholesterol) = chol_median;
run;

/* use call symput to get median baseline cholesterol */
data _null_;
	set median_cholesterol;
	call symput("med", chol_median);
run;

%put Median baseline cholesterol value is &med;

data complete_groups;
	set complete;
	length Group $40;
	if b_cholesterol <= &med then group = "Less than or equal to median";
	else if b_cholesterol > &med then group = "Greater than median";
	else group = "Unknown"; 
run;

/* part d - schedule new visits every 30 days from baseline 
SAS arrays do not work with index beginning at 0. */
data schedule(rename=(visitdt=visitnumber0));
	set complete_groups;

	array visitday (3) visitnumber1-visitnumber3;
	do i = 1 to 3 by 1;
		visitday(i) =  visitdt + (i * 30);
	end;
	
	drop visit i;
	format visitdt mmddyy10. visitnumber1-visitnumber3 mmddyy10.;
run;

libname ch6 "/home/u49657251/little_sas_book/data/Chapter6_data";

/* part a - the data set is sorted by student_id.  This is a bit more
obvious if we re-sort the dataframe by family_id instead. */

proc sort data = ch6.schoolsurvey out = schoolsurvey_sort;
	by family_id;
run;

/* part b - create a dataset that has one observation for every
6th grader.  Use data sorted by family id for merge in part c 
and drop/rename variables as needed so they appear correctly in merge*/

data grade6(drop = school grade student_id rename=(dob = grade6dob));
	set schoolsurvey_sort;
	if grade = '6th';
run;

/* part c - recombine the data from part b with the original data
and calculate the age difference between 6th graders and their siblings */
data grade6_merge;
	merge schoolsurvey_sort grade6;
	by family_id;

	agediff = dob - grade6dob;
run;

/* part d - calculate number of younger and older siblings of each 6th grader 
and add back to the subset of just 6th graders
Note: family_id is not needed in a BY statement because the variable is already
present in a TABLES statement. */
proc freq data = grade6_merge noprint;
	where agediff < 0;
	tables family_id / out = older_freq(drop = percent rename = (COUNT = NumOlderSiblings));
run;

proc freq data = grade6_merge noprint;
	where agediff > 0;
	tables family_id / out = younger_freq(drop = percent rename = (COUNT = NumYoungerSiblings));
run;

data grade6_siblings_freq(drop = grade6dob agediff);
	merge grade6_merge older_freq younger_freq;
	by family_id;
	gradecount = 1;
	if grade = "6th";
run;

/* Compute the number of 6th graders, younger siblings, and older siblings by
school.  Display the label for each school in output */
proc tabulate data = grade6_siblings_freq;
	class school;
	var numoldersiblings numyoungersiblings gradecount;
	table school , sum*(gradecount="Total 6th Graders" numoldersiblings="# Older Siblings" numyoungersiblings="# Younger Siblings");
run;



