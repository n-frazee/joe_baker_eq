# @Author: nfrazee
# @Date:   2019-04-10T14:45:56-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-04-10T17:16:59-04:00
# @Comment:




#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################
source ../user.inp
###########LODING FILES######################################################
# add in the location and the file for the pdb and psf you want to use
set my_dcd MIN.2.dcd
set my_psf $mol_name.psf
# loads in the files
mol load psf $my_psf dcd $my_dcd
set all [atomselect top all frame last]



########################### add in side groups########################################
$all set beta 500

set non_backbone [atomselect top "insert_protein_here" frame last]
$non_backbone set beta 0
$all writepdb  NON_BACKBONE_ONLY.pdb

$non_backbone delete

exit
