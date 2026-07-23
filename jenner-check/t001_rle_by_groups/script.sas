/* Run length encoding by groups (SAS solution) */
/* Source: utl-rle-run-length-encoding-by-groups-in-sas-and-r.sas */
/* d:/sd1 libname dropped so the step runs against WORK. */

data have;
 input x $ duration ;
cards4;
w 3
i 4
i 4
w 2
w 1
w 5
i 6
;;;;
run;quit;

/* sum DURATION within each contiguous run of X (run-length encoding by group) */
data want(keep=x tot);
  do until (last.x);
    set have;
    by x notsorted;
    tot + duration;
  end;
  output;
  tot = 0;
run;quit;

proc print data=want;
run;quit;
