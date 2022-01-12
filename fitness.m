% 多目标适应度函数，计算粒子群 p 的配送总时间和总成本
function fit = fitness(p, field, matrix)
    % p 粒子群，每行是一个粒子（允许只有一个粒子）
    % field 数据集
    % matrix 邻接矩阵
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素

    [m, n] = size(p);
    for i = 1 : m  % 遍历每一个粒子
        t = 0;  % 总时间
        z = 0;  % 总成本
        now_p = [0, p(i, :)];  % 补充配送原点到当前粒子，方便后续循环
        load = 0;  % 载重
        vehicle = 0;  % 车辆使用数量
        for j = 2 : n+1  % 遍历每一个需求点
            demand = field.DEMAND(now_p(j), 2);
            if load + demand <= field.VEHICLE_CAPACITY
                load = load + demand;
            end
        end
    end
    
    
    % 以下是占位数据用于临时测试
    T = rand(size(p, 1), 1);
    Z = rand(size(p, 1), 1);
    fit = [T, Z];
end