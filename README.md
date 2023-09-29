# ProkkaFlow

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

A [Nextflow](https://www.nextflow.io/) workflow wrapper for annotating bacterial genomes with Prokka

## Quick usage

```bash
nextflow run main.nf --assemblies "data/*.fasta" --outdir results/
```

## Installation

1. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation) (22.10.1+).
2. Install any of [Docker](https://docs.docker.com/engine/install/), [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/), or [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html) package manager.


3. Clone the ProkkaFlow GitHub repo:

    ```bash
    git clone https://github.com/pcrxn/ProkkaFlow
    ```

4. Run your analysis with your preferred package manager (`-profile <docker,singularity,conda>`).

### Advanced usage

More usage information can be obtained at any time by running `nextflow run main.nf --help`:

```
$ nextflow run main.nf --help
N E X T F L O W  ~  version 23.04.1
Launching `main.nf` [lonely_leakey] DSL2 - revision: d1b6b4d5ea
Typical pipeline command:

  nextflow run main.nf --assemblies "assemblies/*.fasta" --outdir results/

Input/output options
  --assemblies [string]  The assemblies (FASTA) to annotate as a naming pattern.
  --outdir     [string]  The output directory where the results will be saved.

Generic options
  --help       [boolean] Display help text.
```
