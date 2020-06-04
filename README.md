ScalpGM
=======

## Scalp-to-Grey Matter distance for TMS studies

The effect of transcranial magnetic stimulation on the brain depends on many factors. One factor is the distance from the scalp to the surface of the brain (the grey matter). This project uses code from SPM12b to segment a T1 image, calculate scalp-grey matter distance, and to additionally return an MNI-space image for comparison with other images.


## Current status

This is a working (i.e. development) branch of ScalpGM. 
This version is not guaranteed to work perfectly on all systems, and may additionally contain code that is copyrighted to other authors. It therefore represents a snapshot of the developer's Matlab folder. Code in this branch may be poorly commented, and may have dependencies that are not contained in the branch.
Future versions of this code will be released in the working or master branches.

### Getting started

ScalpGM is a collection of Matlab scripts. Matlab is a commercial programming language developed by [Mathworks Inc](https://uk.mathworks.com/products/matlab.html). The [Octave programming language](https://www.gnu.org/software/octave/) is free and largely compatible with Matlab, but these scripts have not been tested in Octave.
ScalpGM requires SPM to be installed. The code was developed with SPM12b, but earlier (or later) versions of SPM may also work. SPM was developed by the Wellcome Centre for Human Neuroimaging, and can be downloaded [via this page](https://www.fil.ion.ucl.ac.uk/spm/).
ScalpGM needs data to work with. The data for testing this package came from the [Open Access Series of Imaging Studies, or OASIS](https://www.oasis-brains.org/). The images of non-demented participants from OASIS-1 was used in development.


### Running ScalpGM

ScalpGM takes as input a CSV-format file with a single column labelled 'imgfile', containing a list of T1 images. For example...

```Matlab
>> type T1files.txt

XXX

>> ScalpGM('T1files.txt')
```
The output from this is a series of extra columns in the input file, with the names of the processed files.


### Current state:

* Segment and warp use SPM's job manager, which may be too slow
* Finding the convex hull of the scalp is very slow (60sec) and uses the image processing toolbox


### Branches
* master
  * Latest version that passes tests
  * Should be robust across platforms
  * Should produce accurate data
* working
  * Working version
  * Extract data from OASIS
  * Runs cleanly and efficiently
  * Shareable code
* BrainSTIM2020
  * Snapshot of working branch
  * Complements a talk given at BrainSTIM2020 in May 2020
  * All code and (Matlab-based) analyses were run from this code 
* Preprint
  * Snapshot of working branch
  * Complements a preprint of the accompanying paper


### TODO
* Warp back to native
* Add mask back to _MeanImage - should clean up and reduce memory
* Helper functions for OASIS data
  * Extract demographic data
  * Convert OASIS images for SPM
  * Go through folder structure and flatten
* Smarter routine to identify outer scalp layer
  * See Line 86 of _getCH3d - re-add biggest region?
* Use SPM environment variables to:
  * set folders  (e.g. TPM.nii)
  * check for presence of SPM
  * check SPM version?
* Profile! 20 mins per image - must get this down.


### To think about
* Smooth convex hull? Cap at nasion/inion?
* Spatial smoothing?
* Measure memory use at runtime? Predict/preallocate memory usage
