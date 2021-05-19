rule simug:
    input:
        expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]]),
        "results/reference/3P.SNP_model.txt"
    output:
        expand("results/reference/{seq}_{chr}_snps{ext}", seq=[config["sequence"]],  chr=[config["chr"]], ext=[".fa", ".vcf", ".map"])
    log:
        "results/logs/simug.log"
    benchmark:
        "results/benchmarks/simug.benchmark.txt"
    shell:
        "perl scripts/simuG.pl -refseq {input[0]} -snp_count {config[n_snps]} -snp_model {input[1]} -prefix results/reference/SNP ; "
        "mv results/reference/SNP.simseq.genome.fa {output[0]} ; "
        "sed -i 's/>{config[chr]}/>{config[chr]}_snp/' {output[0]} ; "
        "mv results/reference/SNP.refseq2simseq.SNP.vcf {output[1]} ; "
        "mv results/reference/SNP.refseq2simseq.map.txt {output[2]}"
        