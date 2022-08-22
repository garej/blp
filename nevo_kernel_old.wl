(* ::Package:: *)

(* ::Input::Initialization:: *)
ns=20;
nmkt=94; 
nbrn=24;
With[{path=FileNameJoin[Most[FileNameSplit[ExpandFileName[First[$ScriptCommandLine]]]]]},
s$jt = Flatten @ Import[FileNameJoin[{path,"BLP_import","Sjt_import.xlsx"}]];
{IV, x2, v, demogr} = (First @ Import[FileNameJoin[{path,"BLP_import",#}]]&)/@{"IV_import.xlsx", "x2_import.xlsx", "v_import.xlsx", "demogr_import.xlsx"};];
p = x2[[All,2]];
x1= MapThread[Prepend, {Flatten[ConstantArray[IdentityMatrix[nbrn],nmkt],{1,2}], p}];
theta2w= {{0.3772,3.0888,0,1.1859,0},{1.8480,16.5980,-0.6590,0,11.6245},{-0.0035,-0.1925,0,0.0296,0},{0.0810,1.4684,0,-1.5143,0}};
invA= Inverse[Transpose[IV].IV];
outshr =1-Flatten[Map[ConstantArray[#,nbrn]&,Map[Total, Partition[s$jt,nbrn]]]]; 
y=Log[s$jt]-Log[outshr];
mid=Transpose[x1].IV.invA.Transpose[IV];
t= Inverse[mid.x1].mid.y;
mvalold= Exp[x1.t];
vfull = Flatten[Map[ConstantArray[#,nbrn]&,v], {1,2}];
dfull = Flatten[Map[ConstantArray[#,nbrn]&,demogr], {1,2}];
With[{k=Dimensions[x2][[2]]},
v$i=Table[vfull[[All, i;;ns * k;;ns]],{i,ns}];
d$i=Table[dfull[[All, i;;ns * k;;ns]],{i,ns}];];
temp= Transpose[x1].IV.invA.Transpose[IV];
mval[mvalold_,mufunc_]:=Module[{eg, chunks,denom,shares, mktsh},eg = Exp[Transpose[mufunc]]*Map[ConstantArray[#,ns]&,mvalold];chunks=Partition[eg, nbrn];denom=1/Flatten[Map[ConstantArray[#,nbrn]&,Table[1+Total @ chunks[[i]], {i,1,nmkt}]], {1,2}];shares=eg * denom; mktsh = 1/ns Map[Total,shares];mvalold *s$jt/mktsh ];
gmmobjg[theta2_?(MatrixQ[#,NumericQ]&)]:=Block[{theta2w=theta2,cfun, mufunc,meanval, delta,theta1, gmmresid},mufunc= Map[Map[Total,(x2 *#.Transpose[theta2w[[;;,2;;]]])]&,d$i]+Map[Map[Total,(x2 *# * ConstantArray[theta2w[[;;,1]],nmkt * nbrn])]&,v$i];meanval=FixedPoint[mval[#, mufunc]&,mvalold,SameTest->(Max @ Abs[#1-#2]<1.*^-6&)];delta = Log[meanval];theta1 = Inverse[temp.x1].temp.delta; gmmresid = delta - x1.theta1;(gmmresid.IV).invA.(Transpose[IV].gmmresid)];
test={{\[Theta]1,\[Theta]5,0,\[Theta]13,0},{\[Theta]2,\[Theta]6,\[Theta]10,0,\[Theta]18},{\[Theta]3,\[Theta]7,0,\[Theta]15,0},{\[Theta]4,\[Theta]8,0,\[Theta]16,0}};
current=theta2w;
list=With[{\[Epsilon] = 0.2},Flatten[MapThread[If[#2==0,Nothing,{#1,#2-Abs[#2]\[Epsilon], #2+Abs[#2]\[Epsilon]}]&,{test,current},2],{2,1}]];
time = TimeUsed[];
{timing,{obj, theta2}}= Catch[NMinimize[gmmobjg[test],list, Method->"NelderMead",AccuracyGoal->6,PrecisionGoal->6,
EvaluationMonitor:>{If[TimeUsed[] - time  > 2, Throw[{gmmobjg[test],test}], time= TimeUsed[]]}]]//AbsoluteTiming
