/* Chapter 7 */

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
   INFILE '/home/u49596266/little_sas_book/TropicalSales.dat';
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