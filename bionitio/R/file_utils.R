# Module      : file_utils.R
# Copyright   : (c) BIONITIO_AUTHOR, BIONITIO_DATE
# License     : BIONITIO_LICENSE
# Maintainer  : BIONITIO_EMAIL
# Portability : POSIX

fasta_exists <- function(fasta_files) {
  # Check if all FASTA files exist
  exists <- sapply(fasta_files, file.exists)
  exists[fasta_files == "stdin"] <- TRUE
  if (any(!exists)) {
    stop(
      "Files do not exist:\n\t",
      paste(names(exists)[!exists], collapse = "\n\t")
    )
  }
  return(TRUE)
}

fasta_permission <- function(fasta_files) {
  # Check if all FASTA files have read permission
  can_read <- file.access(fasta_files, mode = 4)
  can_read[fasta_files == "stdin"] <- 0
  if (any(can_read == -1)) {
    stop(
      "Files cannot be read:\n\t",
      paste(names(can_read)[can_read == -1], collapse = "\n\t")
    )
  }
  return(TRUE)
}

invalid_fasta <- function(message = "Invalid FASTA file", quit = FALSE) {
  # Handle invalid files by quitting if not an interactive session
  if (interactive() | (!quit)) {
    stop(message)
  } else {
    message("ERROR: ", message)
    quit(status = 3)
  }
}
