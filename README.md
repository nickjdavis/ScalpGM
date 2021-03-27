ScalpGM
=======

## Scalp-to-Grey Matter distance for TMS studies

The effect of transcranial magnetic stimulation on the brain depends on many factors. One factor is the distance from the scalp to the surface of the brain (the grey matter). This project uses code from SPM12b to segment a T1 image, calculate scalp-grey matter distance, and to additionally return an MNI-space image for comparison with other images.


## Current status

This is a branch of ScalpGM, that complements a published paper. If you find the code useful, please cite the following publication:  
> Davis, N. J. (2021). Variance in cortical depth across the brain surface: Implications for transcranial stimulation of the brain. *European Journal of Neuroscience*, 53(4), 996-1007. [https://doi.org/10.1111/ejn.14957](https://doi.org/10.1111/ejn.14957)  
This version is not guaranteed to work perfectly on all systems, and may additionally contain code that is copyrighted to other authors. It therefore represents a snapshot of the developer's Matlab folder. Code in this branch may be poorly commented, and may have dependencies that are not contained in the branch.  
Future versions of this code will be released in the working or master branches.

### Getting started

ScalpGM is a collection of Matlab scripts. Matlab is a commercial programming language developed by [Mathworks Inc](https://uk.mathworks.com/products/matlab.html). The [Octave programming language](https://www.gnu.org/software/octave/) is free and largely compatible with Matlab, but these scripts have not been tested in Octave.  
ScalpGM requires SPM to be installed. The code was developed with SPM12b, but earlier (or later) versions of SPM may also work. SPM was developed by the Wellcome Centre for Human Neuroimaging, and can be downloaded [via this page](https://www.fil.ion.ucl.ac.uk/spm/).  
ScalpGM needs data to work with. The data for testing this package came from the [Open Access Series of Imaging Studies, or OASIS](https://www.oasis-brains.org/). The images of non-demented participants from OASIS-1 was used in development.  


### Running ScalpGM


ScalpGM can be run with two options, either with a pointer to a folder for processing, or (better), with a pre-prepared log file.  

The log file format is a comma-separated file with a two columns labelled 'imgfolder' and 'imgfile', containing a list of T1 images. Use the 'filelist' option to load this. For example...

```Matlab
>> type T1files.txt

imgfolder,imgfile
C:\Users\Nick\Data\Subject1\ScalpGM,Subject1_T1.nii
C:\Users\Nick\Data\Subject2\ScalpGM,Subject2_T1.nii
C:\Users\Nick\Data\Subject3\ScalpGM,Subject3_T1.nii
C:\Users\Nick\Data\Subject4\ScalpGM,Subject4_T1.nii

>> ScalpGM('filelist','T1files.txt')
```
This will generate a lot of text in the command window, mainly from SPM's functions.  
The output from this is a series of extra columns in the input file, with the names of the processed files.  
The second form, with a pointer to a folder, is not stable and will generate a warning (if not an error).

```Matlab
>> ScalpGM('folder','C:\Users\Nick\Data')
```

### Main branches
* master
  * Latest version that passes tests
  * Should be robust across platforms
  * Should produce accurate data
* working
  * Working version
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
* Profile! 
  * Some function use for loops which could be streamlined


### To think about
* Smooth convex hull? Cap at nasion/inion?
* Spatial smoothing?
* Measure memory use at runtime? Predict/preallocate memory usage
