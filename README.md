ScalpGM
=======

## Scalp-to-Grey Matter distance for TMS studies

The effect of transcranial magnetic stimulation on the brain depends on many factors. One factor is the distance from the scalp to the surface of the brain (the grey matter). This project uses code from SPM12b to segment a T1 image, calculate scalp-grey matter distance, and to additionally return an MNI-space image for comparison with other images.


### Getting started

ScalpGM is a collection of Matlab scripts. Matlab is a commercial programming language developed by [Mathworks Inc](https://uk.mathworks.com/products/matlab.html). The [Octave programming language](https://www.gnu.org/software/octave/) is free and laregly compatible with Matlab, but these scripts have not been tested in Octave.
ScalpGM requires SPM to be installed. The code was developed with SPM12b, but earlier (or later) versions of SPM may also work. SPM was developed by the Wellcome Centre for Human Neuroimaging, and can be downloaded [via this page](https://www.fil.ion.ucl.ac.uk/spm/).
ScalpGM needs data to work with. The data for testing this package came from the [Open Access Series of Imaging Studies, or OASIS](https://www.oasis-brains.org/). The images of non-demented participants from OASIS-1 was used in development.



### Current state:

* Segment and warp use SPM's job manager, which may be too slow
* Finding the convex hull of the scalp is very slow (60sec) and uses the image processing toolbox
* Need to think about collecting the warped images to apply group stats


### Branches
* Master
 * Latest version that passes tests
 * Not guaranteed to be robust across platforms
 * Not guaranteed to produce accurate data
* CribGoch
 * Working version
 * Extract data from OASIS
 * Runs cleanly and efficiently
 * Shareable code
* Elidir
 * Later modifications/tweaks
 * Parallel code
 * Integrate with SPM


### TODO
* MeanImage code works okay, but NaNs in CoV - do we need this?
* Diagram of processing stages
* Warp back to native
* Add mask back to MeanImage - should clean up and reduce memory
* Helper functions for OASIS data
  * Extract demographic data
  * Convert OASIS images for SPM
  * Go through folder structure and flatten
* Smarter routine to identify outer scalp layer
  * See Line 86 of getCH3d - re-add biggest region?
* Use SPM environment variables to:
  * set folders  (e.g. TPM.nii)
  * check for presence of SPM
  * check SPM version?
* Profile! 20 mins per image - must get this down.


### To think about
* Identify ROIs for stats (M1, V1, frontal pole?)
* Smooth convex hull? Cap at nasion/inion?
* Spatial smoothing?
* Can I measure memory use at runtime?
* What does a user want to know? -- How to adjust TMS output for given target
* Is the output a sparse matrix?