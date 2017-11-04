StackOverflow R: Scraping mutiple web tables and creating seven SAS tables


  INPUT
  =====
     https://www.hockey-reference.com/awards/voting-2017.html

  WORKING CODE
  ============
  WPS/Proc-R or IML/R
     byng<-read_html("https://www.hockey-reference.com/awards/voting-2017.html");
     tables <- html_table(byng);
     len<-length(tables);
     for ( i in 1:7) {;
        assign(paste("want",i,sep="_"),tables[[i]])    *want_&i= tables[[i]];
     };

   OUTPUT
     Seven SAS datasets (here is the third)

     WORK.WANT_3 total obs=6

     PLACE   PLAYER             AGE   TM    POS   VOTES   VOTE_   _1ST   _2ND   ....   W    L   T_O   ...    GPS    PS

       1     Sergei Bobrovsky    28   CBJ    G     138    92.00    25      4     ..   41   17    5    ...   14.9   14.9
       2     Braden Holtby       27   WSH    G      87    58.00     4     21          42   13    6          12.3   12.3
       3     Carey Price         29   MTL    G      19    12.67     0      2          37   20    5          12.6   12.6
       4     Cam Talbot          29   EDM    G      17    11.33     1      2          42   22    8          14.0   14.0
       5     Devan Dubnyk        30   MIN    G       8     5.33     0      1          40   19    5          13.1   13.1
       6     Martin Jones        27   SJS    G       1     0.67     0      0          35   23    6           9.9    9.9


see
https://stackoverflow.com/questions/47065161/how-to-scrape-using-rvest-in-pages-with-multiple-tables

Alexey Knorre profile
https://stackoverflow.com/users/6081879/alexey-knorre

There is an issue with the html, which affects the first of the seven tables.

  </div>   <div class="table_outer_container">

Should be?

  </div>
     <div class="table_outer_container">

Because of this, the first table needs manual changes?


*                _                _       _
 _ __ ___   __ _| | _____      __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \    / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/   | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|    \__,_|\__,_|\__\__,_|

;

    https://www.hockey-reference.com/awards/voting-2017.html

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%macro wants(dummy);
  %do i=1 %to 7;
    import r=want_&i data=wrk.want_&i;
  %end;
%mend wants;

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(rvest);
url="https://www.hockey-reference.com/awards/voting-2017.html";
byng<-read_html(url);
byng <- gsub("<!--", "", byng);
byng <- gsub("-->", "", byng);
byng<-read_html(byng);
tables <- html_table(byng);
len<-length(tables);
for ( i in 1:7) {;
   assign(paste("want",i,sep="_"),tables[[i]])
};
colnames(want_1)<-(tables[[1]])[1,];
want_1;
endsubmit;
%wants;
run;quit;
');

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;

options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "e:\saswork\wrk\_TD1056_BEAST_";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(rvest);
url="https://www.hockey-reference.com/awards/voting-2017.html";
byng<-read_html(url);
byng <- gsub("<!--", "", byng);
byng <- gsub("-->", "", byng);
byng<-read_html(byng);
tables <- html_table(byng);
len<-length(tables);
for ( i in 1:7) {;
assign(paste("want",i,sep="_"),tables[[i]])};
colnames(want_1)<-(tables[[1]])[1,];
want_1;
endsubmit;
import r=want_1 data=wrk.want_1;
import r=want_2 data=wrk.want_2;
import r=want_3 data=wrk.want_3;
import r=want_4 data=wrk.want_4;
import r=want_5 data=wrk.want_5;
import r=want_6 data=wrk.want_6;
import r=want_7 data=wrk.want_7;
run;
quit;


NOTE: Processing of R statements complete

19        import r=want_1 data=wrk.want_1;
NOTE: Creating data set 'WRK.want_1' from R data frame 'want_1'
NOTE: Column names modified during import of 'want_1'
NOTE: Data set "WRK.want_1" has 19 observation(s) and 25 variable(s)

20        import r=want_2 data=wrk.want_2;
NOTE: Creating data set 'WRK.want_2' from R data frame 'want_2'
NOTE: Column names modified during import of 'want_2'
NOTE: Data set "WRK.want_2" has 70 observation(s) and 21 variable(s)

21        import r=want_3 data=wrk.want_3;
NOTE: Creating data set 'WRK.want_3' from R data frame 'want_3'
NOTE: Column names modified during import of 'want_3'
NOTE: Data set "WRK.want_3" has 6 observation(s) and 21 variable(s)

22        import r=want_4 data=wrk.want_4;
NOTE: Creating data set 'WRK.want_4' from R data frame 'want_4'
NOTE: Column names modified during import of 'want_4'
NOTE: Data set "WRK.want_4" has 12 observation(s) and 25 variable(s)

23        import r=want_5 data=wrk.want_5;
NOTE: Creating data set 'WRK.want_5' from R data frame 'want_5'
NOTE: Column names modified during import of 'want_5'
NOTE: Data set "WRK.want_5" has 23 observation(s) and 20 variable(s)

24        import r=want_6 data=wrk.want_6;
NOTE: Creating data set 'WRK.want_6' from R data frame 'want_6'
NOTE: Column names modified during import of 'want_6'
NOTE: Data set "WRK.want_6" has 56 observation(s) and 20 variable(s)

25        import r=want_7 data=wrk.want_7;
NOTE: Creating data set 'WRK.want_7' from R data frame 'want_7'
NOTE: Column names modified during import of 'want_7'
NOTE: Data set "WRK.want_7" has 73 observation(s) and 25 variable(s)

