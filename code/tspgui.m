function tspgui()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=50;                    % Number of individuals
MAXGEN=100;                 % Maximum no. of generations
NVAR=26;                    % No. of variables
ELITIST=0.05;               % percentage of the elite population
STOP_PERCENTAGE=.90;        % percentage of equal fitness individuals for stopping
REPR = "adjacency";         % Chosen representation (genome)
CROSSOVER = 'xalt_edges';   % default crossover operator
PR_CROSS=.20;               % probability of crossover
MUTATION = 'inversion';     % default mutation operator
PR_MUT=.20;                 % probability of mutation
LOCALLOOP=0;                % local loop removal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the data sets
datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['datasets/' datasets{1}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

% initialise the user interface
fh = figure('Visible','off','Name','TSP Tool','Position',[0,0,1024,768]);
ah1 = axes('Parent',fh,'Position',[.1 .55 .4 .4]);
plot(x,y,'ko')
ah2 = axes('Parent',fh,'Position',[.55 .55 .4 .4]);
axes(ah2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');
ah3 = axes('Parent',fh,'Position',[.1 .1 .4 .4]);
axes(ah3);
title('Histogram');
xlabel('Distance');
ylabel('Number');

ph = uipanel('Parent',fh,'Title','Settings','Position',[.55 .05 .45 .45]);
uicontrol(ph,'Style','text','String','Dataset','Position',[0 260 130 20]);
uicontrol(ph,'Style','popupmenu','String',datasets,'Value',1,'Position',[130 260 130 20],'Callback',@datasetpopup_Callback);
uicontrol(ph,'Style','text','String','Loop Detection','Position',[260 260 130 20]);
uicontrol(ph,'Style','popupmenu','String',{'off','on'},'Value',1,'Position',[390 260 50 20],'Callback',@llooppopup_Callback); 
uicontrol(ph,'Style','text','String','# Cities','Position',[0 230 130 20]);
ncitiessliderv = uicontrol(ph,'Style','text','String',NVAR,'Position',[280 230 50 20]);
uicontrol(ph,'Style','text','String','# Individuals','Position',[0 200 130 20]);
nindslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',NIND,'Sliderstep',[0.001 0.05],'Position',[130 200 150 20],'Callback',@nindslider_Callback);
nindsliderv = uicontrol(ph,'Style','text','String',NIND,'Position',[280 200 50 20]);
uicontrol(ph,'Style','text','String','# Generations','Position',[0 170 130 20]);
genslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',MAXGEN,'Sliderstep',[0.001 0.05],'Position',[130 170 150 20],'Callback',@genslider_Callback);
gensliderv = uicontrol(ph,'Style','text','String',MAXGEN,'Position',[280 170 50 20]);
uicontrol(ph,'Style','text','String','Pr. Mutation','Position',[0 140 130 20]);
mutslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_MUT*100),'Sliderstep',[0.01 0.05],'Position',[130 140 150 20],'Callback',@mutslider_Callback);
mutsliderv = uicontrol(ph,'Style','text','String',round(PR_MUT*100),'Position',[280 140 50 20]);
uicontrol(ph,'Style','text','String','Pr. Crossover','Position',[0 110 130 20]);
crossslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_CROSS*100),'Sliderstep',[0.01 0.05],'Position',[130 110 150 20],'Callback',@crossslider_Callback);
crosssliderv = uicontrol(ph,'Style','text','String',round(PR_CROSS*100),'Position',[280 110 50 20]);
uicontrol(ph,'Style','text','String','% elite','Position',[0 80 130 20]);
elitslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(ELITIST*100),'Sliderstep',[0.01 0.05],'Position',[130 80 150 20],'Callback',@elitslider_Callback);
elitsliderv = uicontrol(ph,'Style','text','String',round(ELITIST*100),'Position',[280 80 50 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'xalt_edges'}, 'Value',1,'Position',[10 50 130 20],'Callback',@crossover_Callback);
uicontrol(ph,'Style','pushbutton','String','START','Position',[0 10 50 30],'Callback',@runbutton_Callback);

set(fh,'Visible','on');
    function datasetpopup_Callback(hObject,~)
        dataset_value = get(hObject,'Value');
        dataset = datasets{dataset_value};
        % load the dataset
        data = load(['datasets/' dataset]);
        x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
        %x=data(:,1);y=data(:,2);
        NVAR=size(data,1); 
        set(ncitiessliderv,'String',size(data,1));
        axes(ah1);
        plot(x,y,'ko') 
    end
    function llooppopup_Callback(hObject,~)
        lloop_value = get(hObject,'Value');
        if lloop_value==1
            LOCALLOOP = 0;
        else
            LOCALLOOP = 1;
        end
    end
    function nindslider_Callback(hObject,~)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(nindsliderv,'String',slider_value);
        NIND = round(slider_value);
    end
    function genslider_Callback(hObject,~)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(gensliderv,'String',slider_value);
        MAXGEN = round(slider_value);
    end
    function mutslider_Callback(hObject,~)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(mutsliderv,'String',slider_value);
        PR_MUT = round(slider_value)/100;
    end
    function crossslider_Callback(hObject,~)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(crosssliderv,'String',slider_value);
        PR_CROSS = round(slider_value)/100;
    end
    function elitslider_Callback(hObject,~)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(elitsliderv,'String',slider_value);
        ELITIST = round(slider_value)/100;
    end
    function crossover_Callback(hObject,~)
        crossover_value = get(hObject,'Value');
        crossovers = get(hObject,'String');
        CROSSOVER = crossovers(crossover_value);
        CROSSOVER = CROSSOVER{1};
    end
    function runbutton_Callback(~,~)
        %set(ncitiesslider, 'Visible','off');
        set(nindslider,'Visible','off');
        set(genslider,'Visible','off');
        set(mutslider,'Visible','off');
        set(crossslider,'Visible','off');
        set(elitslider,'Visible','off');
        
        data = containers.Map;
        data("x") = x;
        data("y") = y;
        data("nind") = NIND;
        data("maxgen") = MAXGEN;
        data("elite") = ELITIST;
        data("repr") = REPR;
        data("crossover") = CROSSOVER;
        data("pr_cross") = PR_CROSS;
        data("mutation") = MUTATION;
        data("pr_mut") = PR_MUT;
        data("loop_detect") = LOCALLOOP;
        data("stop_perc") = STOP_PERCENTAGE;
        visual = containers.Map;
        visual("ah1") = ah1;
        visual("ah2") = ah2;
        visual("ah3") = ah3;
        data("visual") = visual;
        
        run_ga(data);
        end_run();
    end
    function end_run()
        %set(ncitiesslider,'Visible','on');
        set(nindslider,'Visible','on');
        set(genslider,'Visible','on');
        set(mutslider,'Visible','on');
        set(crossslider,'Visible','on');
        set(elitslider,'Visible','on');
    end
end
