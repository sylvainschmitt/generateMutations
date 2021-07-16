rule simug:
    input:
        "results/trunk/trunk.fa",
        "results/trunk/3P.SNP_model.txt"
    output:
        expand("results/trunk/trunk_snps{ext}", ext=[".fa", ".vcf", ".map"])
    log:
        "results/logs/simug.log"
    benchmark:
        "results/benchmarks/simug.benchmark.txt"
    shell:
        "perl scripts/simuG.pl -refseq {input[0]} -snp_count {config[n_snps]} -snp_model {input[1]} -prefix results/trunk/SNP ; "
        "mv results/trunk/SNP.simseq.genome.fa {output[0]} ; "
        "sed -i 's/>Qrob_Chr01/>Qrob_Chr01_snp/' {output[0]} ; "
        "mv results/trunk/SNP.refseq2simseq.SNP.vcf {output[1]} ; "
        "mv results/trunk/SNP.refseq2simseq.map.txt {output[2]}"
        