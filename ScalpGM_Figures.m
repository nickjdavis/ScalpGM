% Make figures for ScalpGM

function ScalpGM_Figures(F)

% test for mni2fs
pathstring = path();
if ~contains(pathstring,'mni2fs')
    % No SPM in path. Need to add
    disp('Adding mni2fs to path')
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\export_fig');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\freezeColors');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\gifti-1.4');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\misc');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\myaa');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\nifti_tools');
    %addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\private');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\surf');
end

T1file= '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM/single_subj_T1.nii';
Mfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLPOSTFIX_M.nii';
Sfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLPOSTFIX_SD.nii';
Cfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLPOSTFIX_COV.nii';
ROIfile='\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\newROIIMAGE.nii';
Afile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ROI_MNI_V4.nii';
tablefile = 'OASIS-All.txt';


%% ---- NEW

% PAPER FIGURE 1 - process image
if any(F==1)
end


% PAPER FIGURE 2 - scatterplots
if any(F==2)
    T = readtable(tablefile,'delimiter',',');
    figure
    yyaxis left
    plot(T.Age,T.eTIV,'ko','MarkerFaceColor',[0 0 0])
    %ylabel('Estimated total intracranial volume ($\bullet$, mL)',...
    %    'Interpreter','latex','Color','k') 
    ylabel('Estimated total intracranial volume (   , mL)',...
        'Interpreter','tex','Color','k') % NB wrong symbol - edit later
    set(gca,'YLim',[500 2000])
    set(gca,'YColor','k')
    yyaxis right
    % add trendline
    A = [25 60]; V = A*-.001+.871;
    line (A,V,'Color','k','LineWidth',2)
    hold on
    plot(T.Age,T.nWBV,'kv','MarkerFaceColor',[.6 .6 .6])
    ylabel('Normalised whole-brain volume (\nabla, proportion)',...
       'Interpreter','tex','Color','k')
    %ylabel('Normalised whole-brain volume (   , proportion)',...
    %    'Interpreter','tex','Color','k')
    set(gca,'YLim',[.70 1.2])
    xlabel('Age (years)')
    set(gca,'XLim',[23 62])
    set(gca,'YColor','k')
end


% PAPER FIGURE 3 - Mean/SD/CoV projected onto flattened surface
if any(F==3)
    NIFTI = mni2fs_load_nii(Mfile); % mnivol can be a NIFTI structure
    X = find(isnan(NIFTI.img));
    m = nanmean(nanmean(nanmean(NIFTI.img)));
    NIFTI.img(X) = m; % zero here smooths the nans
    % Load and Render the FreeSurfer surface
    % Mean LH
    figure('Color','w','position',[20 72 600 500])
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid'; % was pial - mid better
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    %S.surfacetype = 'xx'; % NOT USED???? was 'inflated' ('xx',pial, smoothwm, mid no diff)
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.smoothdata = 2; % 1, 3 worse than zero - propagating nans?
    S.clims = [10 45];
    S.clims_perc = .00001; % overlay masking below 98th percentile
    S.interpmethod = 'nearest'; % 'spline' crashes; 'linear', 'cubic' worse
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar;
    % Mean RH
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    %S
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    %NIFTI = mni2fs_load_nii(Mfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.smoothdata = 2; % 1, 3 worse than zero - propagating nans?
    S.clims = [10 45];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    %S
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar
    
   % SD LH
    NIFTI = mni2fs_load_nii(Sfile); % mnivol can be a NIFTI structure
    X = find(isnan(NIFTI.img));
    m = nanmean(nanmean(nanmean(NIFTI.img)));
    NIFTI.img(X) = m; % zero here smooths the nans
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid';
    S.smoothdata = 2;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.clims = [0 15];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar
    % SD RH
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid';
    S.smoothdata = 2;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    %NIFTI = mni2fs_load_nii(Sfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.clims = [0 15];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar
    
    % CoV LH
    figure('Color','w','position',[20 72 600 500])
    NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    X = find(isnan(NIFTI.img));
    m = nanmean(nanmean(nanmean(NIFTI.img)));
    NIFTI.img(X) = m; % zero here smooths the nans
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid';
    S.smoothdata = 2;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.clims = [0 .4];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar
    
    % CoV RH
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid';
    S.smoothdata = 2;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    %NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.climstype = 'pos';
    S.clims = [0 .4];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    colorbar
end
    
    
% PAPER FIGURE 4 - Boxplot of CoV
if any(F==4)
    % A few common properties
    xCenter = [1 2 4 5 7 8 10 11 13 14];
    spread = 0.25; % 0=no spread; 0.5=random spread within box bounds (can be any value)
    txtCentres = [1.5 4.5 7.5 10.5 13.5];

    % Mean first
    figure; hold on;
    T = readtable('tempM.csv');
    allData = {T.PreLM; T.PreRM; T.PFCLM; T.PFCRM;...
        T.OccLM; T.OccRM; T.AngLM; T.AngRM; T.TemLM; T.TemRM};
     group = [ones(size(T.PreLM));
        2 * ones(size(T.PreRM));
        4 * ones(size(T.PFCLM));
        5 * ones(size(T.PFCRM));
        7 * ones(size(T.OccLM));
        8 * ones(size(T.OccRM));
        10* ones(size(T.AngLM));
        11* ones(size(T.AngRM));
        13* ones(size(T.TemLM));
        14* ones(size(T.TemRM))];
    for i = 1:numel(allData)
        plot(rand(size(allData{i}))*spread -(spread/2) + xCenter(i), allData{i}, 'k.','linewidth', 2)
    end
    h = boxplot(cell2mat(allData),group,'Notch','on','positions',xCenter,...
        'Symbol','ko','OutlierSize',4);
    set(h, 'linewidth' ,2,'Color','k')
    set(gca,'XLim',[-.5 15.5])
     set(gca,'YLim',[13 30])
    set(gca,'YTick',14:2:28)
    set (gca,'XTick',txtCentres);
    set(gca,'XTickLabel', {'Pre'; 'PFC'; 'Occ'; 'Ang'; 'Tem'})
    TXT = {'**','**','ns','**','ns'};
    y = 29;
    for i=1:5
        text (txtCentres(i),y,TXT{i},'FontSize',18,'HorizontalAlignment','center',...
            'VerticalAlignment','middle');
    end
    ylabel('Mean depth (mm)')

% CoV image
    figure; hold on;
    T = readtable('tempC.csv');
    allData = {T.PreLC; T.PreRC; T.PFCLC; T.PFCRC;...
       T.OccLC; T.OccRC; T.AngLC; T.AngRC; T.TemLC; T.TemRC};
    group = [ones(size(T.PreLC));
       2 * ones(size(T.PreRC));
       4 * ones(size(T.PFCLC));
       5 * ones(size(T.PFCRC));
       7 * ones(size(T.OccLC));
      8 * ones(size(T.OccRC));
       10* ones(size(T.AngLC));
       11* ones(size(T.AngRC));
       13* ones(size(T.TemLC));
       14* ones(size(T.TemRC))];
    for i = 1:numel(allData)
        plot(rand(size(allData{i}))*spread -(spread/2) + xCenter(i), allData{i}, 'k.','linewidth', 2)
    end
    h = boxplot(cell2mat(allData),group,'Notch','on','positions',xCenter,...
        'Symbol','ko','OutlierSize',4);
    set(h, 'linewidth' ,2,'Color','k')
    set(gca,'YLim',[.33 .55])
    set(gca,'YTick',.34:.02:.54)
    set (gca,'XTick',txtCentres);
    set(gca,'XTickLabel', {'Pre'; 'PFC'; 'Occ'; 'Ang'; 'Tem'})
    TXT = {'**','*','**','ns','ns'};
    y = .54;
    for i=1:5
        text (txtCentres(i),y,TXT{i},'FontSize',18,'HorizontalAlignment','center',...
            'VerticalAlignment','middle');
    end
    xlabel('Region of interest')
    ylabel('Coefficient of variation')
end


% PAPER FIGURE 5 - Correlation maps
% NB - this is unwiedly, so use comment blocks to select subfigures
if any(F==5)
    
    M1corr =...
        '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM M1 [-22 -22 73] corr r.nii';
    V1corr =...
        '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM V1 [-16 -92 6] corr r.nii';
    %{
    % M1 Left - lateral
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(M1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % M1 Left - medial
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(M1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % M1 Right - medial
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(M1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % M1 Right - lateral
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(M1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    %}

    % V1 Left - lateral
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(V1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % V1 Left - medial
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(V1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % V1 Right - medial
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(V1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
    % V1 Right - lateral
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(V1corr); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    %S.clims = [0.4 1];
    S.clims_perc = 0;%0.0000001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S
    colorbar
end


% PAPER FIGURE 6 - M1-V1 corr scatter
if any(F==6)    
    load('M1V1corrnew')
    M=[]; F=[]; 
    for i=1:94
        if strmatch(Sex{i},'M')
            M=[M;i];
        else
            F=[F;i];
        end
    end
    figure; hold on
    plot(M1depth8mm(F),V1depth8mm(F),'kv','MarkerFaceColor',[1 1 1])
    plot(M1depth8mm(M),V1depth8mm(M),'ko','MarkerFaceColor',[0 0 0])
    ylabel('Depth of V1 (mm)')
    set(gca,'YLim',[10 30])
    xlabel('Depth of M1 (mm)')
    set(gca,'XLim',[15.5 24.5])
    legend('Female','Male')
end


%% ---- OLD
%{
    % REMOVED
%}



%% POSTER IMAGES

% POSTER FIGURE 1B - Map of ROIs
if any(F==1002)
    % plots ROIS straight from atlas image.
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S.surfacesolorspec = [.5 .5 .5];
    S = mni2fs_brain(S);
    % Add overlay
    NIFTI = mni2fs_load_nii(Afile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
    % faff with data
    I = S.mnivol.img;
    X = zeros(size(I));
    X(find(I==2001))=1; % L motor
    X(find(I==2201))=2; % L PFC
    X(find(I==5101))=3; % L Occ
    X(find(I==6221))=4; % L ang
    X(find(I==8111))=5; % L temp
    S.mnivol.img = X;
    
    
    S.climstype = 'pos';
    S.clims_perc = 0.05; % overlay masking below this percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S.mnivol
end

% POSTER FIGURE 1C - CoV bars graph
if any(F==1003)
    cov= [.4230 .4378; .4016 .3992; .4671 .4428; .4127 .4129; .4403 .4404];
    sd = [.0134 .0155; .0135 .0143; .0221 .0197; .0194 .0164; .0161 .0122];
    barweb(cov,sd,[],{'PreC','PreF','Occ','Ang','Tem'},[],'Area','CoV (+/-1SD)')
end


% POSTER FIGURE 1A - CoV map
if any(F==1001)
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
    S.climstype = 'pos';
    S.clims = [0 .4];
    S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S
end


%% DRAFT IMAGES


% corr img
if any(F==9999)
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S.surfacecolorspec = [.5 1 .5];
    S = mni2fs_brain(S);
    
    % Add overlay, theshold to 98th percentile
    f = 'ScalpGM M18mm [-37 -25 62] corr r.nii';
    NIFTI = mni2fs_load_nii(f); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
%     S.climstype = 'pos';
     S.clims = [-0.4 0.4];
     %S.clims_perc = 1; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S

    colorbar
end

if any(F==9998)
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    %S.surfacecolorspec = [0 1 0];
    S = mni2fs_brain(S);
    
    % Add overlay, theshold to 98th percentile
    f = 'ScalpGM M18mm [-37 -25 62] corr p.nii';
    NIFTI = mni2fs_load_nii(f); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
     S.climstype = 'pos';
     S.clims = [0 .05];
     %S.clims_perc = 1; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S
    colorbar
end

% corr img
if any(F==9997)
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'rh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S.surfacecolorspec = [.5 1 .5];
    S = mni2fs_brain(S);
    
    % Add overlay, theshold to 98th percentile
    f = 'ScalpGM V18mm [-12 -100 5] corr r.nii';
    NIFTI = mni2fs_load_nii(f); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
%     S.climstype = 'pos';
     S.clims = [-0.4 0.4];
     %S.clims_perc = 1; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    %S

    colorbar
end

