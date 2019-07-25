# @Author: nfrazee
# @Date:   2019-04-10T14:45:56-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-04-10T17:17:38-04:00
# @Comment:



#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################
source ../user.inp
###########LODING FILES######################################################
# add in the location and the file for the pdb and psf you want to use
set my_dcd MIN.3.dcd
set my_psf $mol_name.psf
# loads in the files
mol load psf $my_psf dcd $my_dcd
set all [atomselect top all frame last]



#################################only backbone constraint############################################

$all set beta 0
set BB [atomselect top "insert_bb_here" frame last]
$BB set beta 20
$all writepdb BB_fixed.pdb
$BB delete

exit
