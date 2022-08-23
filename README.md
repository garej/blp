# blp nevo
Random coefficients logit model of demand proposed by Berry, Levinsohn and Pakes (1995) (thus, BLP) [1].

This is Wolfram Mathematica [5] version of famous Nevo's Matlab code [4] with toy BLP example.

Mathematica version has several advantages for educational purposes.
1) code is shorter and contains in one file;
2) code is immutable, so each step of the algorithm is easear to study separately;
3) optimization needs no jacobian (aka gradient);
4) contraction mapping is a one-liner here (FixedPoint function).

We keep naming of variables and functions after Nevo's code where appropriate.
Detailed explanations of how the BLP model works can be found in [2] and [3].

# use
**1 way**

Unpack `BLP_main.nb` from `BLP_main.zip` in the same folder where `blp_import` resides.
`blp_import` folder has five `.xlsx` files with input data derived from Nevo's code [4].
Select all cells in the notebook and run <kbd>Shift</kbd> + <kbd>Enter</kbd>.

**2  way**

Put `nevo_kernel_script.wl` in the same folder where `nevo_csv` resides.
Run wolframscript from location where it is visible:

`$ wolframscript -file "..your/path/to/nevo_kernel_script.wl" -print`

Usually optimization takes about 90 sec.

# study

`nevo_kernel_script.wl` is a text file with comments. It has 'data', 'model' and 'run' parts that describe the whole logic of model building.
The code can be copied into ordinary notebook to get intermediate results.

This is the *shortest* code with open internal logic of the BLP model we know about. Without auxiliary culculations it can be express in a less than 30 lines.

# references
[1] Berry, Steven, James Levinsohn & Ariel Pakes (1995) “Automobile Prices in Market Equilibrium,” Econometrica, 63(4): 841-890.

[2] Nevo, Aviv (2000) "A Practitioner's Guide to Estimation of Random Coefficients Logit Models of Demand," Journal of Economics & Management Strategy 9(4): 513-548.

[3] Rasmusen, Eric. "The BLP Method of Demand Curve Estimation in Industrial Organization", mimeo (2007, 2011, 2016).

[4] Matlab code: https://eml.berkeley.edu/~bhhall/e220c/rc_dc_code.htm

[5] Wolfram Mathematica (v.10+) is required to run BLP_main.nb (notebook): https://www.wolfram.com/mathematica/
