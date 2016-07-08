% Analyze conflict data
subjname = 'Montrell';
condStr = {'Spatial','Symbolic','Conflict'};
addpath ExtraFns

data{1} = loadTRSubjData(subjname,{'Spat1'});
data{2} = loadTRSubjData(subjname,{'Symb1','Symb2'});
data{3} = loadTRSubjData(subjname,{'Conf1','Conf2'});

%% raw scatter plots
RTmax = .7;
figure(1); clf; hold on
for c=1:3
    subplot(2,3,c); hold on
    title(condStr{c})
    plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
    plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
    plot(data{c}.RT,data{c}.reachDir_goal,'.')
    axis([0 RTmax -180 180])
    xlabel('Reaction Time (s)')
    ylabel('Goal Error')
    
    subplot(2,3,3+c); hold on
    title(condStr{c})
    plot(data{c}.RT,data{c}.reachDir_symb,'.')
    plot([0 RTmax],[30 30],'color',.7*[1 1 1],'linewidth',2);
    plot([0 RTmax],[-30 -30],'color',.7*[1 1 1],'linewidth',2);
    axis([0 RTmax -180 180])
    axis([0 RTmax -180 180])
    xlabel('Reaction Time (s)')
    ylabel('Stimulus Error')
end

%% sliding window
RTplot = [0:.001:1];
w = .075; % sliding window width
TOL = 30; % hit tolerance +/-

for c = 1:3
    hit_goal = abs(data{c}.reachDir_goal)<TOL;
    hit_symb = abs(data{c}.reachDir_symb)<TOL;
    for i=1:length(RTplot)
        t = RTplot(i);
        igood = find(data{c}.RT>t-w/2 & data{c}.RT<t+w/2);
        phit_goal(c,i) = mean(hit_goal(igood));
        phit_symb(c,i) = mean(hit_symb(igood));
    end
end
phit_symb(2,:) = NaN; % set to NaNs since this is meaningless data
    
figure(2); clf; hold on
for c=1:3
    subplot(3,1,c); hold on
    title(condStr{c});
    plot(RTplot,phit_goal(c,:),'g','linewidth',3)
    plot(RTplot,phit_symb(c,:),'r','linewidth',2)
    plot([0 RTmax],.25*[1 1],'color',.7*[1 1 1],'linewidth',2)
    legend('p(move to correct goal)','p(move to symbol location')
    legend boxoff
    axis([0 RTmax -.05 1.05])
end