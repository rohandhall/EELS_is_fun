function [ output_args ] = EELS_plot( DM3_cell )
%EELS_PLOT Creates UI 
%   Detailed explanation goes here



%Parameters used for Curve Fitting 
MINZLP = -4;
MAXZLP  = 4;
MINFITWIN = 17;
MAXFITWIN = 23;
NFITPTS = 50;
output_args  = 0; % This variable is returned
dattest = [];

%This menu decides what will be plotted by picker tool
H_VAR_MENU = figure('Visible','off','Position',[1380,500,200,750]);
LIST_of_plottables = [];
NEWLIST_of_plottables = [];
PLOTTABLEbtnlist = []; %list of uicontrol variables 
NEWPLOTTABLEbtnlist = [];
btnlist_status = [];
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360,500,1000,750]);


%Fitting parameters for ZLP and Plasmon windows sit at the bottom of screen
min_zlp_btn = uicontrol('Style', 'edit', 'Position', [25, 25, 50, 20],'String', '-4',  'Callback',  {@get_minzlp});
min_zlp_txt = uicontrol('Style', 'text', 'Position', [25, 45, 50, 25], 'String', 'ZLP Fit Min (eV)');
max_zlp_btn = uicontrol('Style', 'edit', 'Position', [100, 25, 50, 20],'String', '4',  'Callback',  {@get_maxzlp});
max_zlp_txt = uicontrol('Style', 'text', 'Position', [100, 45, 50, 25], 'String', 'ZLP Fit Max (eV)');
min_fitwin_btn = uicontrol('Style', 'edit', 'Position', [175, 25, 50, 20],'String', '17',  'Callback',  {@get_minfitwin});
min_fitwin_txt = uicontrol('Style', 'text', 'Position', [175, 45, 50, 25], 'String', 'Fit Min (eV)');
max_fitwin_btn = uicontrol('Style', 'edit', 'Position', [250, 25, 50, 20],'String', '23',  'Callback',  {@get_maxfitwin});
max_fitwin_txt = uicontrol('Style', 'text', 'Position', [250, 45, 50, 25], 'String', 'Fit Max (eV)');
n_fitpts_btn = uicontrol('Style', 'edit', 'Position', [325, 25, 50, 20],'String', '50',  'Callback',  {@get_nfitpts});
n_fitpts_txt = uicontrol('Style', 'text', 'Position', [325, 45, 50, 25], 'String', 'No of FitPts');

%Simple callback functions
function  get_minzlp(source, callbackdata)
   if isnan(str2num(source.String))
        MINZLP = -4;
    else
        MINZLP = str2num(source.String);
    end
end

function  get_maxzlp(source, callbackdata)
   if isnan(str2num(source.String))
        MAXZLP = 4;
    else
        MAXZLP = str2num(source.String);
    end
end

function get_minfitwin(source, callbackdata)
   if isnan(str2num(source.String))
        MINFITWIN = 17;
    else
        MINFITWIN = str2num(source.String);
    end
end

function get_maxfitwin(source, callbackdata)
   if isnan(str2num(source.String))
        MAXFITWIN = 23;
    else
        MAXFITWIN = str2num(source.String);
    end
end

function  get_nfitpts(source, callbackdata)
   if isnan(str2num(source.String))
        NFITPTS = 10;
    else
        NFITPTS = str2num(source.String);
    end
end

%Begin the Spectrum Image display
%VARIABLES TO GET THE PLOT SIZE RIGHT
[SIcell, import_errm] = make_SI_cell(DM3_cell);
[nR, nC] = size(SIcell);
max_nR = 300;
max_nC = 600;
zoom_R = nR/ max_nR;
zoom_C  = nC/max_nC;

%THIS IS CHANGED EVERY TIME A SI IS PROCESSED
SIcell_new = SIcell;

%Spectrum Image display - Figure = 'f'
ax1 = axes('Units', 'pixels', 'Position', [50,100,300, 600]);
ax1.XLabel.String ='Column';
ax1.YLabel.String = 'Row';
ax1.Title.String = 'Current Spectrum Image';
set(ax1, 'ButtonDownFcn', {@picker} ); 
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%- Things done if window clicked on ax1
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

%Spectrum Display
%Variables start
SPEC_XMAX = 20;
SPEC_XMIN = 8;

% This is the XY Plot (output of picker)
ax2 = axes('Units', 'pixels', 'Position', [400, 500, 300, 200]);
ax2.XLabel.String = 'Energy Loss (eV)';
ax2.YLabel.String = 'Intensity';
ax2.Title.String = 'Spectrum';
spec_xmin_btn = uicontrol('Style', 'edit', 'Position', [400, 430, 50, 20],'String', '8',  'Callback',  {@get_spec_xmin});
spec_xmin_txt = uicontrol('Style', 'text', 'Position', [400, 450, 50, 25], 'String', 'Min (eV)');
spec_xmax_btn = uicontrol('Style', 'edit', 'Position', [475, 430, 50, 20], 'String', '20', 'Callback', {@get_spec_xmax} );
spec_xmax_txt = uicontrol('Style', 'text', 'Position', [475, 450, 50, 25], 'String','Max (eV)');


%Callback functions for Spectrum Display

function get_spec_xmin(source, callbackdata)
   if isnan(str2num(source.String) || str2num(source.String)> SPEC_XMAX)
        SPEC_XMIN = 8;
    else
        SPEC_XMIN= str2num(source.String);
        xlim(ax2, [SPEC_XMIN, SPEC_XMAX]);
    end 
end

function get_spec_xmax(source, callbackdata)
    if isnan(str2num(source.String)|| str2num(source.String) < SPEC_XMIN)
        SPEC_XMAX = 20;
    else
        SPEC_XMAX = str2num(source.String);
        xlim(ax2, [SPEC_XMIN, SPEC_XMAX]);
    end
end

function varlist = lookin_workspace()
% Returns a list of all variables which have dimensions nR,nC
    varlist_all = who;
        num_plottables = 0;
        
        for j = 1:length(varlist_all)
            if ~strcmp(varlist_all{j,1}, 'ans')
                if (size(eval(varlist_all{j,1})) == [nR, nC] )
                    num_plottables = num_plottables + 1;
                    varlist{num_plottables, 1} = varlist_all{j,1} ;
                end
            end
        end
end

function make_plot_buttons(varlist)
%This routine is called in 'picker' which is the callback function for a
%click in the spectrum image. The variable 'varlist' is generated by
%lookin_workspace function. 
        if strcmp(H_VAR_MENU.Visible,'off') 
            H_VAR_MENU.Visible = 'on'; %figure('Visible','on','Position',[1380,500,200,750]);
            dattest = zeros(nR,nC);
        end
        NEWPLOTTABLEbtnlist = [];
        figure(H_VAR_MENU);
        for j = 1:length(varlist)
            varname = varlist{j,1};
            NEWPLOTTABLEbtnlist(j) = uicontrol('Style', 'checkbox',...
                'String' , varname,...
                'Position', [20, 50+ (j-1)*75, 160, 50],...
                'Value', true);
        end
        PLOTTABLEbtnlist = NEWPLOTTABLEbtnlist;
end



function picker(source, callbackdata)
%This is the function that executes every time a click happes in ax1
% Everytime you click, it also checks workspace for possible plottable
% variables
    
    pt = ax1.CurrentPoint(1, 1:2);
    row  = round((1-pt(2))*nR);
    col = round((pt(1))*nC);
    if row == 0
        row=row+1;
    end
    
    if col == 0
        col=col+1;
    end
    %Find acceptable variables to plot
    NEWLIST_of_plottables = lookin_workspace();
    if (size(NEWLIST_of_plottables) ~= size(LIST_of_plottables))
        LIST_of_plottables = NEWLIST_of_plottables;
        make_plot_buttons(LIST_of_plottables);
        
    end
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    % Plot the data in the spectrum (X-Y) plot
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    
       
    
    data = SIcell_new{row, col};
    xd = data(:,1);
    yd = data(:,2);
    plot(ax2, xd,yd);
    xlim(ax2, [SPEC_XMIN, SPEC_XMAX]); 
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    % End Plot the data in the spectrum (X-Y) plot
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

    
    
end
f.Visible = 'on';


end

