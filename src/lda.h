# include "utils.h"

///////////////////////////////////////////////////////////////////////////////
// Helper functions
///////////////////////////////////////////////////////////////////////////////

extern
  double lda_log_posterior(
      const arma::uvec & doc_word_counts,
      const arma::mat & theta_samples,
      const arma::mat & beta_samples,
      const vector < vector < unsigned int > > & doc_word_ids,
      const vector < vector < unsigned int > > & doc_word_zids,
      const double alpha_h,
      const double eta_h);

extern
  double lda_log_posterior_z(
      const unsigned int num_topics, 
      const unsigned int vocab_size, 
      const unsigned int num_docs,
      const arma::uvec & doc_word_counts,
      const vector < vector < unsigned int > > & doc_word_ids,
      const vector < vector < unsigned int > > & doc_word_zids,
      const double alpha_h,
      const double eta_h);