# @Author: nfrazee
# @Date:   2019-04-10T14:45:56-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-04-10T16:57:45-04:00
# @Comment:




#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################
source ../user.inp
###########LODING FILES######################################################
# add in the location and the file for the pdb and psf you want to use
set my_dcd MIN.1.dcd
set my_psf $mol_name.psf
# loads in the files
mol load psf $my_psf dcd $my_dcd
set all [atomselect top all frame last]


######################## add in the lipid ##########################################
$all set beta 500
set LIPID [atomselect top "insert_lipid_here" frame last]
$LIPID set beta 0

$all writepdb LIPID_ONLY.pdb
$LIPID delete

exit
