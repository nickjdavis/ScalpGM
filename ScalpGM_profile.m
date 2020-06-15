
function ScalpGM_profile ()

d = 'C:\OASIS\X';


profile on
tic

ScalpGM (d)


t = toc;
profile viewer


sprintf('Elapsed time : %f sec',t)