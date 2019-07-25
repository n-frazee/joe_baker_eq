<!--
@Author: nfrazee and kbillings
@Date:   2019-04-11T16:05:31-04:00
@Last modified by:   nfrazee and kbillings
@Last modified time: 2019-04-11T16:05:52-04:00
-->
# joe_baker_eq

## How to use this code

To apply this procedure to your system you will need to modify two files in
this directory:

     run_all.sh (the execution script)
     user.inp (a list of parameters common to all the .tcl scripts)

Once you have modified these files equilibration can be started with:

     sh run_all.sh

executed from the command line in this folder.

## What's going on in the code?

This folder and its contents are a series of scripts designed to implement the
Joe Baker protocol for the equilibration of lipid bilayers. The protocol is as
follows:


### Minimization
1. 20,000 steps with only water and ions free, 500 kcal/mol Å2 constraint on
     everything else
2. 20,000 steps with lipids free, 500 kcal/mol Å2 constraint on everything else
3. 20,000 steps with non-backbone atoms free, 500 kcal/mol Å2 on everything
     else
4. 10,000 steps with backbone constrained using 20 kcal/mol Å2
5. 10,000 steps with alpha carbons constrained using 20 kcal/mol Å2
6. 10,000 steps with everything free

### Heating
1. 50 ps, heating to 50 K, no constraints, 1 fs time step
2. 150 ps, heating to 200 K, backbone constrained with 20 kcal/mol Å2
3. 100 ps, heating to 250 K, backbone constrained with 20 kcal/mol Å2, with
     Langevin Piston period of 400 fs and Langevin Piston decay time of 200 fs
4. 100 ps, heating to 300 K, backbone constrained with 20 kcal/mol Å2,
     switched to Langevin Piston period of 200 fs and Langevin Piston decay
     time of 100 fs
5. Final 50 ps heating step from 300 K to 310 K, backbone constrained

### Equilibration (P = 1 atm,T = 310 K)
1. 1 ns, with 20 kcal/mol Å2 constraint
2. 1 ns, with 10 kcal/mol Å2 constraint (switch to 2 fs time step)
3. 1 ns, with 5 kcal/mol Å2 constraint
4. 1 ns, with 1 kcal/mol Å2 constraint



The system of directories is split up by the three headers above (min, heat,
eq) and each step under the heading corresponds to one of the .inp files and
the output names for the simulation files and .log file for that step.


## Data Gathered during EQ
Some data for the system prep is automatically pulled out from the log files of
the various steps; this is stored the prep_data directory with associated
gnuplot scripts listed here:

     min_energy.gp - plots the full minimization with energy vs timestep
     min_energy_split.gp - same as min_energy.gp but splits into 6 plots: 1 for
          each step
     heat_temperature.gp - plots the temperature
and more to come later...

To load the plots symply execute in gnuplot:

     gnuplot> load "<insert name of script here>"


## Changelog

1.0.0 - og release
1.0.1 - fixed error reading in parameters
