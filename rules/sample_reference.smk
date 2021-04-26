rule sample_reference:
    input:
        expand("results/source/{file}{ext}", file=config["genome"]["sequence"], ext=["", ".fai"]),
        "results/base_reference/base_reference.bed",
    output:
        "results/base_reference/base_reference.fa"
    log:
        "results/logs/sample_reference.log"
    benchmark:
        "results/benchmarks/sample_reference.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bedtools/bedtools:latest"
    shell:
        "bedtools getfasta -fi {input[0]} -bed {input[2]} > {output}"
