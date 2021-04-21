rule reference_convert:
    input:
        "results/data/reference.fa.gz"
    output:
        "results/data/reference.sam.fa.gz"
    log:
        "results/logs/reference_convert.log"
    benchmark:
        "results/benchmarks/reference_convert.benchmark.txt"
    threads: 4
    singularity:
        "oras://registry.forgemia.inra.fr/gafl/singularity/tabix/tabix:latest"
        # "docker://stackleader/bgzip-utility"
    shell:
        "zcat {input} | bgzip -c > {output}"
