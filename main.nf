#!/usr/bin/env nextflow

/*
-------------------------------------------------------------------------------
    BaitCapture
-------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

include {validateParameters; paramsHelp; paramsSummaryLog} from 'plugin/nf-validation'

// Define parameters
params.assemblies = ""
params.outdir = "${launchDir}/results"
params.help = ""
// Print help message, supply typical command line usage for the pipeline
if (params.help) {
   log.info paramsHelp("nextflow run main.nf --assemblies \"assemblies/*.fasta\" --outdir results/")
   exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

// Create channels
assemblies_ch = Channel.fromPath("${params.assemblies}", checkIfExists: true).map {
    [it.baseName, it]
}

/*
-------------------------------------------------------------------------------
    PROCESSES
-------------------------------------------------------------------------------
*/

process PROKKA {

    cpus 8
    tag "PROKKA ${sample_id}"
    publishDir "${params.outdir}/prokka/", mode: 'copy'

    conda "bioconda::prokka=1.14.6"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/prokka%3A1.14.6--pl5321hdfd78af_4' :
        'biocontainers/prokka:1.14.6--pl5321hdfd78af_4' }"

    input:
    tuple val(sample_id), path(assembly)

    output:
    tuple val(sample_id), path("${sample_id}/*.gff"), emit: gff
    tuple val(sample_id), path("${sample_id}/*.gbk"), emit: gbk
    tuple val(sample_id), path("${sample_id}/*.fna"), emit: fna
    tuple val(sample_id), path("${sample_id}/*.faa"), emit: faa
    tuple val(sample_id), path("${sample_id}/*.ffn"), emit: ffn
    tuple val(sample_id), path("${sample_id}/*.sqn"), emit: sqn
    tuple val(sample_id), path("${sample_id}/*.fsa"), emit: fsa
    tuple val(sample_id), path("${sample_id}/*.tbl"), emit: tbl
    tuple val(sample_id), path("${sample_id}/*.err"), emit: err
    tuple val(sample_id), path("${sample_id}/*.log"), emit: log
    tuple val(sample_id), path("${sample_id}/*.txt"), emit: txt
    tuple val(sample_id), path("${sample_id}/*.tsv"), emit: tsv
    path "versions.yml" , emit: versions

    script:
    """
    prokka \
        --cpus ${task.cpus} \
        --prefix ${sample_id} \
        ${assembly}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        prokka: \$(echo \$(prokka --version 2>&1) | sed 's/^.*prokka //')
    END_VERSIONS
    """

}

/*
-------------------------------------------------------------------------------
    WORKFLOW
-------------------------------------------------------------------------------
*/

workflow {

    // assemblies_ch.view()
    PROKKA(assemblies_ch)

}

/*
-------------------------------------------------------------------------------
    EXECUTION SUMMARY
-------------------------------------------------------------------------------
*/

// Print execution summary
workflow.onComplete {
   println ( workflow.success ? """
       Pipeline execution summary
       ---------------------------
       Completed at: ${workflow.complete}
       Duration    : ${workflow.duration}
       Success     : ${workflow.success}
       workDir     : ${workflow.workDir}
       exit status : ${workflow.exitStatus}
       """ : """
       Failed: ${workflow.errorReport}
       exit status : ${workflow.exitStatus}
       """
   )
}