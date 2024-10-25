function [img, rsq, delay, lag, Period, sig] = Plotter(x, y, SaveDir, time_unit,  XTICK , XTickLabel, WrapTo2P)
    % x and y: vectors each with size of n*1 where n is the number of data points
    % SaveDir:  A text providing directory and name for output file
    % time_unit: a text providing tiem units of data provided in x and y. 
    % All time steps should have similar intervals (e.g., hourly, daily, weekly, monthly, yearly, ...). 
    % XTICK: a vector providing x values where ticks on map should be given
    % XTickLabel: A cell array providng the labels for the xticks
    % WrapTo2P: ['on', 'off']: default 'off'. If it is 'on', the it will
    % wrap angles in radians to [0 2*pi]. This is to prevent sharp jumps it is for illustration only. If you have no clue what it is doing, just leave it 'off'. 

    close all;
    ax1 = subplot(4,4, [6,7,10,11]);
    Time = (1:length(x))';
    d1 = [Time, x];
    d2 = [Time, y];
    
    d2(:,2)=boxpdf(d2(:,2));
    wtc_plotcustalex(d1, d2);

    if ~isempty(XTICK)
        set(gca,'XTick', XTICK);
    end
    set(gca,'TickDir','out'); % The only other option is 'in'
    set(gca, 'YTickLabel',{[]});
    set(gca, 'XTickLabel',{[]});

    colormap parula(10)
    %colormap spring;

    colorbar off;
    cb = colorbar();
    
    %manually change the position of colorbar to what you want 
    cb.Position = [0.93 0.320 0.0100 0.365] ;
    cb.Label.String = 'Coherence [R^2]';
    cb.FontAngle = 'normal';
    
    %manually change the position of the image by changing the position of the regular axes 
    set(gca, 'Position', [0.336, 0.320, 0.363, 0.365] );
    
    %sgtitle(seriesname, 'interpreter','latex');
    title('a) Coherence-delay map') ;
    
    %% Calculating yearly delay and coherence
    awxy = [];  % Delays angles
    awxy = angle(ans.Wxy);
    awxy =  flipud(awxy);  

    % Check if you want wrapTo2pi
    if WrapTo2P == "on"
        awxy = wrapTo2Pi(awxy);
    end
    
    rsq = [];  % Coherency R^2
    rsq = ans.RR;
    rsq=flipud(rsq);
    
    Period = []; % Periods
    Period = ans.period';
    Period=flipud(Period);
    
    sig = []; % Significancy of the R^2
    sig = ans.wtcsig;
    sig=rsq./sig; % un-do the presentation normalisation of wtc.m line 148
    
    delay = awxy./(2*pi()).*repmat(Period,1,size(awxy,2));  % Converting radiants to timsteps(weeks)
    
    lag = PhaseShift2Lag(Period, delay);
    
    %% ploting
    rsq_scale = mean(rsq,2);
    rsq_time = mean(rsq,1);
    
    ax2 = subplot(4,4,[2,3]);
    plot(Time, rsq_time, "Color","k", "LineWidth",2);
    xlim([0, length(Time)]);
    ylim([0,1])
    set(gca,'YTick', [0, 0.25, 0.5, 0.75, 1]);
    if ~isempty(XTICK)
        set(gca,'XTick', XTICK);
    end
    set(gca, 'XTickLabel',{[]});
  
    % Share the y-axis between subplot 1 and 2
    linkaxes([ax1, ax2], 'x')
    box off;
    ylabel('Coherence [R^2]');
    title('b) Scale-averaged Coherence')
    
    ax3 = subplot(4,4,[8,12]);
    plot(rsq_scale, log2(Period), "Color","k", "LineWidth",2);


    % Share the y-axis between subplot 1 and 2
    linkaxes([ax1, ax3], 'y')

    % to make it indentical to coherence-delay map
    Yticks = 2.^(fix(log2(min(ans.period))):fix(log2(max(ans.period))));

    set(gca,'YLim',log2([min(ans.period),max(ans.period)]), ...
    'YDir','reverse', 'layer','top', ...
    'YTick',log2(Yticks(:)), ...
    'YTickLabel',{[]}, ...
    'layer','top')


    %xlim([0,1]);
    %set(gca,'XTick', [0, 0.25, 0.5, 0.75, 1]);
    box off;
    xlabel('Coherence [R^2]');
    title('e) Time-averaged Coherence')
    
    
    delay_scale = mean(delay,2);
    delay_time = mean(delay,1);
    lag_scale = mean(lag,2);
    lag_time = mean(lag,1);
    
    
    ax4 = subplot(4,4,[14,15]);
    plot(Time, delay_time, "Color","k", "LineWidth",2);
    hold on;
    plot(Time, lag_time, "Color",[0.5, 0.5, 0.5], "LineWidth",2);
    plot([Time(1), Time(end)], [0,0], '--k', "LineWidth",0.5);
    
    legend('Phase shift', 'lag', 'Location','best');
    legend boxoff;
    
    xlim([0, length(Time)]);

    if ~isempty(XTICK)
        set(gca,'XTick', XTICK, ...
                'XTickLabel', XTickLabel);
    end
    
    % Share the y-axis between subplot 1 and 2
    linkaxes([ax1, ax2, ax4], 'x')
    box off;
    ylabel(strcat('Phase shift [', time_unit, ']'));
    title('c) Scale-averaged phase shift')
    
    ax5 = subplot(4,4,[5,9]);
    plot(delay_scale, log2(Period), "Color","k", "LineWidth",2);
    hold on;
    plot(lag_scale, log2(Period), "Color",[0.5, 0.5, 0.5], "LineWidth",2);

    plot([0, 0], [log2(Period(end)), log2(Period(1))], '--k', "LineWidth",0.5);
    
    % Share the y-axis between subplot 1 and 2
    linkaxes([ax1, ax5], 'y')

    % to make it indentical to coherence-delay map
    Yticks = 2.^(fix(log2(min(ans.period))):fix(log2(max(ans.period))));

    set(gca,'YLim',log2([min(ans.period),max(ans.period)]), ...
    'YDir','reverse', 'layer','top', ...
    'YTick',log2(Yticks(:)), ...
    'YTickLabel',num2str(Yticks'), ...
    'layer','top')
    box off;
    xlabel(strcat('Phase shift [', time_unit, ']'));
    ylabel(strcat('Period [', time_unit, ']'));
    title('d) Time-averaged phase shift')
    legend('Phase shift', 'lag', 'Location','northeast');
    legend boxoff;
    
    set(gcf, 'Position', [100 100 1400 700]);
    set(gcf,'color','w');
    set(findall(gcf,'-property','FontSize'),'FontSize',14)
    set(findall(gcf,'-property','FontName'),'FontName','sans-serif')
    img = getframe(gcf);
    saveas(gcf, SaveDir);
end