calc_topic_counts <- function(Z, K)
{
  Nt <- array(0, c(1, K)); 
  for (k in 1:K) Nt[k] <- sum(Z == k);
  
  return(Nt); 	
}

#' Generates a Corpus with a given \eqn{(\alpha, \eta)}
#'
#' Generates documents using the LDA generative process based on a set of
#' \eqn{(\alpha, \eta)} Configurations
#'
#' @param K number of topics
#' @param V vocabulary size
#' @param J number of collections
#' @param collection.size number of documents in each collection (a list of J
#' elements)
#' @param doc.size number of words in each document
#' @param alpha.vec a set of values for document-level Dirichlet sampling
#' @param eta.vec a set of values for topic Diriclet sampling
#'
#' @return a list of generated corpus and their statistics
#'
#' @export
#'
#' @family corpus
#'
#' @details Last modified on: April 15, 2016
#'
#' @examples
#
#' ## Generates documents with given parameters
#'
#' K                  <- 4
#' V                  <- 20
#' alpha.h            <- .2
#' eta.h              <- .5
#' doc.size           <- 80
#' num.docs           <- 40 # number of documents in each collection
#' ds.name            <- paste("synth-K", K, "-V", V, sep = "")
#'
#' ds                 <- gen_synth_corpus(K, V, num.docs, doc.size, alpha.h, eta.h)
#'
gen_synth_corpus <- function(K, V, num.docs, doc.size, alpha.h, eta.h)
{
  
  calc_topic_counts <- function(Z, K)
  {
    Nt <- array(0, c(1, K));
    for (k in 1:K) Nt[k] <- sum(Z == k);
    
    return(Nt);
  }
  
  theta.counts <- matrix(0, nrow = K, ncol = num.docs) # document topic word counts
  beta.counts <- matrix(0, nrow = K, ncol = V) # topic word counts
  
  theta.samples <- matrix(0, nrow = K, ncol = num.docs)
  beta.samples <- matrix(1e-2, nrow = K, ncol = V)
  
  
  did <- c()
  wid <- c()
  zid <- c()
  doc.N <- array(doc.size, dim = c(num.docs, 1))
  doc.idx <- vector("list", num.docs)
  docs <- vector("list", num.docs)
  word.idx <- 1; # initialize the corpus word index
  
  ptm <- proc.time()
  
  
  
  # Topic Dirichlet sampling
  eta.v <- array(eta.h, c(1, V))
  for (k in 1:K) {
    beta.samples[k,]  <- sample_dirichlet(V, eta.v)
  }
  
  
  alpha.v <- array(alpha.h, c(K, 1))
  
  # Document sampling
  d.index <- 1
  
  for (d in 1:num.docs) {
    
    theta.samples[, d.index] <- sample_dirichlet(K, alpha.v);
    
    did <- cbind(did, array(1, c(1, doc.N[d.index])) * d.index); # document instances
    z_d <- c();
    indices <- c();
    
    # Word sampling
    word_ids <- rep(0, doc.N[d.index])
    for (i in 1:doc.N[d.index]) {
      
      # samples topic
      z_dn <- which(rmultinom(1, size = 1, prob = theta.samples[, d.index]) == 1)
      z_d <- cbind(z_d, z_dn)
      
      # samples word
      w_dn <- which(rmultinom(1, size = 1, beta.samples[z_dn,]) == 1)
      word_ids[i] <- w_dn - 1
      wid <- cbind(wid, w_dn)
      
      indices <- cbind(indices, word.idx)
      word.idx <- word.idx + 1
      
      
    }
    
    doc <- as.data.frame(table(word_ids))
    doc <- rbind(as.integer(levels(doc$word_ids)), doc$Freq)
    docs[[d.index]] <- doc
    doc.idx[[d.index]] <- as.integer(indices) # document word indices
    
    theta.counts[, d.index] <- calc_topic_counts(z_d, K) # document topic counts
    zid <- cbind(zid, z_d)
    
    d.index <- d.index + 1
  }
  
  
  total.N <- sum(doc.N);
  for (i in 1:total.N) {
    beta.counts[zid[i], wid[i]] <- beta.counts[zid[i], wid[i]] + 1;
  }
  
  ptm <- proc.time() - ptm
  cat("Corpus generation time: ", ptm[3], ", number of total words: ", total.N,
      "\n", sep = "")
  
  # returns a list
  list(
    docs = docs,
    did = as.vector(did),
    wid = as.vector(wid),
    zid = as.vector(zid),
    theta.counts = theta.counts,
    beta.counts = beta.counts,
    theta.samples = theta.samples,
    beta.samples = beta.samples,
    total.N = total.N,
    doc.N = doc.N,
    doc.idx = doc.idx
  )
  
}


#' Generates a Corpus with a given \eqn{(\alpha, \beta)}
#'
#' Generates documents using the LDA generative process based on a set of
#' \eqn{(\alpha, \beta)} Configurations
#'
#' @param K number of topics
#' @param V vocabulary size
#' @param J number of collections
#' @param collection.size number of documents in each collection (a list of J
#' elements)
#' @param doc.size number of words in each document
#' @param alpha.vec a set of values for document-level Dirichlet sampling
#' @param beta.samples the topic matrix beta 
#'
#' @return a list of generated corpus and their statistics
#'
#' @export
#'
#' @family corpus
#'
#' @details Last modified on: July 12, 2016
#'
#'
gen_synth_corpus_given_beta <- function(
  K, 
  V, 
  num.docs, 
  doc.size, 
  alpha.h, 
  beta.samples
){
  
  calc_topic_counts <- function(Z, K)
  {
    Nt <- array(0, c(1, K));
    for (k in 1:K) Nt[k] <- sum(Z == k);
    
    return(Nt);
  }
  
  theta.counts <- matrix(0, nrow = K, ncol = num.docs) # document topic word counts
  beta.counts <- matrix(0, nrow = K, ncol = V) # topic word counts
  
  theta.samples <- matrix(0, nrow = K, ncol = num.docs)
  
  
  did <- c()
  wid <- c()
  zid <- c()
  doc.N <- array(doc.size, dim = c(num.docs, 1))
  doc.idx <- vector("list", num.docs)
  docs <- vector("list", num.docs)
  word.idx <- 1; # initialize the corpus word index
  
  ptm <- proc.time()
  
  
  
  # Normalizes beta 
  for (k in 1:K) {
    beta.samples[k,]  <- beta.samples[k,] / sum(beta.samples[k,])
  }
  
  
  alpha.v <- array(alpha.h, c(K, 1))
  
  # Document sampling
  d.index <- 1
  
  for (d in 1:num.docs) {
    
    theta.samples[, d.index] <- sample_dirichlet(K, alpha.v);
    
    did <- cbind(did, array(1, c(1, doc.N[d.index])) * d.index); # document instances
    z_d <- c();
    indices <- c();
    
    # Word sampling
    word_ids <- rep(0, doc.N[d.index])
    for (i in 1:doc.N[d.index]) {
      
      # samples topic
      z_dn <- which(rmultinom(1, size = 1, prob = theta.samples[, d.index]) == 1)
      z_d <- cbind(z_d, z_dn)
      
      # samples word
      w_dn <- which(rmultinom(1, size = 1, beta.samples[z_dn,]) == 1)
      word_ids[i] <- w_dn - 1
      wid <- cbind(wid, w_dn)
      
      indices <- cbind(indices, word.idx)
      word.idx <- word.idx + 1
      
      
    }
    
    doc <- as.data.frame(table(word_ids))
    doc <- rbind(as.integer(levels(doc$word_ids)), doc$Freq)
    docs[[d.index]] <- doc
    doc.idx[[d.index]] <- as.integer(indices) # document word indices
    
    theta.counts[, d.index] <- calc_topic_counts(z_d, K) # document topic counts
    zid <- cbind(zid, z_d)
    
    d.index <- d.index + 1
  }
  
  
  total.N <- sum(doc.N);
  for (i in 1:total.N) {
    beta.counts[zid[i], wid[i]] <- beta.counts[zid[i], wid[i]] + 1;
  }
  
  ptm <- proc.time() - ptm
  cat("Corpus generation time: ", ptm[3], ", number of total words: ", total.N,
      "\n", sep = "")
  
  # returns a list
  list(
    docs = docs,
    did = as.vector(did),
    wid = as.vector(wid),
    zid = as.vector(zid),
    theta.counts = theta.counts,
    beta.counts = beta.counts,
    theta.samples = theta.samples,
    beta.samples = beta.samples,
    total.N = total.N,
    doc.N = doc.N,
    doc.idx = doc.idx
  )
  
}