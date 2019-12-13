function tspgui()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=128;                       % Number of individuals
MAXGEN=100;                     % Maximum no. of generations
NVAR=26;                        % No. of variables
ELITIST=0.05;                   % percentage of the elite population
STOP_PERCENTAGE=.90;            % percentage of equal fitness individuals for stopping
REPRESENTATION = "adjacency";   % Chosen representation (genome)
CROSSOVER = 'xalt_edges';       % default crossover operator
PR_CROSS=.20;                   % probability of crossover
MUTATION = 'inversion';         % default mutation operator
PR_MUT=.20;                     % probability of mutation
LOCALLOOP=false;                % local loop removal
DIVERSIFY=false;                % enforce diversity in the population
LOCAL_HEUR="off";               % local heursitic method
PARENT_SELECTION="ranking";     % parent selection
SURVIVOR_SELECTION="elitism";   % survivor selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the data sets
datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['datasets/' datasets{1}]);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

% initialise the user interface
fh = figure('Visible','off','Name','TSP Tool','Position',[0,0,1024,756]);
ah1 = axes('Parent',fh,'Position',[.1 .58 .5 .4]);
plot(x,y,'ko')

ah2 = axes('Parent',fh,'Position',[.1 .33 .5 .2]);
axes(ah2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');

ah3 = axes('Parent',fh,'Position',[.1 .08 .5 .2]);
axes(ah3);
xlabel('Distance');
ylabel('Number');

ph = uipanel('Parent',fh,'Title','Settings','Position',[.635 .2 .335 .68]);
row = 465;
uicontrol(ph,'Style','text','String','Dataset','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu','String',datasets,'Value',1,'Position',[130 row 150 20],'Callback',@datasetpopup_Callback);
ncitiessliderv = uicontrol(ph,'Style','text','String',NVAR,'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','Representation','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'adjacency', 'path'}, 'Value',1,'Position',[130 row 150 20],'Callback',@representation_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','# Individuals','Position',[0 row 130 20]);
nindslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',NIND,'Sliderstep',[0.001 0.05],'Position',[130 row 150 20],'Callback',@nindslider_Callback);
nindsliderv = uicontrol(ph,'Style','text','String',NIND,'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','# Generations','Position',[0 row 130 20]);
genslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',MAXGEN,'Sliderstep',[0.001 0.05],'Position',[130 row 150 20],'Callback',@genslider_Callback);
gensliderv = uicontrol(ph,'Style','text','String',MAXGEN,'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','Selection mechanism','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'ranking', 'scaling','tournament'}, 'Value',1,'Position',[130 row 150 20],'Callback',@parent_selection_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Crossover operator','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'AEX', 'HGreX'}, 'Value',1,'Position',[130 row 150 20],'Callback',@crossover_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Crossover probability','Position',[0 row 130 20]);
crossslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_CROSS*100),'Sliderstep',[0.01 0.05],'Position',[130 row 150 20],'Callback',@crossslider_Callback);
crosssliderv = uicontrol(ph,'Style','text','String',round(PR_CROSS*100),'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','Mutation operator','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'inversion', 'swap', 'scramble'}, 'Value',1,'Position',[130 row 150 20],'Callback',@mutation_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Mutation probability','Position',[0 row 130 20]);
mutslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_MUT*100),'Sliderstep',[0.01 0.05],'Position',[130 row 150 20],'Callback',@mutslider_Callback);
mutsliderv = uicontrol(ph,'Style','text','String',round(PR_MUT*100),'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','Local heuristic','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'off', '2-opt', 'inversion', 'both'}, 'Value',1,'Position',[130 row 150 20],'Callback',@heuristic_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Survivor selection','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu', 'String',{'elitism', 'round robin'}, 'Value',1,'Position',[130 row 150 20],'Callback',@survivor_selection_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Survivor percentage','Position',[0 row 130 20]);
elitslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(ELITIST*100),'Sliderstep',[0.01 0.05],'Position',[130 row 150 20],'Callback',@elitslider_Callback);
elitsliderv = uicontrol(ph,'Style','text','String',round(ELITIST*100),'Position',[280 row 50 20]);
row = new_row(row);
uicontrol(ph,'Style','text','String','Loop Detection','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu','String',{'off','on'},'Value',1,'Position',[130 row 50 20],'Callback',@llooppopup_Callback);
row = new_row(row);
uicontrol(ph,'Style','text','String','Enforce diversity','Position',[0 row 130 20]);
uicontrol(ph,'Style','popupmenu','String',{'off','on'},'Value',1,'Position',[130 row 50 20],'Callback',@diversity_Callback);
row = new_row(row);
row = new_row(row);
uicontrol(ph,'Style','pushbutton','String','START','Position',[20 row 300 30],'Callback',@runbutton_Callback);

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
    function diversity_Callback(hObject,~)
        lloop_value = get(hObject,'Value');
        if lloop_value==1
            DIVERSIFY = false;
        else
            DIVERSIFY = true;
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
    function representation_Callback(hObject,~)
        representation_value = get(hObject,'Value');
        representations = get(hObject,'String');
        REPRESENTATION = representations(representation_value);
        REPRESENTATION = REPRESENTATION{1};
    end
    function mutation_Callback(hObject,~)
        mutation_value = get(hObject,'Value');
        mutations = get(hObject,'String');
        value = mutations(mutation_value);
        switch value{1}
            case 'inversion'
                MUTATION = 'inversion';
            case 'swap'
                MUTATION = 'reciprocal_exchange';    
            case 'scramble'
                MUTATION = 'scramble';           
        end
    end
    function crossover_Callback(hObject,~)
        crossover_value = get(hObject,'Value');
        crossovers = get(hObject,'String');
        value = crossovers(crossover_value);
        switch value{1}
            case 'AEX'
                CROSSOVER = 'xalt_edges';
            case 'HGreX'
                CROSSOVER = 'heuristic_crossover';              
        end
    end
    function heuristic_Callback(hObject,~)
        heur_value = get(hObject,'Value');
        heuristics = get(hObject,'String');
        value = heuristics(heur_value);
        switch value{1}
            case '2-opt'
                LOCAL_HEUR = "2-opt";
            case 'inversion'
                LOCAL_HEUR = "inversion";     
            case 'both'
                LOCAL_HEUR = "both";   
            otherwise
                LOCAL_HEUR = "off";
        end
    end
    function parent_selection_Callback(hObject,~)
        parent_value = get(hObject,'Value');
        parent_selection = get(hObject,'String');
        value = parent_selection(parent_value);
        switch value{1}
            case 'tournament'
                PARENT_SELECTION = "tournament";
            case 'scaling'
                PARENT_SELECTION = "scaling";       
            otherwise
                LOCAL_HEUR = "ranking";
        end
    end
    function survivor_selection_Callback(hObject,~)
        survivor_value = get(hObject,'Value');
        survivor_selection = get(hObject,'String');
        value = survivor_selection(survivor_value);
        switch value{1}
            case 'round_robin'
                SURVIVOR_SELECTION = "round_robin";      
            otherwise
                SURVIVOR_SELECTION = "elitism";
        end
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
        data("representation") = REPRESENTATION;
        data("crossover") = CROSSOVER;
        data("pr_cross") = PR_CROSS;
        data("mutation") = MUTATION;
        data("pr_mut") = PR_MUT;
        data("loop_detect") = LOCALLOOP;
        data("diversify") = DIVERSIFY;
        data("local_heur") = LOCAL_HEUR;
        data("stop_perc") = STOP_PERCENTAGE;
        data("parent_selection")=PARENT_SELECTION;
        data("survivor_selection")=SURVIVOR_SELECTION;
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

function row=new_row(row)
    row = row - 30;
end