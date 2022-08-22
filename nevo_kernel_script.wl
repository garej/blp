(* ::Package:: *)

(* ::Input:: *)
(* DATA *)
ns = 20;
nmkt = 94;
nbrn = 24;

With[{path=FileNameJoin[Most[FileNameSplit[ExpandFileName[First[$ScriptCommandLine]]]]]},
s$jt = Flatten @ Import[FileNameJoin[{path,"nevo_csv","Sjt_import.csv"}]];
{IV, x2, v, demogr} = (Import[FileNameJoin[{path,"nevo_csv",#}]]&)/@{"IV_import.csv", "x2_import.csv", "v_import.csv", "demogr_import.csv"};];

p = x2[[All,2]];
x1 = MapThread[Prepend, {Flatten[ConstantArray[IdentityMatrix[nbrn],nmkt],{1,2}], p}];

(* MODEL *)
(* initial cycle without theta2 *)
invA = Inverse[Transpose[IV].IV];
outshr = 1-Flatten[Map[ConstantArray[#,nbrn]&,Map[Total, Partition[s$jt,nbrn]]]];
y = Log[s$jt]-Log[outshr];
mid = Transpose[x1].IV.invA.Transpose[IV];
t = Inverse[mid.x1].mid.y;
mvalold = Exp[x1.t];

(* function for contraction mapping *)
mval[mvalold_,mufunc_]:= Module[{eg, chunks,denom,shares, mktsh},
eg = Exp[mufunc]*Transpose[ConstantArray[mvalold,ns]]; (* mvalold as given *)

chunks = Partition[eg, nbrn]; (* auxiliary chunks of data by markets *)
denom = 1/Flatten[ConstantArray[Table[1+Total @ chunks[[i]], {i,1,nmkt}], nbrn],{2,1}];
shares = eg * denom;
mktsh = (1/ns)Total[shares, {2}];  (* {2} in Total applies to the second level *)
mvalold*s$jt/mktsh
];

(* objective funciton *)
gmmobjg[theta2_?(MatrixQ[#,NumericQ]&)]:= Block[{theta2w=theta2,Sigma, Demo, mufunc,meanval, delta, gmmresid},

Sigma = DiagonalMatrix @ theta2w[[;;,1]];
Demo = theta2w[[;;,2;;]];
mufunc = Flatten[Table[ Partition[x2,nbrn][[t]].(Sigma.Partition[v[[t]],ns] + Demo.Partition[demogr[[t]],ns]), {t, 1, nmkt}], {1,2}];

meanval = FixedPoint[mval[#, mufunc]&,mvalold,SameTest->(Max @ Abs[#1-#2]<1.*^-10&)];

delta = Log[meanval];
theta1 = Inverse[mid.x1].mid.delta;
gmmresid = delta - x1.theta1;

(gmmresid.IV).invA.(Transpose[IV].gmmresid)
];

(* RUN *)
(* arbitrary initial value of theta2 --> from Nevo with some parameters set to 0 *)

theta2w = {{0.3772,3.0888,0,1.1859,0},{1.8480,16.5980,-0.6590,0,11.6245},{-0.0035,-0.1925,0,0.0296,0},{0.0810,1.4684,0,-1.5143,0}};

pattern = Table[s[i,j], {i,1,4},{j,1,5}];
current = theta2w;

theta2 = MapThread[If[#2==0,0,#1]&,{pattern,current},2];
list = With[{shift = 0.1},Flatten[MapThread[If[#2==0,Nothing,{#1,#2-Abs[#2]shift, #2+Abs[#2]shift}]&,{pattern,current},2],{2,1}]];

(* optimization cycle *)
NMinimize[target = gmmobjg[theta2],list, Method->"NelderMead",AccuracyGoal->6,PrecisionGoal->6,
EvaluationMonitor:>{
Print @ {target, First @ theta1, First @ theta2}; Print[];
}]
