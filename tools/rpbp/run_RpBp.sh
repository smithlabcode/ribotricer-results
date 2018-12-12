prepare-rpbp-genome prepare.yaml --num-cpus 8 --mem 40G --overwrite --logging-level INFO
run-all-rpbp-instances config.yaml --overwrite --num-cpus 8 --logging-level INFO --log-file log.alignments-only.txt --keep-intermediate-files
