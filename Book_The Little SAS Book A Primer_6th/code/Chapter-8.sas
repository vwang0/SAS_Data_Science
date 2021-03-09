/*
* Chapter 8;
*/

DATA test;
	INPUT Group $ Measurement;
	DATALINES;
Alpha 121
Beta  120
Delta 133
Gamma 130
Alpha 113
Beta  132
Delta 101
Gamma 139
Alpha 129
Beta  127
Delta 139
Gamma 137
Alpha 121
Beta  138
Delta 135
Gamma 122
;
RUN;

PROC SORT data = test out = test_sort;
	BY Group;
RUN;

/* Standard boxplot, four groups on same graph */
PROC SGPLOT data = test;
	VBOX Measurement / CATEGORY = Group;
RUN;

/* Standard boxplot, four groups on same graph but groups are colored by GROUP variable */
PROC SGPLOT data = test;
	VBOX Measurement / GROUP = Group;
RUN;

/* Assuming that data is sorted in ascending order, a BY statement can be added such that a new plot is created for
each group on a separate page */
PROC SGPLOT data = test_sort;
	VBOX Measurement;
	 BY Group;
RUN;


/* Generate some random data */
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 100;
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Basic scatter plot */
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y;
	TITLE "Scatterplot with no options set";
RUN;

/* Puts the numeric value on each ponit */
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y / DATALABEL = y;
	TITLE "Scatterplot with DATALABEL=y";
RUN;

/* Produces an error in SAS Log: ERROR: Variable YAXIS not found */
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y / DATALABEL = YAXIS;
	TITLE "Scatterplot with invalid DATALABEL parameter";
RUN;


/* Generate some random data */
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 100;
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Basic scatter plot showing the use of GRID option
GRID option will create lines at each tick mark on axis*/
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y;
	XAXIS GRID;
	YAXIS GRID;
	TITLE "Scatterplot X-axis and Y-axis Grid";
RUN;


/* Generate some random data */
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 100;
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Random data with label for x */
DATA random_norm_label;
	CALL streaminit(585);
	DO x = 1 to 100;
   		y = rand("Normal");
   		OUTPUT;
	END;

	LABEL x = "Iteration Number";
RUN;

/* Label X-axis by using XAXIS LABEL= option */
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y;
	XAXIS LABEL="Updated X-axis with XAXIS LABEL=";
	TITLE "Random Normal with Unlabeled Variable";
RUN;

/* Label X-axis using label from DATA step */
PROC SGPLOT data = random_norm_label;
	SCATTER X=x Y=y;
	TITLE "Random Normal with Labeled Variable";
RUN;

/* Label X-axis using LABEL statement in PROC SGPLOT */
PROC SGPLOT data = random_norm_label;
	SCATTER X=x Y=y;
	LABEL x = "PROC SGPLOT LABEL= Statement";
	TITLE "Using LABEL statement in PROC SGPLOT";
RUN;


/* Generate some random data with group variable*/
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 100;
		IF x >= 1 and x <= 25 THEN Group = "Alpha";
		ELSE IF x > 25 and x <= 50 THEN Group = "Beta";
		ELSE IF x > 50 and x <= 75 THEN Group = "Delta";
		ELSE Group = "Gamma";
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Default TRANSPARENCY */
PROC SGPLOT data = random_norm;
	VBOX y / CATEGORY = Group;
	TITLE "Default TRANSPARENCY (0)";
RUN;

/* TRANSPARENCY = 0.5 */
PROC SGPLOT data = random_norm;
	VBOX y / CATEGORY = Group TRANSPARENCY = 0.5;
	TITLE "Default TRANSPARENCY = 0.5";
RUN;

/* TRANSPARENCY = 1 */
PROC SGPLOT data = random_norm;
	VBOX y / CATEGORY = Group TRANSPARENCY = 1;
	TITLE "Default TRANSPARENCY = 0";
RUN;


/* Generate some random data with group variable*/
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 100;
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Modify points of scatterplot with MARKERATTRS= */
PROC SGPLOT data = random_norm;
	SCATTER X=x Y=y / MARKERATTRS = (SYMBOL = STAR SIZE = 4MM);
	TITLE "MARKERATTRS options";
RUN;


/* Generate some random data with group variable*/
DATA random_norm;
	CALL streaminit(585);
	DO x = 1 to 10000;
   		y = rand("Normal");
   		OUTPUT;
	END;
RUN;

/* Example with histogram first.  The density plot is overlaid on top
of the histogram, making it easier to see */
PROC SGPLOT data = random_norm;
	HISTOGRAM y;
	DENSITY y;
	TITLE "Histogram and Density of Normal, Histogram First";
RUN;

/* Example with the density plot first.  The density plot will be behind
the histogram, which obscures it */
PROC SGPLOT data = random_norm;
	DENSITY y;
	HISTOGRAM y;
	TITLE "Histogram and Density of Normal, Density First";
RUN;

libname ch8 '/home/u49657251/little_sas_book/data/';

/* Part a, histogram of latest year (2013) */
PROC SGPLOT data = ch8.population;
	HISTOGRAM Y1;
RUN;

/* Part b, histogram of latest year by continent */
PROC SGPANEL data = ch8.population;
	PANELBY Continent / NOVARNAME;
	HISTOGRAM Y1; 
RUN;

/* Part c, boxplot by continent */
PROC SGPLOT data = ch8.population;
	VBOX Y1 / CATEGORY = Continent; 
RUN;

/* Overall, it is easier to see the rough distribution of the population data
using the histograms, but it is easier to visualize the mean/median of each
continent's population in the boxplot */

libname ch8 '/home/u49657251/little_sas_book/data/';

/* Create format for different responses */
PROC FORMAT;
	VALUE Response	0 = "Answer 0"
					1 = "Answer 1"
					2 = "Answer 2"
					3 = "Answer 3"
					. = "Missing Response"
	;
RUN;

/* Create barplot of responses at Visit 1 (Q1) */
PROC SGPLOT data = ch8.wls;
	VBAR Q1 / MISSING;
	FORMAT Q1 Response.;
	XAXIS LABEL="Response";
	TITLE "Frequency of Survey Responses at Visit 1 for Question 1";
RUN;

/* Create barplot of mean BMI per response.  No need for 
PROC MEANS first, SGPLOT can calculate when plotting */
PROC SGPLOT data = ch8.wls;
	VBAR Q1 / MISSING
	STAT = MEAN
	RESPONSE = BMI;
	TITLE "Mean BMI Per Response at Visit 1 for Question 1";
	XAXIS LABEL="Response";	
	FORMAT Q1 Response.;
RUN;

/* Same as above, but include standard error limit lines */
PROC SGPLOT data = ch8.wls;
	VBAR Q1 / MISSING
	STAT = MEAN
	RESPONSE = BMI
	LIMITSTAT = STDERR;
	TITLE "Mean BMI Per Response at Visit 1 for Question 1";
	XAXIS LABEL="Response";	
	FORMAT Q1 Response.;
RUN;

/* Same as above, but change Y-axis limits */
PROC SGPLOT data = ch8.wls;
	VBAR Q1 / MISSING
	STAT = MEAN
	RESPONSE = BMI
	LIMITSTAT = STDERR;
	TITLE "Mean BMI Per Response at Visit 1 for Question 1";
	XAXIS LABEL="Response";	
	YAXIS VALUES = (15 to 30 by 1);
	FORMAT Q1 Response.;
RUN;

/* Kind of tedious, maybe a better way to do this. */
PROC TRANSPOSE  data = ch8.wls out = trans(RENAME=(COL1=Response _NAME_ = Question));
	BY ID BMI;
	VAR Q1-Q30;
RUN;

DATA trans_visits;
	SET trans;
		
	IF Question IN ("Q1", "Q2", "Q3", "Q4", "Q5", "Q6") THEN Visit = 1;
	ELSE IF Question IN ("Q7", "Q8", "Q9", "Q10", "Q11", "Q12") THEN Visit = 2;
	ELSE IF Question IN ("Q13", "Q14", "Q15", "Q16", "Q17", "Q18") THEN Visit = 3;
	ELSE IF Question IN ("Q19", "Q20", "Q21", "Q22", "Q23", "Q24") THEN Visit = 4;
	ELSE IF Question IN ("Q25", "Q26", "Q27", "Q28", "Q29", "Q30") THEN Visit = 5;	
	ELSE Visit = .;
	
	IF Question IN ("Q1", "Q7", "Q13", "Q19", "Q25") THEN QuestionNumber = 1;
	ELSE IF Question IN ("Q2", "Q8", "Q14", "Q20", "Q26") THEN QuestionNumber = 2;
	ELSE IF Question IN ("Q3", "Q9", "Q15", "Q21", "Q27") THEN QuestionNumber = 3;
	ELSE IF Question IN ("Q4", "Q10", "Q16", "Q22", "Q28") THEN QuestionNumber = 4;
	ELSE IF Question IN ("Q5", "Q11", "Q17", "Q23", "Q29") THEN QuestionNumber = 5;	
	ELSE IF Question IN ("Q6", "Q12", "Q18", "Q24", "Q30") THEN QuestionNumber = 6;		
	ELSE QuestionNumber = .;
RUN;
	
/* Panel by visit */
PROC SGPANEL data = work.trans_visits;
	PANELBY Visit / COLUMNS=1;
	VBAR QuestionNumber / MISSING GROUPDISPLAY  = CLUSTER GROUP=Response
	STAT = MEAN
	RESPONSE = BMI
	LIMITSTAT = STDERR;
	ROWAXIS VALUES = (20 to 30 by 1);
	FORMAT Response Response.;
RUN;	
	
	
	

