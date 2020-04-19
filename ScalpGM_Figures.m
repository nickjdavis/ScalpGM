% Make figures for ScalpGM

function ScalpGM_Figures(F)

% test for mni2fs
pathstring = path();
if isempty(strfind(pathstring,'mni2fs'))
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

T1file = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM/single_subj_T1.nii';
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
    
    

% PAPER FIGURE 4 - CoV bars graph
if any(F==4)
    figure;
    cov= [.4230 .4378; .4016 .3992; .4671 .4428; .4127 .4129; .4403 .4404];
    sd = [.0134 .0155; .0135 .0143; .0221 .0197; .0194 .0164; .0161 .0122];
    barweb(cov,sd,[],{'PreC','PreF','Occ','Ang','Tem'},[],'Area','CoV (+/-1SD)')
    hold on;
    TXT = {'**','*','**','ns','ns'};
    y = .5;
    for i=1:5
        text (i,y,TXT{i},'FontSize',14,'HorizontalAlignment','center',...
            'VerticalAlignment','middle');
    end
end






%% ---- OLD

% CoV image 
if any(F==11111111) % NO
    figure('Color','k','position',[200 72 600 400])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 6; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated'; % options: 'inflated', 'pial', 'mid' or 'smoothwm'
    S.lookupsurf = 'pial'; % options: 'pial', 'mid' or 'smoothwm'
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(fullfile(sgmdir,Cfile.nii));
    S.mnivol = NIFTI;
    S.clims_perc = 0.8; % overlay masking below 98th percentile
    S.overlayalpha = 1;
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
end



% Draw one
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','lh')
% if any(F==1)
%     mni2fs_auto(Cfile,'lh')
% end

if any(F==3111111) % NO
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S = mni2fs_brain(S);
    NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S = mni2fs_overlay(S);
    S
end

% Draw two
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','lh')
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','rh')
% view([40 30])


% CV figure
if any(F==2111111) % NO
    figure('Color','k','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S = mni2fs_brain(S);
    %S.mnivol = fullfile('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/HOA_heschlsL.nii');
    S.mnivol = fullfile(T1file);
    % S.roicolorspec = 'm'; % color. Can also be a three-element vector
    S.roialpha = 1; % transparency 0-1
    S = mni2fs_roi(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.clims_perc = 0.8; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    % mni2fs_lights; % Dont forget to turn on the lights!
end



% CV figure - copied from other laptop
if any(F==4111111) % CLOSER
    figure('Color','w','position',[20 72 600 500])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'both'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'pial';
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(Cfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.clims_perc = 0.05; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S
end



if any(F==9911111)
    % plot CoV on inflated figure
    % add chosen AAL ROIs as patches
    
        figure('Color','k','position',[20 72 600 500])
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
    NIFTI = mni2fs_load_nii(ROIfile); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    S.clims_perc = 0.05; % overlay masking below this percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S.mnivol

end





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

if any(F==222)
    M1corr =...
        '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM [-22 -22 73] corr r.nii';
    M1pval =...
        '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM [-22 -22 73] corr p.nii';
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
    NIFTI = mni2fs_load_nii(M1pval); % mnivol can be a NIFTI structure
    S.mnivol = NIFTI;
    
    S.climstype = 'pos';
    %S.clims = [0.4 1];
    %S.clims_perc = 0.00001; % overlay masking below 98th percentile
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
    S
    colorbar
end

