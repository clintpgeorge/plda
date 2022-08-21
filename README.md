# Parallelizable Markov Chain Monte Carlo Algorithms for the Latent Dirichlet Allocation Model

[Clint P. George](https://iitgoa.ac.in/~clint), [Hani Doss](https://users.stat.ufl.edu/~doss/) 

This **R** package, **plda**, implements the following Markov chain Monte Carlo (MCMC) algorithms for the latent Dirichlet allocation (LDA) model. 

1. Augmented Collapsed Gibbs Sampler (ACGS, [Griffiths and Steyvers 2004](#4), [George and Doss 2015](#7)) algorithm

2. Grouped Gibbs Sampler (GGS, [Doss and George 2022](#3)) algorithm

3. Partially Collapsed Gibbs Sampler (PCGS, [Magnusson et al. 2018](#1)) algorithm 

All three algorithms are implemented sequentially in this package. Algorithms GGS and PCGS are amenable to parallelization. For parallel implementations of GGS and PCGS, see [LDAGroupedGibbsSampler](https://github.com/clintpgeorge/LDAGroupedGibbsSampler). 

For package documentation run 

    help("plda")

in the R console. 

All major functions and datasets are documented and linked to 
the package index. Raw data files for each dataset are available in the 
**data-raw** folder. To load raw data see `demo/load_raw_data.R`.    



## References 

<a id="1">Magnusson, M., Jonsson, L., Villani, M., & Broman, D. (2018)</a>. Sparse partially collapsed MCMC for parallel inference in topic models. Journal of Computational and Graphical Statistics, 27(2), 449-463.

<a id="3">Doss, H. and George, C. (2022)</a>. Theoretical and Empirical Evaluation of a Grouped Gibbs Sampler for Parallel Computation in the Latent Dirichlet Allocation Model. In preparation. 

<a id="4">Griffiths, T. L., & Steyvers, M. (2004)</a>. Finding scientific topics. Proceedings of the National academy of Sciences, 101(suppl_1), 5228-5235.

<a id="6">Blei, D. M., Ng, A. Y., & Jordan, M. I. (2003)</a>. Latent Dirichlet allocation. Journal of machine Learning research, 3(Jan), 993-1022.

<a id="7">George, C. P. (2015)</a>. Latent Dirichlet Allocation: Hyperparameter Selection and Applications to Electronic Discovery. Ph.D. thesis, University of Florida.


