# @Author: nfrazee
# @Date:   2019-04-09T16:00:18-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-07-29T14:24:25-04:00
# @Comment:



#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################



source ../user.inp


###########LOADING FILES######################################################

set my_psf $psf_name
mol load psf $my_psf
mol addfile ../heat/HEAT.5.dcd mol 0
#################################only backbone constraint############################################
set all [atomselect top all frame last]
$all set beta 0
set BB [atomselect top "insert_bb_here" frame last]
$BB set beta 20
$all writepdb bb1.pdb
$BB delete

#########################################################################
exit
