# blp
Random coefficients logit model of demand proposed by Berry, Levinsohn and Pakes (1995) (thus, BLP).

This is Wolfram Mathematica version of famous Nevo's Matlab code with toy BLP example.

Mathematica version has several advantages for educational purposes.
1) code is much shorter, and is kept in one file;
2) code is immutable, so each step of the algorithm is easear to study separately;
3) optimization needs no jacobian (aka gradient).

We keep naming of variables and functions after Nevo's code where appropriate.

BLP_import folder has .xlsx files with input data structured as in Nevo (1998).

# use
unpack BLP_main.zip in the same folder where blp_import is located.

Wolfram Mathematica (v.10+) is required to run blp_main.nb (notebook): https://www.wolfram.com/mathematica/

# references
Berry, Steven, James Levinsohn & Ariel Pakes (1995) “Automobile Prices in Market Equilibrium,” Econometrica, 63(4): 841-890.

Nevo, Aviv (2000) "A Practitioner's Guide to Estimation of Random Coefficients Logit Models of Demand," Journal of Economics & Management Strategy 9(4): 513-548.

Matlab code: https://eml.berkeley.edu/~bhhall/e220c/rc_dc_code.htm
