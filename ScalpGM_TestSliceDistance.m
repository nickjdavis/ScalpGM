% Sanity check for distance routine
% Uses .\data3 folder for convenience

function ScalpGM_TestSliceDistance ()

T1 = '.\data3\HIVEx.img';
GM = '.\data3\c1HIVEx.nii';
SC = '.\data3\c5HIVEx.nii';

% Get slice from files
T1slice = [];
GMslice = [];
SCslice = [];

% plot for sanity

% get convex hull of SCslice

% plot convex hull

% get voxels from GM

% Step through voxels, getting nearest point on CH
% Draw line between GM voxel and CH point