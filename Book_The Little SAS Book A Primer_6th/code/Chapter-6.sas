/*
* Chapter 6;
*/
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



