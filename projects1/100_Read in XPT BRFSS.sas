/*set libname as r*/

Libname r "C:\Users\Monika\Dropbox\R Stats Book\Analytics\Data";
run;

/*set libname of actual XPT file*/

Libname XPTfile xport 'C:\Users\Monika\Dropbox\R Stats Book\Analytics\Data\LLCP2014.XPT';
run;

/*data step reads it in and unpacks it into libname mapped to r*/

data r.BRFSS_a;
    set XPTfile.LLCP2014;
run;

/*verify success*/

proc contents data=r.BRFSS_a;
run;



