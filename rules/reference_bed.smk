rule reference_bed:
    output:
        "results/base_reference/base_reference.bed"
    log:
        "results/logs/reference_bed.log"
    benchmark:
        "results/benchmarks/reference_bed.benchmark.txt"
    shell:
        "bed='{config[reference]}' ; bed=${{bed/; /\\\\n}} ; bed=${{bed//:/\\\\t}} ; bed=${{bed//-/\\\\t}} ; echo -e $bed > {output}"
