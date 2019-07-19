function ScalpGM_GetSubjectData (subjectInfo,ScalpGMinfo,outTableName)

% compiled info can go back into original file
if nargin<3
    outTableName = ScalpGMinfo;
end


% load subjectInfo (comes with OASIS)
% Check this - compatibility worry? Turning off warnings is Bad Form
warning('off','MATLAB:table:ModifiedVarnames')
infotable = readtable(subjectInfo);%,'text','Delimiter',',');
warning('on','MATLAB:table:ModifiedVarnames')

% load ScalpGMinfo (from previous processing steps)
    T = readtable(ScalpGMinfo);
    nFiles = size(T,1);

Age = zeros(nFiles,1);
eTIV= zeros(nFiles,1);
nWBV= zeros(nFiles,1);
Sex = ''; %% AARGHHH

% for each file in T, locate info in infotable
for i=1:nFiles
    % parse filename (a bit ugly...)
    f = T.imgfile{i};
    id = f(1:13);
    % find line matching subject number (some may be in twice)
    x = find(ismember(infotable.ID,id));
    % get [sex age eTIV nWBV]
    %Sex(i) = infotable.M_F(x);
    Age(i) = infotable.Age(x);
    eTIV(i)= infotable.eTIV(x);
    nWBV(i)= infotable.nWBV(x);
    Sex = [Sex; infotable.M_F(x)]; %% AAARAGHHH!
    % add info to table
    %disp(strcat(id,' ',num2str(a),' ',s))
end

T2 = table(Sex,Age,eTIV,nWBV);
outTable = [T T2];
writetable(outTable,outTableName)
