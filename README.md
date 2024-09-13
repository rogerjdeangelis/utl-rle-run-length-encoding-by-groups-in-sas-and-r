# utl-rle-run-length-encoding-by-groups-in-sas-and-r
Run length encoding by groups in sas and r 
    %let pgm=utl-rle-run-length-encoding-by-groups-in-sas-and-r;

    Run length encoding by groups in sas and r

            SOLUTIONS

                1 sas
                2 r rle function
                  https://stackoverflow.com/users/9463489/jblood94
                3 r mutate consecutive summarize
                  https://stackoverflow.com/users/6851825/jon-spring
                4 pyhton does not have a base rle function?

    github
    https://tinyurl.com/2aavktv3
    https://github.com/rogerjdeangelis/utl-rle-run-length-encoding-by-groups-in-sas-and-r

    This type of problem does not lend itself to sql, however
    if can be solved with sql monotonic and/or partitions.

    This problem is related to time series, best solved with time series packages and not sql?

    RELATED RLE REPOS

    https://github.com/rogerjdeangelis/utl_max_run_length_of_ones_wps_proc_r_rle_function
    https://github.com/rogerjdeangelis/utl-counts-of-strings-of-contiguous-numbers-that-are-the-same-rle-runs
    https://github.com/rogerjdeangelis/utl-longest-sequence-of-ones-in-each-row-r-rle-run-lengtn-encoding
    https://github.com/rogerjdeangelis/utl-r-run-length-encoding-RLE-function-find-Longest-run-of-zeros-and-ones
    https://github.com/rogerjdeangelis/utl_find_all_number_that_appear_multiple_times_consecutively_run_lengths_rle

    Stackoverflow r
    https://stackoverflow.com/questions/78983020/r-calculate-value-by-each-seperate-instance-of-a-variable-in-a-data-frame

    /*               _     _
     _ __  _ __ ___ | |__ | | ___ _ __ ___
    | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
    | |_) | | | (_) | |_) | |  __/ | | | | |
    | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
    |_|
    */

    /**************************************************************************************************************************/
    /*                          |                                      |                                                      */
    /*         INPUT            |                 PROCESS              |       OUTPUT                                         */
    /*         =====            |                 =======              |       ======                                         */
    /*                          |                                      |                                                      */
    /*                          |                                      |                                                      */
    /*                          |                            RUN       |   WORK.WANT total obs=4                              */
    /*                          |                            LENGTH    |                                                      */
    /*  SD1.HAVE total obs=7    |      Obs    X    DURATION  SUMS      |   Obs    X    TOT                                    */
    /*                          |                                      |                                                      */
    /*  Obs    X    DURATION    |       1     w        3      3        |    1     w     3                                     */
    /*                          |                                      |    2     i     8                                     */
    /*   1     w        3       |       2     i        4               |    3     w     8                                     */
    /*                          |       3     i        4      8        |    4     i     6                                     */
    /*   2     i        4       |                                      |                                                      */
    /*   3     i        4       |       4     w        2               |                                                      */
    /*                          |       5     w        1               |                                                      */
    /*   4     w        2       |       6     w        5      8        |                                                      */
    /*   5     w        1       |                                      |                                                      */
    /*   6     w        5       |       7     i        6      6        |                                                      */
    /*                          |                                      |                                                      */
    /*   7     i        6       |                                      |                                                      */
    /*                          |                                      |                                                      */
    /**************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

    options validvarname=upcase;
    libname sd1 "d:/sd1";
    data sd1.have;
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

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*    X    DURATION                                                                                                       */
    /*                                                                                                                        */
    /*    w        3                                                                                                          */
    /*    i        4                                                                                                          */
    /*    i        4                                                                                                          */
    /*    w        2                                                                                                          */
    /*    w        1                                                                                                          */
    /*    w        5                                                                                                          */
    /*    i        6                                                                                                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/


    /*                       _                 _
    / |  ___  __ _ ___    __| | _____      __ | | ___   ___  _ __
    | | / __|/ _` / __|  / _` |/ _ \ \ /\ / / | |/ _ \ / _ \| `_ \
    | | \__ \ (_| \__ \ | (_| | (_) \ V  V /  | | (_) | (_) | |_) |
    |_| |___/\__,_|___/  \__,_|\___/ \_/\_/   |_|\___/ \___/| .__/
                                                            |_|
    */

    data want(drop=duration);
      retain x ' ' tot 0;
      do until (last.x);
        set sd1.have;
        by x notsorted;
        tot = tot + duration;
        if last.x;
      end;
      do until (last.x);
        set sd1.have;
        by x notsorted;
        if last.x then output;
      end;
      tot=0;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*  WANT total obs=4                                                                                                      */
    /*                                                                                                                        */
    /*   X    TOT                                                                                                             */
    /*                                                                                                                        */
    /*   w     3                                                                                                              */
    /*   i     8                                                                                                              */
    /*   w     8                                                                                                              */
    /*   i     6                                                                                                              */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*                       _                 _
    / |  ___  __ _ ___    __| | _____      __ | | ___   ___  _ __
    | | / __|/ _` / __|  / _` |/ _ \ \ /\ / / | |/ _ \ / _ \| `_ \
    | | \__ \ (_| \__ \ | (_| | (_) \ V  V /  | | (_) | (_) | |_) |
    |_| |___/\__,_|___/  \__,_|\___/ \_/\_/   |_|\___/ \___/| .__/
                                                            |_|
    */

    data want(drop=duration);
      retain x ' ' tot 0;
      do until (last.x);
        set sd1.have;
        by x notsorted;
        tot = tot + duration;
        if last.x;
      end;
      do until (last.x);
        set sd1.have;
        by x notsorted;
        if last.x then output;
      end;
      tot=0;
    run;quit;


    /*___                _         __                  _   _
    |___ \   _ __   _ __| | ___   / _|_   _ _ __   ___| |_(_) ___  _ __
      __) | | `__| | `__| |/ _ \ | |_| | | | `_ \ / __| __| |/ _ \| `_ \
     / __/  | |    | |  | |  __/ |  _| |_| | | | | (__| |_| | (_) | | | |
    |_____| |_|    |_|  |_|\___| |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|

    */

    %utl_rbeginx;
    parmcards4;
    library(haven)
    library(tidyverse)
    have<-read_sas("d:/sd1/have.sas7bdat")
    source("c:/oto/fn_tosas9x.R")
    want<-with(
         rle(have$X)
        ,data.frame(x_group = values
        ,duration_group = diff(c(0, cumsum(have$DURATION)[cumsum(lengths)])))
        )
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rlewant"
         )
    ;;;;
    %utl_rendx;

    libname sd1 "d:/sd1";
    proc print data=sd1.rlewant;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* R                                                                                                                      */
    /*                                                                                                                        */
    /*  > want                                                                                                                */
    /*    x_group duration_group                                                                                              */
    /*  1       w              3                                                                                              */
    /*  2       i              8                                                                                              */
    /*  3       w              8                                                                                              */
    /*  4       i              6                                                                                              */
    /*                                                                                                                        */
    /* SAS                                                                                                                    */
    /*                         DURATION_                                                                                      */
    /*  ROWNAMES    X_GROUP      GROUP                                                                                        */
    /*                                                                                                                        */
    /*      1          w           3                                                                                          */
    /*      2          i           8                                                                                          */
    /*      3          w           8                                                                                          */
    /*      4          i           6                                                                                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*____                          _        _
    |___ /   _ __   _ __ ___  _   _| |_ __ _| |_ ___    ___ ___  _ __  ___  ___  ___
      |_ \  | `__| | `_ ` _ \| | | | __/ _` | __/ _ \  / __/ _ \| `_ \/ __|/ _ \/ __|
     ___) | | |    | | | | | | |_| | || (_| | ||  __/ | (_| (_) | | | \__ \  __/ (__
    |____/  |_|    |_| |_| |_|\__,_|\__\__,_|\__\___|  \___\___/|_| |_|___/\___|\___|

    */

    %utl_rbeginx;
    parmcards4;
    library(haven)
    library(tidyverse)
    have<-read_sas("d:/sd1/have.sas7bdat")
    print(have)
    source("c:/oto/fn_tosas9x.R")
    want<-have |>
      mutate(grp = consecutive_id(X)) |>
      summarize(DURATION = sum(DURATION), .by = c(X, grp)) |>
      select(-grp)
      fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rwant"
         )
    want
    ;;;;
    %utl_rendx;

    libname sd1 "d:/sd1";
    proc print data=sd1.rwant;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* Obs    ROWNAMES    X    DURATION                                                                                       */
    /*                                                                                                                        */
    /*  1         1       w        3                                                                                          */
    /*  2         2       i        8                                                                                          */
    /*  3         3       w        8                                                                                          */
    /*  4         4       i        6                                                                                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
