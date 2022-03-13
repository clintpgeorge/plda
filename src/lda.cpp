# include "lda.h"

///////////////////////////////////////////////////////////////////////////////
// LDA: Helper functions
///////////////////////////////////////////////////////////////////////////////

/***
* Computes the log posterior probability of (theta, beta, z) up to a
* multiplicative constant.
*
*/
double lda_log_posterior(
    const arma::uvec & doc_word_counts,
    const arma::mat & theta_samples,
    const arma::mat & beta_samples,
    const vector < vector < unsigned int > > & doc_word_ids,
    const vector < vector < unsigned int > > & doc_word_zids,
    const double alpha_h,
    const double eta_h){

  double lp = 0.0;
  unsigned int d, i, num_docs, num_topics, vocab_size;
  arma::mat log_theta = log(theta_samples);
  arma::mat log_beta = log(beta_samples);
  num_topics = beta_samples.n_rows;
  vocab_size = beta_samples.n_cols;
  num_docs = theta_samples.n_cols;
  arma::vec n_dj(num_topics);
  arma::mat m_djt(num_topics, vocab_size);

  for (d = 0; d < num_docs; d++){ // for each document

    vector < unsigned int > word_ids = doc_word_ids[d];
    vector < unsigned int > word_zids = doc_word_zids[d];

    n_dj.fill(0.);
    m_djt.fill(0.);
    for (i = 0; i < doc_word_counts(d); i++){
      n_dj(word_zids[i]) += 1;
      m_djt(word_zids[i], word_ids[i]) += 1;
    }

    lp += arma::accu(m_djt % log_beta);
    lp += arma::accu((n_dj + alpha_h - 1.0) % log_theta.col(d));

  }

  lp += arma::accu((eta_h - 1.0) * log_beta);

  return lp;
}


/***
 * Computes the log maginal posterior probability of z up to a multiplicative 
 * constant.
 *
 */
double lda_log_posterior_z(
    const unsigned int num_topics, 
    const unsigned int vocab_size, 
    const unsigned int num_docs,
    const arma::uvec & doc_word_counts,
    const vector < vector < unsigned int > > & doc_word_ids,
    const vector < vector < unsigned int > > & doc_word_zids,
    const double alpha_h,
    const double eta_h){
  
  double lp = 0.0;
  unsigned int d, i, j;
  arma::vec n_dj(num_topics);
  arma::vec m_j = arma::zeros<arma::vec>(num_topics);
  arma::mat m_jt = arma::zeros<arma::mat>(num_topics, vocab_size);
  
  for (d = 0; d < num_docs; d++){ // for each document
    vector < unsigned int > word_ids = doc_word_ids[d];
    vector < unsigned int > word_zids = doc_word_zids[d];
    n_dj.fill(0.);
    for (i = 0; i < doc_word_counts(d); i++){
      n_dj(word_zids[i]) += 1;
      m_jt(word_zids[i], word_ids[i]) += 1;
      m_j(word_zids[i]) += 1;
    }
    lp += arma::accu(lgamma(n_dj + alpha_h));
  } // for each document
  
  for (j = 0; j < num_topics; j++) { // for each topic 
    lp += arma::accu(
      lgamma(m_jt.row(j) + eta_h) - lgammaf(m_j(j) + vocab_size * eta_h)
    );
  } // for each topic 

  return lp;
}





