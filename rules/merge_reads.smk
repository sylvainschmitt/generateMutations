rule merge_reads:
    input:
        expand("results/mutated_reads/{type}_reads_R{strand}.fastq", 
                type=["base", "mutated"], strand=["1","2"])
    output:
        "results/mutated_reads/mixed_reads_R1.fastq",
        "results/mutated_reads/mixed_reads_R2.fastq"
    log:
        "results/logs/merge_reads.log"
    benchmark:
        "results/benchmarks/merge_reads.benchmark.txt"
    shell:
        "nm=$(python -c \"print(round(2*{config[sequencing][n_reads]}*{config[mutations][AF]}))\") ; "
        "nb=$(python -c \"print(round(2*{config[sequencing][n_reads]}-$nm))\") ; "
        "nm=${{nm%.*}} ; nb=${{nb%.*}} ; "
        "head {input[0]} -n $nb | awk '{{print (NR%4 == 1) ? $0\"_base\" : $0}}' > {input[0]}.tmp ; "
        "head {input[1]} -n $nb | awk '{{print (NR%4 == 1) ? $0\"_base\" : $0}}' > {input[1]}.tmp ; "
        "head {input[2]} -n $nm | awk '{{print (NR%4 == 1) ? $0\"_mutated\" : $0}}' > {input[2]}.tmp ; "
        "head {input[3]} -n $nm | awk '{{print (NR%4 == 1) ? $0\"_mutated\" : $0}}' > {input[3]}.tmp ; "
        "cat {input[0]}.tmp {input[2]}.tmp > {output[0]} ; "
        "cat {input[1]}.tmp {input[3]}.tmp > {output[1]} ; "
        "rm {input[0]}.tmp {input[2]}.tmp {input[1]}.tmp {input[3]}.tmp {input}"
