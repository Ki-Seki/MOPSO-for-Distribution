% 绘制帕累托前沿图
function draw_pf(fit, pf, field, graph_option)
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素
    % pf 帕累托前沿解集，是一个逻辑索引，每个元素为布尔值，若为 1 表示对应粒子在帕累托前沿上
    % field 数据集
    % graph_option 绘图选项，定义在 main.m 中
    
    figure('Name','帕累托前沿','NumberTitle','off');
    
    scatter(fit(pf, 1), fit(pf, 2), 'r');  % 绘制前沿上的点
    xlabel('目标 1：T（小时）');
    ylabel('目标 2：Z（元）');
    title(['帕累托前沿图（数据集：', field.DATASET, '）']);
    
    % 为非支配解添加标签
    tmp = fit(pf, :);
    cnt = size(tmp, 1);
    for i = 1 : cnt
        label = ['(' num2str(tmp(i, 1)) ',' num2str(tmp(i, 2)) ') '];
        offset = 1;
        text(tmp(i, 1), tmp(i, 2)+offset, label);
    end
    
    if graph_option.detail == true
        hold on;
        scatter(fit(~pf, 1), fit(~pf, 2), 'r.');  % 绘制其他点
        hold off;
        legend('非支配解（时间，成本）', '被支配解');
    else
        legend('非支配解（时间，成本）');
    end
end