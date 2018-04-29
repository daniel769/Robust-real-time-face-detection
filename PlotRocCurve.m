function [] = PlotRocCurve()
%PLOTROCCURVE Summary of this function goes here
%   Detailed explanation goes here
load RocCurve;
plot(FARate,DetRate, 'rs--', 'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10);
title('Viola Jones, StepSize=1, SlideSize=19X19, scaleSize = 1.25');
xlabel('FA Rate');
ylabel('Detection Rate');
grid on;
grid minor;
figure;
plot(FA,DetRate, 'rs--', 'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10);
title('Viola Jones, StepSize=1, SlideSize=19X19, scaleSize = 1.25');
xlabel('FA');
ylabel('Detection Rate');
grid on;
grid minor;
end
