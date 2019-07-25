# @Author: nfrazee
# @Date:   2019-04-10T16:18:33-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-04-10T17:53:23-04:00
# @Comment:



#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################

source ../user.inp


###########LOADING FILES######################################################

set my_psf ${mol_name}.psf
mol load psf $my_psf
mol addfile HEAT.2.dcd mol 0
#################################only backbone constraint############################################
set all [atomselect top all frame last]
$all set beta 0
set BB [atomselect top "insert_bb_here" frame last]
$BB set beta 20
$all writepdb bb3.pdb
$BB delete

#########################################################################
exit
