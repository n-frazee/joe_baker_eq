# @Author: nfrazee
# @Date:   2019-04-10T14:45:56-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-07-29T14:10:15-04:00
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



###################IONS FREE################################################
set ION_WATER [atomselect top "insert_solvent_here"]
$all set beta 500
$ION_WATER set beta 0
$all writepdb ION_WATER_ONLY.pdb

$ION_WATER delete
exit
