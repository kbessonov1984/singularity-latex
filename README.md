# singularity-latex

## Create image locally
To create the Singularity container, run the command

```
singularity build  --remote singularity-latex_nml.sif  singularity.def
```

To connect to the Singularity image and run LaTeX command to compile pdf from tex file

```
>singularity  run --home $(pwd)   singularity-latex_nml.sif pdflatex -interaction nonstopmode *.tex
```

### version
```
This is pdfTeX, Version 3.14159265-2.6-1.40.20 (TeX Live 2019/Debian) (preloaded format=pdflatex)
```


