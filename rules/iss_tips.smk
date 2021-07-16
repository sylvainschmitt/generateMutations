rule iss_tips:
    input:
        "results/tips/B{branch}_T{condition}.fa"
    output:
        expand("results/reads/B{branch}_T{condition}_R{strand}.fq", strand=[1, 2], allow_missing=True)
    log:
        "results/logs/iss_tips_B{branch}_T{condition}.log"
    benchmark:
        "results/benchmarks/iss_tips_B{branch}_T{condition}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "sh scripts/iss.sh -i {input} -o {output[0]} -m 40 -b 100 -t {threads}"

# convert to leaf and add cambium