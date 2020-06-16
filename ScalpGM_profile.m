
function ScalpGM_profile ()

d = 'C:\OASIS\X';


profile on
tic

ScalpGM ('folder',d)


t = toc;
profile viewer


sprintf('Elapsed time : %f sec',t)