#!/usr/bin/env nextflow
if (params.help){
    helpMessage()
    exit 0
} 

println ("Profile: \'$workflow.profile\'")

tex_files = Channel.fromPath(params.input).view()
OUTDIR = "$PWD/pdfs"
nextflow.enable.dsl=2

println "Project directory: $workflow.projectDir"


def helpMessage() {
    // Add to this help message with new command line parameters
    log.info"""
    Usage:
    The typical command for converting TeX to PDF format:
    nextflow run  --input '*_.tex'
    Mandatory arguments:
      --input [file]                            Path to input data
      -profile [str]                            Configuration profile to use. Can use multiple (comma separated)
                                                Available: conda, singularity. Default profile is standard (assumes installed dependencies)
             """
                                                
}



process tex2pdf {
    log.info("Running process tex2pdf")
 
    publishDir 'pdfs', mode: 'copy'
    
    input:
    path path2tex


    output:
    stdout emit: out
    path '*.pdf', emit: pdf_path

    script:
    pdf = "${path2tex}.pdf"
    """
    BASH_VAR=1
    echo -n "Profile: $workflow.profile Input: ${path2tex} --> workdir: \$PWD \$BASH_VAR"
    echo $task.workdir


    if [ "$workflow.profile" = "standard" ];then
        pdflatex -interaction nonstopmode ${path2tex}               
    elif [ "$workflow.profile" = "singularity" ];then
        pdflatex -interaction nonstopmode ${path2tex}
    elif [ "$workflow.profile" = "singularitymacos" ];then   #MacOS Singularity does not fully support binding directory overlay causing it to fail    
        cd \$PWD && ls -allh && singularity run $baseDir/data/singularity-latex-nml.sif pdflatex -interaction nonstopmode ${path2tex} 
    fi    

    """
}




workflow {
  //tex2pdf(tex_files).out.view()
  print(tex2pdf(tex_files).out.view())
}

workflow.onComplete {
    log.info ( workflow.success ? "\n Workflow completed successfully at $workflow.complete!\n" : "Oops .. something went wrong" )
    log.info ("Output directory $OUTDIR")

}

