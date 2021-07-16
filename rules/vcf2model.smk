rule vcf2model:
    input:
        expand("data/{vcf}", vcf=[config["hz"]])
    output:
        temp("results/trunk/3P.INDEL_model.txt"),
        temp("results/trunk/3P.SNP_model.txt")
    log:
        "results/logs/vcf2model.log"
    benchmark:
        "results/benchmarks/vcf2model.benchmark.txt"
    shell:
        "perl scripts/vcf2model.pl -vcf {input} -prefix results/trunk/3P"
