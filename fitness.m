% 多目标适应度函数，计算粒子群 p 的配送总时间和总成本
function fit = fitness(particle, field, matrix)
    % particle 粒子群，每行是一个粒子（允许只有一个粒子）
    % field 数据集
    % matrix 邻接矩阵
    % fit 适应度矩阵，每行表示一个粒子的适应度，包含 T 总时间和 Z 总成本两个元素

    [m, n] = size(particle);
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
        
        %% 计算总运距
        
        d = 0;  % 总运距
        st = 1;  % 某辆车起始服务点，p(st) 是服务点编号
        for j = 1 : k  % 遍历每一辆车
            
            % 注意：下面常出现 p()，一般要令其 +1，是因为 matrix 是包括原点的
            
            ed = st + vehicle(j) - 1;  % 某辆车终止服务点，p(ed) 是服务点编号
            d = d + matrix(1, p(st)+1);  %  加上原点到第一服务点距离
            for l = st+1 : ed
                d = d + matrix(p(l-1)+1, p(l)+1);
            end
            d = d + matrix(p(ed)+1, 1);  %  加上最后服务点到原点距离
            st = ed + 1;  % 更新 st
        end
        
        disp(d);
        
        %{
        d = 0;  % 总距离
        now_p = [0, p(i, :)];  % 补充配送原点为 0 到当前粒子，方便后续循环
        load = 0;  % 载重
        vehicle = 0;  % 车辆使用数量
        
        for j = 2 : n+1  % 遍历每一个需求点，其编号为 now_p(j)
            demand = field.DEMAND(now_p(j), 2);  % 需求点需求量
            if load + demand <= field.VEHICLE_CAPACITY  % 若车载重仍可以满足当前需求点
                if load == 0  % 若是当前车辆运送的第一个需求点
                    d = d + matrix(1, now_p(j));  % 添加原点到此车第一个服务点距离
                else
                    d = d + matrix(now_p(j-1), now_p(j));  % 添加上服务点到此服务点距离
                end
                
                load = load + demand;
            elseif load + demand > field.VEHICLE_CAPACITY  % 若需加车以服务此需求点
                d = d + matrix(now_p(j-1), 1);  % 换车前，总距离加上上辆车回原点的距离
                vehicle = vehicle + 1;  % 上量车计入车辆总数
                load = 0;  % 新车载重清零
                d = d + matrix(1, now_p(j));  % 添加原点到此车第一个服务点距离
            end
            
            if load > 0
                vehicle = vehicle + 1;
            end
        end
        
        t = d / field.VEHICLE_VELOCITY;  % 计算总运送时间
        z = z1 + z2 + z3;  % 计算总成本
        %}
    end
    
    
    % 以下是占位数据用于临时测试
    T = rand(size(p, 1), 1);
    Z = rand(size(p, 1), 1);
    fit = [T, Z];
end