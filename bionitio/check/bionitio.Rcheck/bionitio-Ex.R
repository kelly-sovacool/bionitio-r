pkgname <- "bionitio"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "bionitio-Ex.timings", pos = "CheckExEnv")
base::cat("name\tuser\tsystem\telapsed\n", file = base::get(".ExTimings", pos = "CheckExEnv"))
base::assign(".format_ptime",
  function(x) {
    if (!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
    if (!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
    options(OutDec = ".")
    format(x[1L:3L], digits = 7L)
  },
  pos = "CheckExEnv"
)

### * </HEADER>
library("bionitio")

base::assign(".oldSearch", base::search(), pos = "CheckExEnv")
base::assign(".old_wd", base::getwd(), pos = "CheckExEnv")
cleanEx()
nameEx("get_seq_stats")
### * get_seq_stats

flush(stderr())
flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get_seq_stats
### Title: Calculate sequence statistics
### Aliases: get_seq_stats

### ** Examples

my_fasta_file <- system.file("extdata", "two_sequence.fasta", package = "bionitio")
sequences <- load_fasta_file(filename = my_fasta_file)
get_seq_stats(sequences, filename = my_fasta_file)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get_seq_stats", base::get(".format_ptime", pos = "CheckExEnv")(get(".dptime", pos = "CheckExEnv")), "\n", file = base::get(".ExTimings", pos = "CheckExEnv"), append = TRUE, sep = "\t")
cleanEx()
nameEx("load_fasta_file")
### * load_fasta_file

flush(stderr())
flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: load_fasta_file
### Title: Load a FASTA file
### Aliases: load_fasta_file

### ** Examples

my_fasta_file <- system.file("extdata", "two_sequence.fasta", package = "bionitio")
load_fasta_file(filename = my_fasta_file)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("load_fasta_file", base::get(".format_ptime", pos = "CheckExEnv")(get(".dptime", pos = "CheckExEnv")), "\n", file = base::get(".ExTimings", pos = "CheckExEnv"), append = TRUE, sep = "\t")
cleanEx()
nameEx("pretty_output")
### * pretty_output

flush(stderr())
flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: pretty_output
### Title: Prettify output
### Aliases: pretty_output

### ** Examples

my_fasta_file <- system.file("extdata", "empty_file", package = "bionitio")
sequences <- load_fasta_file(filename = my_fasta_file)
stats <- get_seq_stats(sequences, filename = my_fasta_file)
pretty_output(stats)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("pretty_output", base::get(".format_ptime", pos = "CheckExEnv")(get(".dptime", pos = "CheckExEnv")), "\n", file = base::get(".ExTimings", pos = "CheckExEnv"), append = TRUE, sep = "\t")
cleanEx()
nameEx("run_bionitio")
### * run_bionitio

flush(stderr())
flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: run_bionitio
### Title: Bionitio
### Aliases: run_bionitio

### ** Examples

my_fasta_files <- c(
  system.file("extdata", "one_sequence.fasta", package = "bionitio"),
  system.file("extdata", "two_sequence.fasta", package = "bionitio")
)
run_bionitio(my_fasta_files)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("run_bionitio", base::get(".format_ptime", pos = "CheckExEnv")(get(".dptime", pos = "CheckExEnv")), "\n", file = base::get(".ExTimings", pos = "CheckExEnv"), append = TRUE, sep = "\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = "CheckExEnv"), "\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit("no")
