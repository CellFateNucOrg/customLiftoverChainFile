#! /bin/bash

loToolsDIR=${HOME}/data

genomeVer="WS235"
#numVer=$(echo "${genomeVer}" | tr -dc '0-9')
genomeFile=c_elegans.${genomeVer}.genomic.fa
mkdir -p ${loToolsDIR}/genomes/${genomeVer}

# fetch genome
wget ftp://ftp.wormbase.org/pub/wormbase/species/c_elegans/sequence/genomic/${genomeFile}.gz -O ${loToolsDIR}/genomes/${genomeVer}/${genomeFile}.gz

gunzip ${loToolsDIR}/genomes/${genomeVer}/${genomeFile}.gz
# remove empty lines:
awk '!/^$/' ${loToolsDIR}/genomes/${genomeVer}/${genomeFile} > ${loToolsDIR}/genomes/${genomeVer}/${genomeFile}.bk
mv ${loToolsDIR}/genomes/${genomeVer}/${genomeFile}.bk ${loToolsDIR}/genomes/${genomeVer}/${genomeFile}

twobitFile=${genomeFile%fa}2bit
${loToolsDIR}/bin/faToTwoBit ${loToolsDIR}/genomes/${genomeVer}/${genomeFile} ${loToolsDIR}/genomes/${genomeVer}/${twobitFile} 

chromSizesFile=${genomeFile%fa}chrom.sizes
${loToolsDIR}/bin/twoBitInfo ${loToolsDIR}/genomes/${genomeVer}/${twobitFile} ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}

mtDNArow=$( grep -n "MtDNA" ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile} | cut -d":" -f1 )
echo $mtDNArow  "is mtDNA row"
if [ "${mtDNArow}" -lt 7 ]; then

	paste ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile} chrReorder.txt | sort -k3 | cut -f1,2 > ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}.bk

	sed -i '/^[[:space:]]*$/d' ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}.bk

	mv ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}.bk ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}
fi

cat ${loToolsDIR}/genomes/${genomeVer}/${chromSizesFile}

#oocFile=${genomeFile%fa}ooc
#${loToolsDIR}/bin/blat/blat ${loToolsDIR}/genomes/${genomeVer}/${twobitFile} /dev/null /dev/null -tileSize=11 -makeOoc=${loToolsDIR}/genomes/${genomeVer}/${oocFile} -repMatch=50
