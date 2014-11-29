ScalpGM
=======

## Scalp-to-Grey Matter distance for TMS studies

Uses code from SPM12b to segment a T1 image, calculate scalp-GM distance, and to warp to a template.


### Current state:
* Segment and warp use SPM's job manager, which may be too slow
* Finding the convex hull of the scalp is very slow (60sec) and uses the image processing toolbox
* Need to think about collecting the warped images to apply group stats
