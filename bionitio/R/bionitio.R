# Module      : bionitio.R
# Copyright   : (c) BIONITIO_AUTHOR, BIONITIO_DATE
# License     : BIONITIO_LICENSE
# Maintainer  : BIONITIO_EMAIL
# Portability : POSIX

#' Load a FASTA file
#'
#' @description Wrapper for seqinr \code{read.fasta()} to load in a FASTA file
#'     and get the sequences.
#'
#' @param filename The name of the input FASTA file.
#' @param quit_on_error A logical value indicating if an error when reading a
#'     fasta file will invoke the \code{quit} function to terminate R with an
#'     exit status of 3. This will only occur if the R session is
#'     non-interactive.
#'
#' @return A character vector containing sequences as characters. Each
#'     element in the vector is a sequence in the FASTA file.
#' @export
#'
#' @examples
#' my_fasta_file <- system.file("extdata", "two_sequence.fasta", package = "bionitio")
#' load_fasta_file(filename = my_fasta_file)
load_fasta_file <- function(filename, quit_on_error = TRUE) {
  sequences <- tryCatch(
    seqinr::read.fasta(file = filename, seqtype = "AA", seqonly = TRUE),
    error = function(e) {
      # Handle empty files with a message instead of stopping
      if (e$message == "no line starting with a > character found") {
        logging::logwarn(paste(
          filename,
          " has no lines starting with a > character."
        ))
        return(NULL)
      } else {
        logging::logerror(e$message)
        stop(e$message)
      }
    },
    warning = function(w) {
      logging::logerror(w$message)
      invalid_fasta(message = w$message, quit = quit_on_error)
    }
  )
  sequences <- unlist(sequences)
  # Invalid files can have a sequence of 'NA>' in seqinr
  if (length(sequences) > 0 && any(sequences == "NA>")) {
    logging::logerror("Invalid FASTA file")
    invalid_fasta(quit = quit_on_error)
  }
  return(sequences)
}


#' Calculate sequence statistics
#'
#' @description Calculate the number of sequences (num_seq), the length of
#'     the smallest sequence (min_seq), the length of the largest sequence
#'     (max_seq), and the total number of bases (num_bases) in the vector of
#'     given sequences. A minimum length threshold can be set to exclude
#'     sequences less than the specified size.
#'
#' @param sequences A character vector containing sequences
#' @param filename The filename of the FASTA file
#' @param min_len The minimum length of the sequence to include when
#'     calculating statistics
#'
#' @return A list containing FASTA stats.
#' @export
#'
#' @examples
#' my_fasta_file <- system.file("extdata", "two_sequence.fasta", package = "bionitio")
#' sequences <- load_fasta_file(filename = my_fasta_file)
#' get_seq_stats(sequences, filename = my_fasta_file)
get_seq_stats <- function(sequences, filename = NULL, min_len = 0) {
  min_seq <- Inf
  max_seq <- 0
  num_seq <- 0
  num_bases <- 0
  for (seq in sequences) {
    this_len <- nchar(seq)
    if (this_len >= min_len) {
      num_seq <- num_seq + 1
      min_seq <- min(min_seq, this_len)
      max_seq <- max(max_seq, this_len)
      num_bases <- num_bases + this_len
    }
  }
  min_seq <- ifelse(num_seq == 0, 0, min_seq)
  return(list(
    filename = filename, numseq = num_seq, total = num_bases,
    min = min_seq, avg = round(num_bases / num_seq), max = max_seq
  ))
}


#' Prettify output
#'
#' @description Use a dash (-) in place of min, avg, and max if numseq is zero.
#' @param stats The list containing FASTA stats.
#'
#' @return A list containing FASTA stats
#' @export
#'
#' @examples
#' my_fasta_file <- system.file("extdata", "empty_file", package = "bionitio")
#' sequences <- load_fasta_file(filename = my_fasta_file)
#' stats <- get_seq_stats(sequences, filename = my_fasta_file)
#' pretty_output(stats)
pretty_output <- function(stats) {
  if (stats[["numseq"]] == 0) {
    stats[["min"]] <- "-"
    stats[["avg"]] <- "-"
    stats[["max"]] <- "-"
  }
  return(stats)
}


#' Bionitio
#'
#' @description For the given fasta files, calculate statistics and return
#'     results in a data frame.
#'
#' @param fasta_files Vector of filenames
#' @param min_len The minimum length of the sequence to include when
#'     calculating statistics
#' @param pretty A dash (-) is used in place of min, avg, and max if numseq is
#'     zero.
#' @param quit_on_error A logical value indicating if an error when reading a
#'     fasta file will invoke the \code{quit} function to terminate R with an
#'     exit status of 3. This will only occur if the R session is
#'     non-interactive.
#'
#' @return A data frame with FASTA stats. Each row represents a FASTA file.
#' @export
#'
#' @examples
#' my_fasta_files <- c(
#'   system.file("extdata", "one_sequence.fasta", package = "bionitio"),
#'   system.file("extdata", "two_sequence.fasta", package = "bionitio")
#' )
#' run_bionitio(my_fasta_files)
run_bionitio <- function(fasta_files, min_len = 0, pretty = TRUE,
                         quit_on_error = TRUE) {
  # Check existance and read permission
  stopifnot(fasta_exists(fasta_files) & fasta_permission(fasta_files))
  # Process each FASTA file
  results <- lapply(fasta_files, FUN = function(x) {
    logging::loginfo(paste("Processing file:", x))
    get_seq_stats(
      sequences = load_fasta_file(
        filename = x,
        quit_on_error = quit_on_error
      ),
      filename = x,
      min_len = min_len
    )
  })
  # Prettify output
  if (pretty) {
    results <- lapply(results, pretty_output)
  }
  # Convert into data frame
  results <- lapply(results, do.call, what = cbind)
  results <- do.call(rbind, results)
  return(results)
}
