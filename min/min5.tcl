# @Author: nfrazee
# @Date:   2019-04-10T14:45:56-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-07-29T14:09:57-04:00
# @Comment:




#Kyle Billings
#1/2/19
#####################joe baker MIN file maker########################################################
source ../user.inp
###########LODING FILES######################################################
# add in the location and the file for the pdb and psf you want to use
set my_dcd MIN.4.dcd
set my_psf $psf_name
# loads in the files
mol load psf $my_psf dcd $my_dcd
set all [atomselect top all frame last]


####################################### only CA has a constraint#####################################
$all set beta 0
set CA [atomselect top "insert_ca_here" frame last]
$CA set beta 20
$all writepdb CA_ONLY.pdb
$CA delete
#######################################################################################################
exit
