% 绘制帕累托前沿图
function draw_pf(fit, pf, field, graph_option)
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素
    % pf 帕累托前沿解集，是一个逻辑索引，每个元素为布尔值，若为 1 表示对应粒子在帕累托前沿上
    % field 数据集
    % graph_option 绘图选项，定义在 main.m 中
    
    figure('Name','帕累托前沿','NumberTitle','off');
    
    %% 绘制非支配解散点图
    
    scatter(fit(pf, 1), fit(pf, 2), 'r');
    xlabel('目标 1：T（小时）');
    ylabel('目标 2：Z（元）');
    title(['帕累托前沿图（数据集：', field.DATASET, '）']);
    
    %% 为非支配解添加标签
    
    p = fit(pf, :);  % 获取非支配解解集
    cnt = size(p, 1);
    for i = 1 : cnt
        t = num2str(round(p(i, 1), 2));  % 保留两位小数，转换为字符串
        z = num2str(round(p(i, 2), 2));
        label = ['(' t ',' z ') '];
        offset = 1.005;  % 为了不让标签盖住坐标点，添加偏置
        text(p(i, 1)*offset, p(i, 2)*offset, label);
    end
    
    %% 绘制帕累托前沿曲线
    
    p = sortrows(p, 1);  % 按首列（时间）进行升序排序
    hold on, plot(p(:,1), p(:,2)), hold off;
    
    %% 选择性详细绘图
    
    if graph_option.detail == true
        hold on, scatter(fit(~pf, 1), fit(~pf, 2), 'r.'), hold off;  % 绘制被支配解
        legend('非支配解（时间，成本）', '帕累托前沿', '被支配解');
    else
        legend('非支配解（时间，成本）', '帕累托前沿');
    end
end