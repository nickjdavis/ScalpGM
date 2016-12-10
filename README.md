ScalpGM
=======

## Scalp-to-Grey Matter distance for TMS studies

Uses code from SPM12b to segment a T1 image, calculate scalp-GM distance, and to warp to a template.


### Current state:
* Segment and warp use SPM's job manager, which may be too slow
* Finding the convex hull of the scalp is very slow (60sec) and uses the image processing toolbox
* Need to think about collecting the warped images to apply group stats


### TODO
* MeanImage code works okay, but NaNs in CoV - do we need this?
* Use real dimensions (not 10cm)
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



### To think about
* Identify ROIs for stats (M1, V1, frontal pole?)
* Smooth convex hull? Cap at nasion/inion?
* Spatial smoothing?
* Can I measure memory use at runtime?
* What does a user want to know? -- How to adjust TMS output for given target
* Is the output a sparse matrix?