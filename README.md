# customLiftoverChainFile

Scripts to make custom liftover chain file using two different genome versions.

Older worm datasets are sometimes based on old genome versions that do not have a UCSC liftover file. The aim of these scripts is to take any genome version that is available on the wormbase FTP server and create a liftover file to WS235 (equivalent to ce11).

## Usage

Use the *_ prepareForliftover.sh_* script to download genomes, convert them to 2bit format and make a chrom.sizes file.
To use it you must change the genomeVer="WS235" on the 5th line to the version you are interested in.

Use the *_makeLiftoverFile.sh_* script to take in the genome and chrom.sizes files and create a liftover chain file using pyoverchain.
To use it you must change the genomveVer="WS190" on the 11th line to the version you want to convert to WS235 (genomeVerNew). This script can be run as a batch script on the server.

## Output
a directory with name liftover_WSXXX_WS235 and in it two liftover files: 
1) WSXXX.to.WS235.over.chain which has the wormbase style chromosome names. 
2) WSXXXtoWS235_ucscFormat.chain which has the UCSC style chromosome names. This is necessary if you are going to use it with rtracklayer::import.chain and liftover in R.

## Prerequisites
