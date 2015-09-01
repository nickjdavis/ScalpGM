% Returns mean of vals in each Brodmann area

function ScalpGM_GetMeanDistByBA (meanfile)














% https://sites.google.com/site/mvlombardo/matlab-tutorials
% % Example 1:  Ripping out BA 10 from a Brodmann Area Atlas
% 
% % Step 1:  Load in the Atlas
% BrodmannAtlas = spm_read_vols(spm_vol('/Users/mvlombardo/Documents/BrainAtlases/brodmann.img'));  % Reads in the brodmann atlas into a variable called BrodmannAtlas
% 
% % Step 2:  Make a mask that extracts BA 10.  I know that the Brodmann atlas has its voxels labeled based on the Brodmann Area number. I simply have to extract all voxels whose value is 10
% BA10 = ismember(BrodmannAtlas,10);  
% % ismember is a crucial function. Give it a matrix in the first argument and tell it the value you are looking for in that matrix within the second argument. 
% % Note that ismember takes BrodmannAtlas, assigns a logical value of "true" (or 1) to voxels whose value is 10, and assigns all other voxels a logical value of false (or 0). 
% 
% % Step 3:  Write out BA 10 as its own image.
% % Load the header information of another file of similar dimensions and voxel sizes
% V = spm_vol('/Users/mvlombardo/Documents/BrainAtlases/brodmann.img');
% 
% % Change the name in the header
% V.fname = 'BA10.nii';
% V.private.dat.fname = V.fname;
% 
% % Write out the new header and data
% spm_write_vol(V,BA10);