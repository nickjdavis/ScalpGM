
function ScalpGM_profile ()

d = 'C:\OASIS\Z';


profile on
tic

ScalpGM ('folder',d, 'useExisting', true, 'logfile','profiletext.txt')

ScalpGM_NewMean ('profiletext.txt','TESTPROFILE.nii')

M1MNI = [-37 -21 58];
ScalpGM_Correlation ('profiletext.txt',[M1MNI 5])

t = toc;
profile viewer


m = floor(t/60);
s = floor(rem(t,60));

sprintf('Elapsed time : %dm%ds',m,s)