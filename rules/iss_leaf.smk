rule iss_leaf:
    input:
        "results/tips/B{branch}_T{tip}.fa"
    output:
        expand("results/reads/B{branch}_T{tip}_L{leaf}_R{strand}.fq", strand=[1, 2], allow_missing=True)
    log:
        "results/logs/iss_leaf_B{branch}_T{tip}_L{leaf}.log"
    benchmark:
        "results/benchmarks/iss_leaf_B{branch}_T{tip}_L{leaf}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "sh scripts/iss.sh -i {input} -o {output[0]} -m {config[n_reads_leaf_mutated]} -b {config[n_reads_leaf_base]} -t {threads}"
