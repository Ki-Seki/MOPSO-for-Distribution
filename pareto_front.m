% 根据适应度矩阵，求出其帕累托前沿解集
% 此函数的算法依据：帕累托前沿一定是凸向坐标原点的曲线（曲面、超曲面）
function pf = pareto_front(fit)
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素
    % pf 帕累托前沿解集，是一个列向量，每个元素为布尔值，若为 1 表示对应粒子在帕累托前沿上
    
    %% 寻找两个端点
    
    [~, i1] = min(fit(:, 1));  % 找 T 最小的对应下标
    end1 = fit(i1, :);  % 将 T 最小对应的点作为第一个端点
    [~, i2] = min(fit(:, 2));  % 找 Z 最小的对应下标
    end2 = fit(i2, :);  % 将 Z 最小对应的点作为二个端点
    x1 = end1(1);
    y1 = end1(2);
    x2 = end2(1);
    y2 = end2(2);
    
    %% 筛选掉两端点连线上方（不包括线上）的点，因为他们不是凸向坐标原点的
    
    pf = fit(:, 2) <= (y2-y1) / (x2-x1) * (fit(:, 1)-x1) + y1;
    pf(i1) = 1;  % 避免由于浮点数精度问题使得比较大小时忽略掉端点，下同
    pf(i2) = 1;
    
    %% 找到两端点连线及下方解中的非支配解
    
    tmp = find(pf);
    cnt = size(tmp, 1);
    for i = 1 : cnt
        for j = 1 : cnt
            if i == j  % 跳过与自身的比较
                continue;
            end
            
            cmp = fit(tmp(j), :) <= fit(tmp(i), :);  % 1×2 的零一向量
            
            if sum(cmp) == 2  % 如果为 2，意味着第 tmp(j) 号粒子支配第 tmp(i) 号粒子
                pf(tmp(i)) = 0;
                break;
            end
        end
    end
    
    %% 用于测试的绘图
    
    scatter(fit(:, 1), fit(:, 2));
    hold on;
    plot([x1,x2], [y1, y2]);
    xlabel('目标 1：T');
    ylabel('目标 2：Z');
    tmp = find(pf);
    tmp = fit(tmp',:);
    scatter(tmp(:, 1), tmp(:, 2), 'g');
    hold off;
end