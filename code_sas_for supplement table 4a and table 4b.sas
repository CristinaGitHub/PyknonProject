
libname ee "myfolder";
 
****************************;
*for univariate;
proc logistic data=ee.two descending;
class  SEX /PARAM=REF REF=FIRST;
model Stage0=SEX;
run;
****** multivariate;
proc logistic data=ee.two descending;
class AGE_DECO SEX GRADE_DECO TYPE_DECO MSI PYK10_DECO PYK90_DECO /PARAM=REF REF=FIRST;
model Stage0=AGE_DECO SEX GRADE_DECO TYPE_DECO MSI PYK90_DECO;
run;

*******OS;
*for univariate;
proc phreg data=ee.two;
class PYK90_DECO/param=ref ref=first;
model MONTHS*OSid(0) =  PYK90_DECO/ risklimits;

run;
*multivariate;
proc phreg data=ee.two;
class AGE_DECO MSI LN_MET_DECO DIST_MET_DECO GRADE_DECO STAGE_DECO PYK10_DECO
           PYK90_DECO/param=ref ref=first;
model MONTHS*OSid(0) =  AGE_DECO MSI LN_MET_DECO DIST_MET_DECO GRADE_DECO STAGE_DECO  
           PYK90_DECO/ risklimits;
run;

 




