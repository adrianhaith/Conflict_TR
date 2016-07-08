function viewTrajs(data,varargin)
% inspect trajectories and data from RT experiment
%
% inputs: data - a data structure from an RT experiment (created by
%                loadTRsubjDATa
%         [minRT maxRT] - range of RTs to allow (default [0 0.5]);
%
maxRT = .7;
if(length(varargin)==0)
    maxRT = .7;
    igood = find(data.RT>0 & data.RT < 1);
else
    igood = find(data.RT>varargin{1}(1) & data.RT<varargin{1}(2));
    maxRT = varargin{1}(2);
end
[xxrt i_sort_rt] = sort(data.RT(igood));
rng = igood(i_sort_rt);
%igood = rng;%find(data.RT(rng)>0 & data.RT(rng) < .5);

figure(1); clf; hold on
subplot(3,2,3); hold on
plot(data.RT,data.reachDir_goal,'.','color',.9*ones(1,3),'markersize',20)
plot(data.RT(rng),data.reachDir_goal(rng),'.','color',.7*ones(1,3),'markersize',20)
xlabel('Reaction Time (s)')
ylabel('Reach Dir Relative to Goal (^o)')
axis([0 maxRT -180 180])

subplot(3,2,1); hold on
plot(data.RT,data.reachDir_absolute,'.','color',.9*ones(1,3),'markersize',20)
plot(data.RT(rng),data.reachDir_absolute(rng),'.','color',.7*ones(1,3),'markersize',20)
xlabel('Reaction Time (s)')
ylabel('Absolute Reach Direction (^o)')
axis([0 maxRT -180 180])

subplot(3,2,5); hold on
plot(data.RT,data.reachDir_symb,'.','color',.9*ones(1,3),'markersize',20)
plot(data.RT(rng),data.reachDir_symb(rng),'.','color',.7*ones(1,3),'markersize',20)
xlabel('Reaction Time (s)')
ylabel('Reach Dir Relative to Symbol Position (^o)')
axis([0 maxRT -180 180])

for i=1:length(rng)
    ii = rng(i);
    
    % plot reach direction error
    subplot(3,2,3); hold on
    if(i>1)
        plot(data.RT(rng(i-1)),data.reachDir_goal(rng(i-1)),'k.','markersize',20)
    end
    plot(data.RT(ii),data.reachDir_goal(ii),'r.','markersize',20)
    
    % plot absolute reach direction
    subplot(3,2,1); hold on
    if(i>1)
        plot(data.RT(rng(i-1)),data.reachDir_absolute(rng(i-1)),'k.','markersize',20)
    end
    plot(data.RT(ii),data.reachDir_absolute(ii),'r.','markersize',20)
    
    % plot absolute reach direction relative to symbol
    subplot(3,2,5); hold on
    if(i>1)
        plot(data.RT(rng(i-1)),data.reachDir_symb(rng(i-1)),'k.','markersize',20)
    end
    plot(data.RT(ii),data.reachDir_symb(ii),'r.','markersize',20)
    
    
    % plot velocity profile
    %{
    subplot(3,2,5); cla; hold on
    plot([1:length(data.tanVel{ii})]/130,data.tanVel{ii},'linewidth',2)
    plot(data.iInit(ii)/130,data.tanVel{ii}(data.iInit(ii)),'b.','linewidth',2,'markersize',20)
    xlabel('Time')
    ylabel('Velocity')
    %}
    % plot full trajectory
    subplot(3,2,[2 4 6]); cla; hold on
    handX = data.handPos{ii}(1,:);
    handY = data.handPos{ii}(2,:);
    %plot(data.handPos{ii}(1,data.iInit(ii):data.iEnd(ii)),data.handPos{ii}(2,data.iInit(ii):data.iEnd(ii)),'r')
    plot(handX(1,data.iInit(ii):data.iEnd(ii)),handY(1,data.iInit(ii):data.iEnd(ii)),'g','linewidth',2)
    %plot(data.targPos(ii,1),data.targPos(ii,2),'o','markersize',20)
    plot(.08*sin(data.goalAng(ii)*pi/180),.08*cos(data.goalAng(ii)*pi/180),'o','markersize',20)
    plot(.08*sin(data.symbAng(ii)*pi/180),.08*cos(data.symbAng(ii)*pi/180),'p','markersize',20)
    %plot(data.handPos{ii}(1,data.iDir(ii)),data.handPos{ii}(2,data.iDir(ii)),'r.','markersize',16)
    plot(handX(data.iDir(ii)),handY(data.iDir(ii)),'g.','markersize',20)
    dirV = .015*[-sin(data.reachDir_absolute(ii)*pi/180) cos(data.reachDir_absolute(ii)*pi/180)];
    plot(handX(data.iDir(ii))*[1 1] + [0 dirV(1)],handY(data.iDir(ii))*[1 1] + [0 dirV(2)],'k','linewidth',2.5)
    axis equal
    axis([-.08 .08 -.1 .1])

    text(-.06,.025,['Trial #: ',num2str(ii)]);    
    text(-.06,.02,['reachDir = ',num2str(data.reachDir_goal(ii))])
    text(-.06,.015,['reachDirAbsolute = ',num2str(data.reachDir_absolute(ii))])
    text(-.06,.01,['goalAng = ',num2str(data.goalAng(ii))])
    text(-.06,.005,['symbAng = ',num2str(data.symbAng(ii))])

    
    %keyboard
    pause
end
