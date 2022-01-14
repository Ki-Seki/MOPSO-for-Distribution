% 多目标适应度函数，计算粒子群 p 的配送总时间和总成本
function fit = fitness(particle, field, matrix)
    % particle 粒子群，每行是一个粒子（允许只有一个粒子）
    % field 数据集
    % matrix 邻接矩阵
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素

    [m, n] = size(particle);  % 粒子个数 需求点个数
    fit = zeros(m, 2);  % 返回值
    
    for i = 1 : m  % 遍历每一个粒子
        
        p = particle(i, :);  % 当前粒子
        
        %% 求车辆使用情况
        
        k = 1;  % 车辆使用数量
        vehicle = [0];  % 车辆使用情况数组，每个元素代表一辆车，元素值是该车服务需求点数
        load = 0;  % 当前载重
        for j = 1 : n  % 遍历每一个需求点，其编号为 p(j)
            demand = field.DEMAND(p(j), 2);  % 需求点需求量
            if load + demand > field.VEHICLE_CAPACITY  % 若车载不足
                k = k + 1;  % 车数加一
                vehicle = [vehicle 0];  % 车数加一
                load = 0;  % 载重清空
            end
            vehicle(k) = vehicle(k) + 1;  % 第 k 辆车服务数量加一
            load = load + demand;  % 增加载重
        end
        
        %% 计算总运距和总消杀成本
        
        d = 0;  % 总运距
        r = 0;  % 总消杀次数
        st = 1;  % 某辆车起始服务点，p(st) 是服务点编号
        for j = 1 : k  % 遍历每一辆车
            ed = st + vehicle(j) - 1;  % 某辆车终止服务点，p(ed) 是服务点编号
            
            % 注意：下面常出现 p()，一般要令其 +1，是因为 matrix 是包括原点的
            
            d = d + matrix(1, p(st)+1);  % 加上原点到第一服务点距离
            r = r + field.RISK_MATRIX(1, p(st)+1);  % 加上原点到第一服务点的风险
            for l = st+1 : ed  % 遍历第 j 辆车服务的需求点
                d = d + matrix(p(l-1)+1, p(l)+1);
                r = r + field.RISK_MATRIX(p(l-1)+1, p(l)+1);
            end
            d = d + matrix(p(ed)+1, 1);  % 加上最后服务点到原点距离
            r = r + field.RISK_MATRIX(p(ed)+1, 1);  % 加上最后服务点到原点风险
            
            st = ed + 1;  % 更新 st
        end
        
        %% 计算当前粒子的总时间和总成本
        
        t = d / field.VEHICLE_VELOCITY;  % 小时
        z = d * field.VEHICLE_SHIPPING_COST + ...
            k * field.VEHICLE_FIXED_COST + ...
            r * field.VEHICLE_DISINFECTION_COST;  % 元
        
        %% 将当前粒子的总时间与总成本代入适应度矩阵
        
        fit(i, :) = [t, z];
    end
end