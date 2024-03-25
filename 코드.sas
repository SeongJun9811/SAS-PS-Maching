proc import datafile='C:\Users\syj90\OneDrive\���� ȭ��\�м��Ƿ��ڷ�\DB_1985_����.csv' out=DB dbms=csv replace;
getnames=yes;
run;
proc print data=DB (obs=10);
run;
proc univariate data=DB;
var mets;
run;

/* ���̼����� ����� ���������¿� ���� ������ı� ���� �ľ� */
proc LOGISTIC data = DB; 
class rs651821 rs662799 Fiberx;
model metS = Fiberx rs651821 rs662799;
run; 

/* ���̼����� ������ �ִ� ȥ�������� ���� match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU Fiberx;
psmodel Fiberx(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU ;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU ) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out1 lps=_Lps matchid=_MatchID;
run;

/* ���̼����� ������ ������ �ִ� ȥ�������� �ٽ� match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_GLU Fiberx;
psmodel Fiberx(Treated='1') = SEX metS_WC metS_HDL metS_GLU ;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX metS_WC metS_HDL metS_GLU ) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out1 lps=_Lps matchid=_MatchID;
run;

/* match�� ����� �ٽ� logistic ȸ�ͺм� ���� */
proc LOGISTIC data = out1; 
class Fiberx rs651821 rs662799;
model metS= Fiberx rs651821 rs662799;
run;

/* rs651821�� ������ �ִ� ȥ�������� ���� match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU rs651821;
psmodel rs651821(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out2 lps=_Lps matchid=_MatchID;
run;
/* match�� ����� �ٽ� logistic ȸ�ͺм� ���� */
proc LOGISTIC data = out2; 
class Fiberx rs651821 rs662799;
model metS= Fiberx rs651821 rs662799;
run;

/* rs662799 ������ �ִ� ȥ�������� ���� match */
proc psmatch data=DB;
class SEX metS_WC metS_TG metS_HDL metS_BP metS_GLU rs662799;
psmodel rs662799(Treated='1') = SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU;
match method= greedy stat=lps caliper=0.1;
assess lps var=(SEX AGE metS_WC metS_TG metS_HDL metS_BP metS_GLU) /varinfo weight=none plots=(boxplot barchart);
output out(obs=match)=out3 lps=_Lps matchid=_MatchID;
run;
/* match�� ����� �ٽ� logistic ȸ�ͺм� ���� */
proc LOGISTIC data = out3; 
class Fiberx rs651821 rs662799;
model metS = Fiberx rs651821 rs662799;
run;


proc export data=out3 outfile='C:\Users\syj90\OneDrive\���� ȭ��\out3.csv' 
DBMS=CSV; 
run;
