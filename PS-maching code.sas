proc import datafile='C:\Users\syj90\OneDrive\바탕 화면\분석의뢰자료\DB_1985_수정.csv' out=DB dbms=csv replace;
getnames=yes;
run;
proc print data=DB (obs=10);
run;
proc univariate data=DB;
var mets;
run;

/* 식이섬유소 섭취와 유전자형태에 따른 대사증후군 연관 파악 */
proc LOGISTIC data = DB; 
class rs651821 rs662799 Fiberx;
model metS = Fiberx rs651821 rs662799;
run; 

/* 식이섬유에 영향을 주는 혼란변수에 대한 match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU Fiberx;
psmodel Fiberx(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU ;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU ) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out1 lps=_Lps matchid=_MatchID;
run;

/* 식이섬유에 유의한 영향을 주는 혼란변수로 다시 match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_GLU Fiberx;
psmodel Fiberx(Treated='1') = SEX metS_WC metS_HDL metS_GLU ;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX metS_WC metS_HDL metS_GLU ) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out1 lps=_Lps matchid=_MatchID;
run;

/* match된 결과로 다시 logistic 회귀분석 시행 */
proc LOGISTIC data = out1; 
class Fiberx rs651821 rs662799;
model metS= Fiberx rs651821 rs662799;
run;

/* rs651821에 영향을 주는 혼란변수에 대한 match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU rs651821;
psmodel rs651821(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out2 lps=_Lps matchid=_MatchID;
run;
/* match된 결과로 다시 logistic 회귀분석 시행 */
proc LOGISTIC data = out2; 
class Fiberx rs651821 rs662799;
model metS= Fiberx rs651821 rs662799;
run;

/* rs662799 영향을 주는 혼란변수에 대한 match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU rs662799;
psmodel rs662799(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out3 lps=_Lps matchid=_MatchID;
run;
/* match된 결과로 다시 logistic 회귀분석 시행 */
proc LOGISTIC data = out3; 
class Fiberx rs651821 rs662799;
model metS = Fiberx rs651821 rs662799;
run;


proc export data=out3 outfile='C:\Users\syj90\OneDrive\바탕 화면\out3.csv' 
DBMS=CSV; 
run;
