# customLiftoverChainFile

Scripts to make custom liftover chain file using two different genome versions.

Older worm datasets are sometimes based on old genome versions that do not have a UCSC liftover file. The aim of these scripts is to take any genome version that is available on the wormbase FTP server and create a liftover file to WS235 (equivalent to ce11).

## Usage

Use the **_prepareForliftover.sh_** script to download genomes, convert them to 2bit format and make a chrom.sizes file.
To use it you must change the genomeVer="WS235" on the 5th line to the version you are interested in.

Use the **_makeLiftoverFile.sh_** script to take in the genome and chrom.sizes files and create a liftover chain file using pyoverchain.
To use it you must change the genomveVer="WS190" on the 11th line to the version you want to convert to WS235 (genomeVerNew). This script can be run as a batch script on the server.

## Output
A directory with name liftover_WSXXX_WS235 and in it two liftover files: 
1) WSXXX.to.WS235.over.chain which has the wormbase style chromosome names. 
2) WSXXXtoWS235_ucscFormat.chain which has the UCSC style chromosome names. This is necessary if you are going to use it with rtracklayer::import.chain and liftover in R.

## Prerequisites
Running these scripts requires installation of linux based ucsc tools (instructions derived from here: http://genomewiki.ucsc.edu/index.php/DoSameSpeciesLiftOver.pl) which provides the tools to convert to 2bit and make a chrom.sizes file. However running the perl script to create the liftover file required some software to run the server and i could not get it to work. So in addition I used pyOverChain python library to create the liftover chain.

### Installing linux ucsc tools
To install the software on the cluster without sudo permitions, I simply did so in the $HOME directory rather than /data in the root directory. Here are the commands modified with the right location:

```
mkdir -p ${HOME}/data/scripts ${HOME}/data/bin
chmod 755 ${HOME}/data/scripts ${HOME}/data/bin

cd ~/data/bin
rsync -a -P rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ ./

git archive --remote=git://genome-source.soe.ucsc.edu/kent.git \
  --prefix=kent/ HEAD src/hg/utils/automation \
     | tar vxf - -C ${HOME}/data/scripts --strip-components=5 \
        --exclude='kent/src/hg/utils/automation/incidentDb' \
      --exclude='kent/src/hg/utils/automation/configFiles' \
      --exclude='kent/src/hg/utils/automation/ensGene' \
      --exclude='kent/src/hg/utils/automation/genbank' \
      --exclude='kent/src/hg/utils/automation/lastz_D' \
      --exclude='kent/src/hg/utils/automation/openStack'


wget -O ${HOME}/data/bin/bedSingleCover.pl 'http://genome-source.soe.ucsc.edu/gitlist/kent.git/raw/master/src/utils/bedSingleCover.pl'

echo 'export PATH=${HOME}/data/bin:${HOME}/data/bin/blat:${HOME}/data/scripts:$PATH' >> $HOME/.bashrc
```

### Installing pyOverChain
Installed pyOverChain in a conda environment called "liftover" with prerequisites for the package (https://github.com/billzt/pyOverChain)
I installed it in the $HOME/data/ directory to keep everything in the same place.

```
conda create -n liftover python=3.7
conda activate liftover
conda install -c bioconda samtools pblat
conda install -c iuc ucsc_tools

git clone https://github.com/billzt/pyOverChain.git
cd pyOverChain
python3 setup.py install
```

