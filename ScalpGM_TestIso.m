% Uses iso2mesh to produce a mesh of scalp and GM

function ScalpGM_TestIso ()

th = 0.95;

% load scalp data
SC = '.\data3\c5HIVEx.nii';
GM = '.\data3\c1HIVEx.nii';
SCdata = spm_read_vols (spm_vol(SC));
GMdata = spm_read_vols (spm_vol(GM));
% SCmask = imbinarize(SCdata,th);

% do mesh
% [node,elem,face]=v2m(img,isovalues,opt,maxvol,method)

[Ns,Es,Fs] = v2m (SCdata,.95,5,100);
[Ng,Eg,Fg] = v2m (GMdata,.95,5,100);



% display
isoplotmesh (Ns,Fs)
figure
isoplotmesh (Ng,Fg)