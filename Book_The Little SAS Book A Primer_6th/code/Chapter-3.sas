/*
* Chapter 3;
*/

* Create a small dataset of cholesterol values to show that addition of variables ;
* containing missing data will result in a missing numeric result ;

DATA cholesterol;
	INPUT ID Ldl Hdl Vldl;
	Total1 = Ldl + Hdl + Vldl;
	DATALINES;
1  160 50  20
2  150 55  .
3  120 40  30
4  140 50  25
;
RUN;

* Small program to show that adding variables together with the SUM() function ;
* does not result in a missing numeric value if 1+ value is missing ;
* Sum for observation 2 is 205 even though Vldl is missing. ;

DATA cholesterol;
 INPUT ID Ldl Hdl Vldl;
 Total1 = SUM(Ldl, Hdl, Vldl);
 DATALINES;
1  160 50  20
2  150 55  .
3  120 40  30
4  140 50  25
;
RUN;

DATA phrase;
 INPUT ID original_phrase $ 2-50;
 better_phrase = TRANWRD(original_phrase, 'cat', 'dog');
 DATALINES;
1  A cat is the best pet ever, I love my cat.
;
RUN;

* Small program to demonstrate use of MEAN() function. ;
DATA ints;
 INPUT ID X1 X2 X3;
 mu = MEAN(X1, X2, X3);
 DATALINES;
1 22 23 24
2 20 90 29
3 39 12 12
4 93 10 91
;
RUN;


* Fun with functions.  x will be equal to 1;
* SUM(1,2,3) is equal to 6;
* 56/6 = 9.333;
* N(8) equals 1.  N() is used to count number of non-missing values;
DATA answer;
	x = MIN(SUM(1,2,3), 56/8, N(8));
RUN;

PROC PRINT data=answer;
RUN;

* Simple SAS program to demonstrate IF/ELSE IF use.  Because we are using;
* a logical statement to check for Group C condition, we must use an;
* ELSE IF statement.  Substituting an ELSE statement for the last ELSE IF;
* statement will result in an error;

DATA age;
 INPUT ID Age;
 IF 0 <= Age <= 50 THEN Group = 'A';
 ELSE IF 50 <= Age <= 70 THEN Group = 'B';
 ELSE IF Age > 70 THEN Group = 'C';
 DATALINES;
1  18
2  50
3  65
4  70
5  71
;
RUN;

* Example of a subsetting IF statement;
* The first IF statement controls whether or not an observation;
* will be read.  If the first IF statement is true then the second;
* if statement is executed;

DATA pts;
 INPUT ID Age Gender $;
 IF Age < 75;
 IF Age < 50 AND Gender = 'female' THEN Guideline = 'Inv4a';
 ELSE IF Age >= 50 AND Gender = 'female' THEN Guideline = 'Inv4b';
 ELSE Guideline = 'n/a';
 DATALINES;
41  25  male
32  79  female
36  52  female
74  63  male
76  70  male
77  65  female
;
RUN;

* Little SAS Book Exercises and Projects example to show;
* How setting YEARCUTOFF to a date after a date in the raw;
* data will effect the output when using MMDDYY10. format;

* YEARCUTOFF specifies the first 100 year span for SAS to use;
* and the output in MMDDYY10. format for 01/01/1920 read in using;
* MMDDYY8. format with YEARCUTOFF=1950 will be 01/01/2019;

OPTIONS YEARCUTOFF=1950;

DATA datetest;
 INPUT date MMDDYY8.;
 DATALINES;
01/01/1920
;
 RUN;
 
PROC PRINT data = datetest;
  FORMAT date MMDDYY10.;
RUN;

* Example of the QTR() function.  Returns Quarter = 2;

DATA pts;
  Quarter = QTR(MDY(04,05,2063))
;
RUN;

* Simple example of a sum statement;
* A sum statement takes the form of variable + expression;
* Use a sum statement to get cumulative sum in a dummy data;
* set;

DATA sumexample;
 INPUT Number;
 CUMSUM + Number;
 DATALINES;
1
6
10
11.1
18
5.6
1.1
;
RUN;

 INPUT Age Gender $;
 IF 4 <= Age AND Age < 9 THEN Group = 1;
 ELSE IF 9 <= Age AND Age < 13 THEN Group = 2;
 ELSE IF Age >= 13 THEN Group = 3;
 ELSE Group = 4;
 DATALINES;
4   male
1   female
2   male
3   female
8   female
9   male
12  male
70  male
65  female
;
RUN;


* Classify risk group of smokers by breaking original elseif statements into;
* one block for smokers and one block for non-smokers.  Test with dummy data;
* from DATALINES;

DATA smokers;
	INPUT Smoke Sbp Dbp ;
	LENGTH Risk $ 8;
	FORMAT Risk $8.;
	
	* Risk groups for smokers;
	IF Smoke > 0 THEN DO;
		IF Sbp >= 140 OR Dbp >= 90 THEN Risk = "Severe";
		ELSE IF (Sbp >= 120 AND Sbp < 140) OR (Dbp >= 80 AND Dbp < 90 ) THEN Risk = "High";
		ELSE IF (Sbp > 0 AND Sbp < 120) OR (Dbp > 0 AND Dbp < 80) THEN Risk = "Medium";
		ELSE Risk = "Unknown";
	END;
	
	* Risk groups for non-smokers;
	ELSE IF Smoke = 0 THEN DO;
		IF Sbp >= 140 OR Dbp >= 90 THEN Risk = "High";
		ELSE IF (Sbp >= 120 AND Sbp < 140) OR (Dbp >= 80 AND Dbp < 90 ) THEN Risk = "Medium";
		ELSE IF (Sbp > 0 AND Sbp < 120) OR (Dbp > 0 AND Dbp < 80) THEN Risk = "Low";
		ELSE Risk = "Unknown";
	END;
	
	ELSE Risk = "Unknown";
	
* Test with some dummy data;
DATALINES;
1 140 80
1 130 90
1 120 100
1 110 85
1 100 75
1 75 75
0 140 80
0 130 90
0 120 100
0 110 85
0 100 75
0 75 75
1 0 0
0 0 0
;

RUN;

* Total charges for room 211 is $1354.50 ;

DATA hotelstemp;
INFILE "/home/u49657251/little_sas_book/data/Hotel.dat";
INPUT 
	room 
	num_guests 
	_checkin_month 
	_checkin_day 
	_checkin_year 
	_checkout_month 
	_checkout_day 
	_checkout_year
	used_internet $
	internet_use_days 49-52
	room_type $ 53-68
	room_rate ;
RUN;

PROC PRINT data = hotelstemp;
	TITLE 'Original Data';
RUN;

DATA hotels;
SET hotelstemp;
date_in=input(catx('-',_checkin_year,_checkin_month,_checkin_day),yymmdd10.);
date_out=input(catx('-',_checkout_year,_checkout_month,_checkout_day),yymmdd10.);
stay_length_days = date_out - date_in;
room_charge = stay_length_days * room_rate;
added_guest_fee = (num_guests - 1) * 10 * stay_length_days;
internet_fee = 9.95 + (internet_use_days * 4.95);
total_charges = sum(room_charge, added_guest_fee, internet_fee);
grand_total = total_charges + (total_charges * 0.075);
FORMAT 
	date_in yymmdd10.
	date_out yymmdd10.;
DROP _:;

RUN;

PROC PRINT data = hotels;
	TITLE 'Processed Data';
RUN;

DATA employees;

* Read the raw data file.  TRUNCOVER option is needed because each line is of different length due to ;
* the varying lengths of job title. ;

* William Stone will make $89,648.68 after a 2.5% pay increase which includes a $1000.00 bonus.;
* Mark Harrison will reach salary cap of $85,000.00 after a 2.5% pay increase and will not received a bonus.;

INFILE "/home/u49657251/little_sas_book/data/Employees.dat" TRUNCOVER;

INPUT 
	SSN $11.
	Name $ 16-46
	DOB DATE9.
	Grade $ 
	Salary_Month DOLLAR10.2 
	Title $ 73-99 ;	
	Age_At_Revew = INT(YRDIF(DOB, TODAY(), "AGE"));
	
* Create minimum and maximum salary bands per paygrade;	
IF Grade = "GR20" THEN DO;
	MinSalary = 50000.00;
	MaxSalary = 70000.00;
END;

ELSE IF Grade = "GR21" THEN DO;
	MinSalary = 55000.00;
	MaxSalary = 75000.00;
END;
	
ELSE IF Grade = "GR22" THEN DO;
	MinSalary = 60000.00;
	MaxSalary = 85000.00;
END;
	
ELSE IF Grade = "GR23" THEN DO;
	MinSalary = 70000.00;
	MaxSalary = 100000.00;
END;	

ELSE IF Grade = "GR24" THEN DO;
	MinSalary = 80000.00;
	MaxSalary = 120000.00;
END;	

ELSE IF Grade = "GR25" THEN DO;
	MinSalary = 100000.00;
	MaxSalary = 150000.00;
END;	

ELSE IF Grade = "GR26" THEN DO;
	MinSalary = 120000.00;
	MaxSalary = 200000.00;
END;	
	
ELSE DO
	MinSalary = .;
	MaxSalary = .;
END;
	
* Calculate expected annual salary after 2.5% raise, capping;
* salary at MaxSalary if the raise puts them at the top of a payband;

IF (Salary_Month * 12 * 1.025) > MaxSalary THEN 
	Expected_Salary = MaxSalary;
ELSE 
	Expected_Salary = (Salary_Month * 12 * 1.025);

* Give a $1000.00 bonus to leads, directors, and managers.;
IF FINDW(Title, "Lead") THEN DO;
	Expected_Salary = Expected_Salary + 1000.00;
	Bonus = "Yes";
END;

ELSE IF FINDW(Title, "Manager") THEN DO;
	Expected_Salary = Expected_Salary + 1000.00;
	Bonus = "Yes";
END;

ELSE IF FINDW(Title, "Director") THEN DO;
	Expected_Salary = Expected_Salary + 1000.00;
	Bonus = "Yes";
END;
	
ELSE DO;
	Expected_Salary = Expected_Salary;
	Bonus = "No";
END;
	
FORMAT 
	DOB DATE9.
	Salary_Month DOLLAR10.2
	MinSalary DOLLAR10.2
	MaxSalary DOLLAR10.2
	Expected_Salary DOLLAR10.2
;

RUN;

PROC PRINT data = employees;
WHERE Name IN ("William Stone", "Mark Harrison");
RUN;

DATA conference;

INFILE "/home/u49657251/little_sas_book/data/Conference.dat" TRUNCOVER;

INPUT 
	first_name $
	last_name $
	attendee_id
	business_phone $ 47-59 
	home_phone $ 61-73
	mobile_phone $ 75-87
	ok_business $
	ok_home $
	ok_mobile $
	registration_rate
	wednesday_mixer $
	thursday_lunch $
	will_volunteer $
	dietary_restrictions $ 117-150;

/* Phone numbers have very consistent format */
IF length(business_phone) = 13 THEN area_code = substr(business_phone, 2, 3);
ELSE IF length(home_phone) = 13 THEN area_code = substr(home_phone, 2, 3);
ELSE IF length(mobile_phone) = 13 THEN area_code = substr(mobile_phone, 2, 3);
ELSE area_code = "None";

IF findw(upcase(dietary_restrictions), "VEGAN") THEN vegan_veg_meal = 1;
ELSE IF findw(upcase(dietary_restrictions), "VEGETARIAN") THEN vegan_veg_meal = 1;
ELSE vegan_veg_meal = 0;

	
* Seems kind of silly in retrospect to do an array for recoding one variable, ;
* but wanted some practice with SAS arrays ;	
ARRAY type registration_rate;
DO OVER type;
	IF registration_rate = 350 THEN attendee_type = "Academic Regular";
	ELSE IF registration_rate = 200 THEN attendee_type = "Student Regular";
	ELSE IF registration_rate = 450 THEN attendee_type = "Regular";	
	ELSE IF registration_rate = 295 THEN attendee_type = "Academic Early";	
	ELSE IF registration_rate = 150 THEN attendee_type = "Student Early";	
	ELSE IF registration_rate = 395 THEN attendee_type = "Early";
	ELSE IF registration_rate = 550 THEN attendee_type = "On-Site";	
	ELSE attendee_type = "Unknown";
END;	
RUN;	

PROC PRINT data = conference;
WHERE attendee_id IN (1082, 1083);
RUN;

DATA rose_input;
INFILE "/home/u49657251/little_sas_book/data/RoseBowl.dat";
INPUT 
	game_date MMDDYY10.
	winning_team $ 12-37
	winning_score
	losing_team $ 41-66
	losing_score	
;
	score_diff = winning_score - losing_score;

FORMAT
	game_date WEEKDATE29.
;
RUN;

* There has to be a better way to do this instead of using so many proc sort statements;
PROC SORT DATA = rose_input OUT = date_sort;
	BY game_date winning_team;
RUN;

* Get cumulative sum of games ordered by date;
DATA number_games;
SET date_sort;
	total_games + 1;
RUN;

* Sort by team to calculate cumulative wins per team;
PROC SORT DATA = number_games OUT = team_sort;
	BY winning_team game_date;
RUN;

* Cumulative sum by winning_team;
DATA cumulative_team_wins;
SET team_sort;
BY winning_team;
IF first.winning_team THEN total_wins = 0;
total_wins + 1;
IF last.winning_team THEN total_wins = total_wins;
RUN;


PROC PRINT data = cumulative_team_wins;
RUN;

* Read data file;
DATA newyear;
* 	INFILE "U:/Little-SAS-Book-Exercises-And-Projects/data/EPLSB5data/Chapter3_data/NewYears.dat" DSD TRUNCOVER;
	INFILE '/home/u49657251/little_sas_book/data/NewYears.dat'  DSD TRUNCOVER; 
	INPUT id (in1-in119 out1-out119) (:TIME8.) ;
	FORMAT in1-in119 TIME8. out1-out119 TIME8.;
RUN;

* Calculate the length of each visit;
DATA visitlength (KEEP = id gym_visit1-gym_visit119);
	SET newyear;
	ARRAY in {119} in1-in119;
	ARRAY out {119} out1-out119;
	ARRAY diff {119} gym_visit1-gym_visit119;
	DO n=1 TO 119;
		IF out{n} > . THEN diff{n} = (out{n} - in{n}) / 60;
	END;
RUN;

* Set flag for disount to 1 (yes) for all members.  If one visit is;
* less than 30 minutes in length set flag to 0 (no) and leave DO loop;
* Calculate mean time of each user in minutes;
DATA discount (KEEP = id Has_Discount Visits_Over_30_Min Mean_Duration);
	SET visitlength;
	Visits_Over_30_Min = 0;
	Mean_Duration = MEAN(of gym_visit1-gym_visit119);
	ARRAY disc {119} gym_visit1-gym_visit119;
	DO i=1 to 119;
		IF disc{i} > 30 THEN Visits_Over_30_Min + 1;
	END;
	
	IF Visits_Over_30_Min = 119 THEN Has_Discount = 1;
	ELSE Has_Discount = 0;
RUN;


* Exercise was done with SAS University Edition, which by default uses UTF-8 encoding ;
* Encoding must be set to WLATIN1 in DATA step for data to import correctly ;
DATA icecream;
	INFILE '/home/u49657251/little_sas_book/data/BenAndJerrys.dat'  
	DSD DLM = "," 
	TRUNCOVER
	ENCODING=WLATIN1; 
	INPUT flavor :$200. portion_size_g calories calories_fat fat_g saturated_fat_g trans_fat_g cholesterol_mg sodium_mg
		  carbs_g fiber_g $ sugar_g protein_g introduced_year retired_year description :$200. notes :$200.;
RUN;

* Create a subset of non-retired icecreams that were not "Scoop Shop" ;
* exclusives. ;
DATA icecream_current;
	SET icecream;
	IF (retired_year > .) THEN DELETE;
	IF (INDEX(notes, "Scoop Shop") > 0) THEN DELETE;
RUN;

* Calculate calories per tablespoon. ;
DATA calories_tbs;
	SET icecream_current;
	Tbs_Per_Serving = portion_size_g / 15;
	calories_tbs = calories / Tbs_Per_Serving;
	
	IF calories_tbs = . THEN DELETE;
RUN;

* Calculate running total of calories consumed if one were to eat one ;
* tablespoon of each icecream ;
DATA cumulative_sampling;
	SET calories_tbs;
	cumulative_calories + calories_tbs;
RUN;

* Create a new variable that retains the highest calorie icecream ;
* from one observation to the next. ;
DATA highest_calories;
	SET cumulative_sampling;
	RETAIN MaxCalories;
	MaxCalories = MAX(MaxCalories, calories);
RUN;

* The total number of calories consumed for eating a tablespoon of each ;
* icecream is 2135.9939433 and the most caloric icecream is 340 calories ;
* per serving. ;

filename wl "/home/u49657251/little_sas_book/data/WLSurveys.dat";

/* Read tab delimited raw data file */
data weightloss;
	infile	wl 
			dsd dlm = "09"x
	;
	input	id height
			v1w  v2w  v3w  v4w  v5w 
			v1q1 v1q2 v1q3 v1q4 v1q5 v1q6
			v2q1 v2q2 v2q3 v2q4 v2q5 v2q6
			v3q1 v3q2 v3q3 v3q4 v3q5 v3q6
			v4q1 v4q2 v4q3 v4q4 v4q5 v4q6
			v5q1 v5q2 v5q3 v5q4 v5q5 v5q6
	;
run;

/* Correct data for questions 2, 3 and 5 
Replace values of -99 with missing numeric (.)*/
data weightloss_clean(drop=n);
	set weightloss;
	array qupdate {15}
	v1q2 v2q2 v3q2 v4q2 v5q2 
	v1q3 v2q3 v3q3 v4q3 v5q3
	v1q5 v2q5 v3q5 v4q5 v5q5;
	do n=1 to 15;
		if qupdate{n} = 0 then qupdate{n} = 3;
		else if qupdate{n} = 1 then qupdate{n} = 2;
		else if qupdate{n} = 2 then qupdate{n} = 1;
		else if qupdate{n} = 3 then qupdate{n} = 0;
	end;

	array missupdate {30}	
	v1q1 v1q2 v1q3 v1q4 v1q5 v1q6
	v2q1 v2q2 v2q3 v2q4 v2q5 v2q6
	v3q1 v3q2 v3q3 v3q4 v3q5 v3q6
	v4q1 v4q2 v4q3 v4q4 v4q5 v4q6
	v5q1 v5q2 v5q3 v5q4 v5q5 v5q6;
	do n=1 to 30;
		if missupdate{n} = -99 then missupdate{n} = .;
	end;
run;

/* Calculate BMI at each visit */
data weightloss_bmi;
	set weightloss_clean;
	array weight {5} v1w v2w v3w v4w v5w;
	array bmi {5} v1bmi v2bmi v3bmi v4bmi v5bmi;
	do n=1 to 5;
		bmi{n} = (weight{n} / height**2) * 703;
	end;
run;

/* Subset final data as only obese patients */
data weightloss_obese;
	set weightloss_bmi;
	where v5bmi >= 25.0;
run;