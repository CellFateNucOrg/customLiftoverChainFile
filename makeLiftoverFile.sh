#! /bin/bash
#SBATCH --mail-user=jennifer.semple@izb.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --job-name="chain file"
#SBATCH --partition=all
#SBATCH --time=0-08:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G

loToolsDIR=${HOME}/data

genomeVer="WS190"
genomeVerNew="WS235"
numVer=$(echo ${genomeVer} | tr -dc '0-9')
genomeFile=c_elegans.${genomeVer}.genomic.fa
genomeFileNew=c_elegans.${genomeVerNew}.genomic.fa

echo $genomeFile

source $CONDA_ACTIVATE liftover

mkdir -p liftover_${genomeVer}_${genomeVerNew}
cp $loToolsDIR/genomes/${genomeVer}/${genomeFile} liftover_${genomeVer}_${genomeVerNew}/${genomeVer}
cp $loToolsDIR/genomes/${genomeVerNew}/${genomeFileNew} liftover_${genomeVer}_${genomeVerNew}/${genomeVerNew}

paste $loToolsDIR/genomes/${genomeVer}/${genomeFile%fa}chrom.sizes ${loToolsDIR}/genomes/${genomeVerNew}/${genomeFileNew%fa}chrom.sizes | cut -f1,3 > liftover_${genomeVer}_${genomeVerNew}/chrMap_${genomeVer}_${genomeVerNew}.tsv

sed -i "1s/^/${genomeVer}       ${genomeVerNew}\n/" liftover_${genomeVer}_${genomeVerNew}/chrMap_${genomeVer}_${genomeVerNew}.tsv

cd liftover_${genomeVer}_${genomeVerNew}
pyoverchain -p 4 -n 4 ${genomeVer} ${genomeVerNew} chrMap_${genomeVer}_${genomeVerNew}.tsv

sed "s/CHROMOSOME_/chr/g"  ${genomeVer}.to.${genomeVerNew}.over.chain | sed "s/chrMtDNA/chrM/g" > ${genomeVer}to${genomeVerNew}_ucscFormat.chain

rm $genomeVer $genomeVerNew
rm chrMap*.tsv

#export target=c_elegans.${genomeVerNew}.genomic
#export query=c_elegans.${genomeVer}.genomic
#cd /data/genomes/${target}
#time (${loToolsDIR}/scripts/doSameSpeciesLiftOver.pl -verbose=2 -buildDir=${loToolsDIR}/genomes/${genomeVerNew} \
#  -ooc=${loToolsDIR}/genomes/${genomeVerNew}/${target}.ooc \
#  -fileServer=localhost -localTmp="/dev/shm" \
#    -bigClusterHub=localhost -dbHost=localhost -workhorse=localhost \
#      -target2Bit=${loToolsDIR}/genomes/${genomeVerNew}/${target}.2bit -targetSizes=${loToolsDIR}/genomes/${genomeVerNew}/${target%genomic}chrom.sizes \
#        -query2Bit=${loToolsDIR}/genomes/${genomeVer}/${query}.2bit \
#          -querySizes=${loToolsDIR}/genomes/${genomeVer}/${query%genomic}chrom.sizes ${target} ${query}) > do.log 2>&1

