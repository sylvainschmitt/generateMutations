rule simug:
    input:
        expand("results/reference/{genome}_REP{REP}.fa", genome=config["genome"], allow_missing=True),
        "results/reference/3P.SNP_model.txt"
    output:
        expand("results/reference/{genome}_REP{REP,\d+}_snps{ext}", genome=config["genome"], ext=[".fa", ".vcf", ".map"], allow_missing=True)
    log:
        "results/logs/simug_REP{REP}.log"
    benchmark:
        "results/benchmarks/simug_REP{REP}.benchmark.txt"
    shell:
        "mkdir results/reference/REP{wildcards.REP} ;"
        "perl scripts/simuG.pl -refseq {input[0]} -snp_count {config[n_snps]} -snp_model {input[1]} -prefix results/reference/REP{wildcards.REP}/SNP ; "
        "mv results/reference/REP{wildcards.REP}/SNP.simseq.genome.fa {output[0]} ; "
        "awk '/^>/{{print $1\"_snp\" ; next}}{{print}}' < {output[0]} > {output[0]}.tmp && mv {output[0]}.tmp {output[0]} ;"
        "mv results/reference/REP{wildcards.REP}/SNP.refseq2simseq.SNP.vcf {output[1]} ; "
        "mv results/reference/REP{wildcards.REP}/SNP.refseq2simseq.map.txt {output[2]} ;"
        "rm -r results/reference/REP{wildcards.REP}"
        