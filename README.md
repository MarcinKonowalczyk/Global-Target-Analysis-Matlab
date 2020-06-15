[![View Global-Target-Analysis-Matlab on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/76974-global-target-analysis-matlab)

# Global-Target-Analysis-Matlab

Global target analysis is commonly used when attempting to model / fit / deconvolve transient absorption (TA) data, but can really be used in any case where the data is represented by a 2D matrix defined by two experimental dimensions. In the case case of TA these dimensions are wavelength and time.

This script is intended as a demonstrations of basic approaches to the global target analysis. It should not be used as-is, but instead studies and understood. The purpose of this script is only to provide a path to learning the global target analysis method.

If a more automated approach is required, there are some excellent toolboxes for global analysis out there (see below). A thorough understanding of the methodology is, however, strongly recommended before using any automated approaches / toolboxes.

## Things to watch out for

- Just like with any modelling, overfitting is a problem. _'With four parameters I can fit an elephant, and with five I can make it wiggle its trunk'_ - Jonny von Neumann (See [Drawing an elephant with four complex parameters](https://publications.mpi-cbg.de/Mayer_2010_4314.pdf), Mayer et al. _American Journal of Physics_ 78, 648 (2010), DOI: [10.1119/1.3254017](https://www.doi.org/10.1119/1.3254017))
- Local minima are very much of a problem in fitting / regression in general. Global target analysis is particularity susceptible to this problem since it deals with multidimensional **and** non-linear models. The code here uses a basic simplex solver (`fminseach`) but, in general, one ought to consider a way of ensuring the solution is a global (putative) minimum. This can, for example, be achieved by using a solver more adapted to finding global minima (e.g. `patternsearch`) or using an exploratory algorithm (e.g. `ga`) to understand better the behaviour of the particular fitting problem.
- Global analysis as shown here assumes that parameters of the model in one dimension are invariant in the other. For example, the species-associated spectra are invariant in time (bar the scaling by the fraction of species present)

## References

For further reading on global target analysis see the following:

- [PyLDM - An open source package for lifetime density analysis of time-resolved spectroscopic data](https://spiral.imperial.ac.uk/bitstream/10044/1/48800/13/journal.pcbi.1005528.pdf), Dorlhiac et al. _PLoS Computational Biology_ 13(5), 2017, DOI: [10.1371/journal.pcbi.1005528](https://doi.org/10.1371/journal.pcbi.1005528)
- Global and target analysis of time-resolved spectra, Stokkum et al. _Biochimica et Biophysica Acta (BBA) - Bioenergetics_
1657(2–3), 2004, DOI: [10.1016/j.bbabio.2004.04.011](https://doi.org/10.1016/j.bbabio.2004.04.011)

<cr>

- [Ultrafast Toolbox](http://www.imperial.ac.uk/life-sciences/vanthor/ultrafast-toolbox/) from Imperial College London.
- [GloTarAn](https://github.com/glotaran) - a modelling framework for global target analysis
- [PyLDM](http://www.github.com/gadorlhiac/pylda) - Lifetime density analysis software

## ToDos

- [ ] Add principal component analysis / SVD example
