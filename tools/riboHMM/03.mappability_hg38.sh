#!/bin/bash
set -eox pipefail
export riboHMM_SRC="/home/cmb-panasas2/skchoudh/github_projects/riboHMM/"
export OUT_PREFIX="/staging/as/skchoudh/riboHMM_out/hg38_synfootprints_29_star"
export OUT_BAM="/staging/as/skchoudh/riboHMM_out/hg38_synfootprints_29_star.bam"
export IN_FQ="/staging/as/skchoudh/riboHMM_out/hg38_synfootprints_29.fq.gz"
export STAR_INDEX="/home/cmb-panasas2/skchoudh/genomes/hg38/star_annotated"
export OUT_MAPPABILITY="/staging/as/skchoudh/riboHMM_out/hg38_synfootprints_mappability_29"

STAR --runThreadN 16\
  --genomeDir ${STAR_INDEX}\
  --outFilterMismatchNmax 2\
  --outFileNamePrefix ${OUT_PREFIX}\
  --readFilesIn ${IN_FQ}\
  --readFilesCommand zcat\
  --quantMode TranscriptomeSAM\
  --outSAMtype BAM Unsorted\
  --outFilterType BySJout\
  --outFilterMatchNmin 16\
  --seedSearchStartLmax 15\
  --winAnchorMultimapNmax 200\
  && samtools sort -@ 16 ${OUT_PREFIX}Aligned.out.bam -o ${OUT_BAM} \ 
  && samtools index ${OUT_BAM} \
  && mv ${OUT_PREFIX}Log.final.out ${OUT_PREFIX}Log.out ${OUT_PREFIX}SJ.out.tab

#samtools sort -@ 16 ${OUT_PREFIX}Aligned.out.bam -o ${OUT_BAM}
#samtools index ${OUT_BAM}
#mv ${OUT_PREFIX}Log.final.out ${OUT_PREFIX}Log.out ${OUT_PREFIX}SJ.out.tab
python "$riboHMM_SRC/compute_mappability.py" ${OUT_BAM} ${OUT_MAPPABILITY}
