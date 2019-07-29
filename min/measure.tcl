# @Author: nfrazee
# @Date:   2019-04-10T17:57:22-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-07-26T10:18:04-04:00
# @Comment:


#Kyle Billings
#1/2/19


#####################joe baker MIN file maker########################################################
source ../user.inp
###########LODING FILES######################################################
# add in the location and the file for the pdb and psf you want to use
set my_pdb $pdb_name
set my_psf $psf_name
# loads in the files
mol load psf $my_psf pdb $my_pdb
set all [atomselect top all]

###################FIND YOUR BOX SIZE###########################################

set outputFile [open measurements.dat w]

set measurement [measure minmax [atomselect top all]]
set min [lindex $measurement 0]
set max [lindex $measurement 1]
foreach {xmin ymin zmin} $min {}
foreach {xmax ymax zmax} $max {}

set dx [expr $xmax - $xmin]
set dy [expr $ymax - $ymin]
set dz [expr $zmax - $zmin]

set center [measure center [atomselect top all]]
set cx [lindex $center 0]
set cy [lindex $center 1]
set cz [lindex $center 2]
puts $outputFile "dx = $dx"
puts $outputFile "dy = $dy"
puts $outputFile "dz = $dz"
puts $outputFile "center $cx $cy $cz"
close $outputFile

exit
