# @Author: nfrazee
# @Date:   2019-05-30T14:42:55-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-05-30T16:40:03-04:00
# @Comment:


#!/bin/bash

#PBS -q comm_mmem_week
#PBS -m ae
#PBS -M ncf0003@mix.wvu.edu
#PBS -N joe_baker_eq
#PBS -l nodes=1:ppn=16
#PBS -l walltime=168:00:00

module load namd/2.13 vmd/1.9.3

cd $PBS_O_WORKDIR

NODES=`pwd`/.nodelist
cat $PBS_NODEFILE | perl -e 'while(<>) { chomp; $node{$_}++; } $num = keys %node; print "group main\n"; for (keys %node) { print "host $_ ++cpus $node{$_}\n"; }' > $NODES

#sh run_all.sh [namd2] [solvent] [lipid] [protein] [backbone] [CA's]
#
#Details below:
########## This must use NAMD 2.13 for these scripts to work ##########
#[namd2]:    This can either be the path of the namd executable or the name of
#          the sym link in your bin
#[solvent]:  Write a VMD selection for all of your solvent and ions
#[lipid]:    Write a VMD selection for all of your lipids
#[protein]:  Write a VMD selection for all of your protein except the backbone
#[backbone]: Write a VMD selection for the backbone of your proteins
#[CA's]:     Write a VMD selection for the CA of your proteins

     sh run_all.sh "charmrun +p32 ++nodelist $NODES $NAMD" "ion or water" "lipid" "protein and not backbone" "backbone" "protein and name CA"
