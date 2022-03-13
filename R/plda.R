#' @title Markov chain Monte Carlo Algorithms for the Latent Dirichlet 
#' Allocation Model
#'
#' @description 
#' This R package implements several Markov chain Monte Carlo (MCMC) algorithms 
#' for the latent Dirichlet allocation (LDA, Blei et al. 2003) model. This  
#' includes:
#' 
#'    1. The augmented collapsed Gibbs sampling (ACGS, Griffiths and Steyvers 
#'    2004, George and Doss 2015) algorithm
#'    
#'    2. The full Gibbs sampling (FGS, George and Doss 2015) algorithm
#'    
#'    3. Posterior predictive checking (PPC, Chen and Doss 2015)
#' 
#' 
#' @references 
#' 1. Blei, D. M., Ng, A. Y. and Jordan, M. I. (2003). Latent Dirichlet 
#' allocation. Journal of Machine Learning Research 3 993-1022.
#' 
#' 2. Chen, Z. and Doss, H. (2015). Inference for the number of topics in the 
#' latent Dirichlet allocation model via Bayesian mixture modelling. Tech. rep., 
#' Department of Statistics, University of Florida.
#' 
#' 5. Griffiths, T. L. and Steyvers, M. (2004). Finding scientific topics. 
#' Proceedings of the National Academy of Sciences 101 5228-5235.
#' 
#' @docType package
#' 
#' @aliases
#' plda
#' package-plda
#' 
#' @useDynLib plda 
#' 
#' @name plda
#' 
#' @author Clint P. George and Hani Doss
NULL