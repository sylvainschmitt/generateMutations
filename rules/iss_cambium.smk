rule iss_cambium:
    input:
        "results/trunk/trunk.fa"
    output:
        expand("results/reads/trunk_C{cambium}_R{strand}.fq", strand=[1, 2], allow_missing=True)
    log:
        "results/logs/iss_cambium_C{cambium}.log"
    benchmark:
        "results/benchmarks/iss_cambium_C{cambium}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "sh scripts/iss.sh -i {input} -o {output[0]} -m 0 -b {config[n_reads_cambium]} -t {threads}"
