% Usage: event_gui
%
% Copyright (C) 2017, University of Oldenburg, Germany.
% Author : Manuela Jaeger M.Sc., manuela.jaeger@uni-oldenburg.de, Neuropsychology Lab, University of Oldenburg, Germany 
% Date   : 02.03.2017 
% Updated:  <>

evspec_item={'Codes','Tags'};
evspec_item_length=length(evspec_item);

taskLabel_item_length=size(db.tasksInfo,2);
taskLabel_item = [];
for n=1:taskLabel_item_length
    taskLabel_item{n}=db.tasksInfo(n).taskLabel;
end

if exist('fig7','var');
    if ishandle(fig7)
        close(fig7);
    end
end

fig7 = figure(...
    'Units','points', ...
    'Position',[50 50 800 600], ...
    'Color', [0.8 0.8 0.8], ...
    'Name', 'Event code information', ...
    'NumberTitle','off', ...
    'PaperUnits','points', ...
    'ToolBar','none', 'MenuBar','none');

event_tab_lim = max([ceil((size(db.eventCodesInfo,2)+5)/10)]);
event_lim = 0.1/event_tab_lim;

event_panel1=uipanel('Parent',fig7,'Position',[0 0.1 1 0.7],'BackgroundColor', [0.8 0.8 0.8]);
event_panel2=uipanel('Parent',event_panel1,'Position',[0 (-event_tab_lim+1) 1 event_tab_lim],'BackgroundColor', [0.8 0.8 0.8]) ;
event_slider=uicontrol('Style','Slider','Parent',event_panel1,...
    'Units','normalized','Position',[0.98 0 0.02 1],...
    'Value',1,'Callback',{@slider_callback,event_panel2,event_tab_lim});


uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0 0.95 0.3 0.04], ...
    'Style', 'text', ...
    'Fontsize', 14, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Table of Event Code Information:');

% ---------- Event specification method:
uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.02 0.88 0.2 0.05], ...
    'Style', 'text', ...
    'HorizontalAlignment','left', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Event specification');

[tf]=ismember(db.eventSpecificationMethod,evspec_item);
if tf == 0
    if isempty(db.eventSpecificationMethod);
        db.eventSpecificationMethod={' '};
    end
    evspec_item=[evspec_item(1:evspec_item_length) db.eventSpecificationMethod];
end
evspec_event = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.175 0.88 0.1 0.05], ...
    'Style', 'popup', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String', evspec_item,...
    'Callback','db.eventSpecificationMethod=evspec_item{get(evspec_event,''Value'')};');
    [tf,loc]=ismember(db.eventSpecificationMethod,evspec_item);
    if loc ~= 0
    set(evspec_event,'Value',loc)
    end
    
% ---------- HED Version:
uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.405 0.88 0.2 0.05], ...
    'Style', 'text', ...
    'HorizontalAlignment','left', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'HED version');

hed_event = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.52 0.9 0.1 0.03], ...
    'Style', 'edit', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String', db.hedVersion,...
    'Callback','db.hedVersion=strtrim(get(hed_event,''String''));');

% ---------- Event code table:
uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.015 0.8 0.05 0.05], ...
    'Style', 'text', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Code');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.085 0.825 0.05 0.05], ...
    'Style', 'text', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Task label');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.17 0.825 0.05 0.05], ...
    'Style', 'text', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Event label');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.26 0.8 0.36 0.05], ...
    'Style', 'text', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Event code description');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.62 0.8 0.36 0.05], ...
    'Style', 'text', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Event code tag');

% Loop over event code informations
for e=1:size(db.eventCodesInfo,2)
    
code_event(e) = uicontrol(...
    'Parent', event_panel2, ...
    'Units','normalized', 'Position', [0 1-(e*event_lim) 0.07 event_lim], ...
    'Style', 'edit', ...
    'Fontsize', 12, ...
    'Foregroundcolor', [0 0 1], ...
    'String', db.eventCodesInfo(e).code,...
    'Callback','for a=1:e; db.eventCodesInfo(a).code=strtrim(get(code_event(a),''String'')); end');       

[tf]=ismember(db.eventCodesInfo(e).taskLabel,taskLabel_item);
if tf == 0
    if isempty(db.eventCodesInfo(e).taskLabel);
        db.eventCodesInfo(e).taskLabel={' '};
    end
    taskLabel_item=[taskLabel_item(1:taskLabel_item_length) db.eventCodesInfo(e).taskLabel];
end
taskLabel_event(e) = uicontrol(...
    'Parent', event_panel2, ...
    'Units','normalized', 'Position', [0.07 1-(e*event_lim) 0.07 event_lim], ...
    'Style', 'popup', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String',taskLabel_item,...
    'HorizontalAlignment','center',...
    'Callback','for a=1:e; db.eventCodesInfo(a).taskLabel=taskLabel_item{get(taskLabel_event(a),''Value'')}; end');
    [tf, loc]=ismember(db.eventCodesInfo(e).taskLabel,taskLabel_item);
    if loc ~= 0
    set(taskLabel_event(e),'Value',loc)
    end

label_event(e) = uicontrol(...
    'Parent', event_panel2, ...
    'Units','normalized', 'Position', [0.14 1-(e*event_lim) 0.12 event_lim], ...
    'Style', 'edit', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String', db.eventCodesInfo(e).condition.label,...
    'Max',[5],...
    'Min',[1],...
    'Callback','for a=1:e; db.eventCodesInfo(a).condition.label=strtrim(tex_cat(get(label_event(a),''String''))); end');        

description_event(e) = uicontrol(...
    'Parent', event_panel2, ...
    'Units','normalized', 'Position', [0.26 1-(e*event_lim) 0.36 event_lim], ...
    'Style', 'edit', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String', db.eventCodesInfo(e).condition.description,...
    'Max',[5],...
    'Min',[1],...
    'Callback','for a=1:e; db.eventCodesInfo(a).condition.description=strtrim(tex_cat(get(description_event(a),''String''))); end');

tag_event(e) = uicontrol(...
    'Parent', event_panel2, ...
    'Units','normalized', 'Position', [0.62 1-(e*event_lim) 0.36 event_lim], ...
    'Style', 'edit', ...
    'Fontsize', 10, ...
    'Foregroundcolor', [0 0 1], ...
    'String', db.eventCodesInfo(e).condition.tag,...
    'Max',[5],...
    'Min',[1],...
    'Callback','for a=1:e; db.eventCodesInfo(a).condition.tag=strtrim(tex_cat(get(tag_event(a),''String''))); end');


end

% read event codes from recording file
uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.005 0.03 0.25 0.04], ...
    'Style', 'push', ...
    'Fontsize', 12, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Read event codes from recording',...
    'Callback','read_events');

% Add an event
event_p = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.87 0.95 0.05 0.04], ...
    'Style', 'push', ...
    'Fontsize', 14, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', '+',...
    'Callback','event_plus');

% Delete an event
event_m = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.93 0.95 0.05 0.04], ...
    'Style', 'push', ...
    'Fontsize', 14, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', '-',...
    'Callback','event_minus');

% Next gui
event_next = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.93 0.03 0.05 0.04], ...
    'Style', 'push', ...
    'Fontsize', 14, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Next',...
    'Callback','session_gui');

% Save study description in .mat file
exp_save = uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.86 0.03 0.05 0.04], ...
    'Style', 'push', ...
    'Fontsize', 14, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'Save',...
    'Callback','save([db.projectInfo.projectPath ''\'' db.studyTitle ''.mat''],''db'');');  
    
%% Infobuttons
info_count=0;

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.03 0.8 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=1; eventinfo');  

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.1 0.8 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=2; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.185 0.8 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=3; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.43 0.8 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=4; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.79 0.8 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=5; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.155 0.905 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=6; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.5 0.905 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=7; eventinfo');

uicontrol(...
    'Parent', fig7, ...
    'Units','normalized', 'Position', [0.26 0.04 0.02 0.02], ...
    'Style', 'push', ...
    'Fontsize', 10, ...
    'Backgroundcolor', [0.8 0.8 0.8], ...
    'String', 'i',...
    'Callback','info_count=8; eventinfo');

% eof