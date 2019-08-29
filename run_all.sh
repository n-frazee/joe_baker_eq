#!/bin/bash
# @Author: nfrazee
# @Date:   2019-04-09T16:06:35-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-08-05T11:28:04-04:00
# @Comment: make it easy to reinitialize; check each step has finished before proceeding


if [ $# -ne 7 ]; then echo "
###############################################################################
###+-----------------------------------------------------------------------+###
###| Joe Baker Bilayer Equilibration Procedure                             |###
###+-----------------------------------------------------------------------+###
###############################################################################

Hey there! Enter the proper arguements below to start equilibrating
your bilayer system :D

######### Change user.inp to reflect your system #########

Enter system arguements like so:
	sh run_all.sh [namd2] [vmd] [solvent] [lipid] [protein] [backbone] [CA's]
"
if [ $# -eq 1 ]; then if [ $1 = "-help" ] || [ $1 = "--fullhelp" ] || [ $1 = "-h" ]; then echo "
Details below:
######### This must use NAMD 2.13 for these scripts to work ##########
[namd2]:    This can either be the path of the namd executable or the name of
 	       	the sym link in your bin
[vmd]:	  This can either be the path of the vmd executable or the name of
 	       	the sym link in your bin
[solvent]:  Write a VMD selection for all of your solvent and ions
[lipid]:    Write a VMD selection for all of your lipids
[protein]:  Write a VMD selection for all of your protein except the backbone
[backbone]: Write a VMD selection for the backbone of your proteins
[CA's]:     Write a VMD selection for the CA of your proteins

###+-----------------------------------------------------------------------+###
###| EXAMPLES                                                              |###
###+-----------------------------------------------------------------------+###

	sh run_all.sh \"namd2.13 +p10\" \"vmd\" \"ion or water\" \"lipid\" \\
	 \"protein and not backbone\" \"backbone\" \"protein and name CA\"
Runs the procedure on a workstation with the namd binary sym linked to
\"namd2.13\" and using pretty regular vmd selections

	sh run_all.sh \"charmrun +p32 ++nodelist \$NODES \$NAMD\" \"vmd\" \\
	 \"ion or water\" \"lipid\" \"protein and not backbone\" \"backbone\" \\
	 \"protein and name CA\"
Runs a system similar to the above but on an hpc using charmmrun. This should
be added to an appropriate submission script for the hpc
"
fi; fi
exit
fi
quit=n
if ! [ -d eq ] || ! [ -d heat ] || ! [ -d min ]; then echo "There should be directories here that are not present!"; quit=y; fi

namd_location=$1; vmd_location=$2; solvent=$3; lipid=$4; protein=$5; bb=$6; ca=$7

if ! command -v $namd_location >/dev/null 2>&1; then echo "NAMD argument does not make sense!\nnamd: $namd_location"; quit=y; fi
if ! command -v $vmd_location >/dev/null 2>&1; then echo "VMD argument does not make sense!\nvmd: $vmd_location"; quit=y; fi

psf_location=$(grep psf_name user.inp| awk '{if($1!="#" && $1!="#set") print $3}')
if ! [ -f $psf_location ]; then echo "The psf_name specified in ./user.inp does not make sense!\npsf: $psf_location"; quit=y; fi

pdb_location=$(grep pdb_name user.inp| awk '{if($1!="#" && $1!="#set") print $3}')
if ! [ -f $pdb_location ]; then echo "The pdb_name specified in ./user.inp does not make sense!\npdb: $pdb_location"; quit=y; fi

param_location=$(grep param_path user.inp| awk '{if($1!="#" && $1!="#set") print $3}')
if ! [ -d $param_location ]; then echo "The paramater location in ./user.inp does not make sense!\nparams: $param_location"; quit=y;
else param_list=$(grep par_ user.inp| awk '{if($1!="#") print $1 }')
for i in $param_list; do i="${i%\"}"; i="${i#\"}"; if ! [ -f $param_location/$i ]; then echo "You are missing the parameter file \"$i\"!"; quit=y; fi; done
fi
if [ $quit = "y" ]; then exit; fi


if [ -f .nodelist ]; then cp .nodelist min; cp .nodelist heat; cp .nodelist eq; fi
# Changing the "insert__here" string to the selections for each file
sed -i "s/insert_solvent_here/$solvent/g" min/min1.tcl
sed -i "s/insert_lipid_here/$lipid/g" min/min2.tcl
sed -i "s/insert_protein_here/$protein/g" min/min3.tcl
sed -i "s/insert_bb_here/$bb/g" min/min4.tcl
sed -i "s/insert_ca_here/$ca/g" min/min5.tcl
for i in $(seq 2 5); do sed -i "s/insert_bb_here/$bb/g" heat/bb${i}.tcl; done
for i in $(seq 1 4); do sed -i "s/insert_bb_here/$bb/g" eq/bb${i}.tcl; done

cd min

# This measures the size of your system then modifies the MIN.1.inp file
$vmd_location -dispdev text -e measure.tcl
# Find the sizes of the box from the file
dx=$(awk '{ if($1 == "dx") print $3}' measurements.dat)
dy=$(awk '{ if($1 == "dy") print $3}' measurements.dat)
dz=$(awk '{ if($1 == "dz") print $3}' measurements.dat)
# Modify MIN.1.inp to have the proper sizes
sed -i "s/insert_dx_here/$dx/g" MIN.1.inp
sed -i "s/insert_dy_here/$dy/g" MIN.1.inp
sed -i "s/insert_dz_here/$dz/g" MIN.1.inp
# Find the center of the box from the file
cx=$(awk '{ if($1 == "center") print $2}' measurements.dat)
cy=$(awk '{ if($1 == "center") print $3}' measurements.dat)
cz=$(awk '{ if($1 == "center") print $4}' measurements.dat)
# Modify MIN.1.inp to have the proper center
sed -i "s/insert_cx_here/$cx/g" MIN.1.inp
sed -i "s/insert_cy_here/$cy/g" MIN.1.inp
sed -i "s/insert_cz_here/$cz/g" MIN.1.inp

#restarter () {
#	prefix=$1; next=$2
#	if [ $(grep firsttimestep $next.inp |grep -o '[0-9]\+') -ne $(grep STEP $prefix.log |tail -n 1 |grep -o '[0-9]\+') ]; then
#		temp=$(grep "Rescale" $prefix.log |tail -n 1 |grep -o '[0-9]\+')
#		step=$(grep "STEP" $prefix.log |tail -n 1 |grep -o '[0-9]\+')
#		echo ""
#		echo "###+-----------------------------------------------------------------------+###"
#		echo ""
#		echo "Failed on $prefix.inp. Last step restart was written: $step. Last temperature: $temp.
#		Do you want to restart from here? (y/n)"; read continue
#		if [ $continue = "y" ]; then
#
#		else
#
#		fi
#
#	fi
#}



#sh config.sh output_file_name "inputname" "outputname" "temperture"
#
#cat template.dat > output_file_name
#sed -i

# Iterate through the minimization steps
for i in $(seq 1 5); do
	prefix=MIN.${i}
	next=MIN.$(($i+1))
	# Running VMD to make constraints
	$vmd_location -dispdev text -e min${i}.tcl > min${i}.log
	# Running NAMD to minimize
	$namd_location $prefix.inp > $prefix.log


done

# Last minimization doesn't use constraints
$namd_location MIN.6.inp > MIN.6.log


# Make a file with the energy information
echo "# Step    Step/1000     Energy   Energy/1000" > ../prep_data/min_energy.dat
awk '{if ($1 == "ENERGY:" && $2 > 1000) print $2, $2/1000, $14, $14/1000}' MIN*.log >> ../prep_data/min_energy.dat

cd ../heat

# First step of heating doesn't require constraints
$namd_location HEAT.1.inp > HEAT.1.log

# The rest of the heating steps
for i in $(seq 2 5); do
	# Running VMD to make constraints
	$vmd_location -dispdev text -e bb${i}.tcl
	# Running NAMD to heat
	$namd_location HEAT.${i}.inp > HEAT.${i}.log
done

# Making a file with the system temperature over the heating
echo "# Step    Step/1000     System Temperature"
awk '{if ($1 == "ENERGY:") print $2, $2/1000, $13}' HEAT.*.log >> ../prep_data/heat_temperature.dat

cd ../eq

# Working on all the equilibration steps
for i in $(seq 1 4); do
	# Running VMD to make constraints
	$vmd_location -dispdev text -e bb${i}.tcl
	# Running namd to equilibrate
	$namd_location EQ.${i}.inp > EQ.${i}.log
done
