#prepare-rpbp-genome prepare_hg38.yaml --num-cpus 16 --mem 40G --overwrite --logging-level INFO
run-all-rpbp-instances config_hg38.yaml --overwrite --num-cpus 16 --logging-level INFO --log-file log.alignments-only_hg38.txt --keep-intermediate-files
