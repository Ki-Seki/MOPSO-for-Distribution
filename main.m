% 用优化粒子群算法解决带有风险矩阵的 TSP 问题

% 运行环境
% 

% 算法特色
% 风险矩阵、偏移速度表示方法、多目标适应度函数

% 注意事项
% 结点从 0 开始编号，但是 MATLAB 是从 1 开始编号的
% 函数名后加一下划线表示重载的函数
% VRP 问题背景下，适应度值即为路径长度、成本等，适应度越小越好
% 适应度均用矩阵表示，以增强程序通用性
% 邻接矩阵的下标从配送原点开始算起
% min_.m 函数暂时未使用
% is_le.m 函数暂时未使用

% 程序约束
% 数据集中车载重必须大于单一需求点需求量，否则程序出现 BUG
% 需求点需求量必须是正数，否则程序出现 BUG
% 需求点至少有一个，否则程序出现 BUG

% 待完善 or 待优化
% 弗洛伊德算法：可继续优化
% 速度表示：暂时采用随机方法
% 适应度排序：暂时采用加权方法
% fitness 函数：性能优化，流程优化等

% TODO
% 绘制粒子的图，以直观的表现一个粒子

clear;
clc;
close all;

%% 参数设置

rand_type = 'state';  % 随机数类型
rand_seed = 1;  % 随机数种子

dataset = 'example';  % 数据集名称

loop_cnt = 60;  % 进化次数
particle_cnt = 3;  % 个体数目

w = 1.5;  % 惯性权重
c1 = 4;  % 自我学习因子
c2 = 4;  % 群体学习因子

coeff.t = 0.95;  % 目标 T 的权重
coeff.z = 0.05;  % 目标 Z 的权重

%% 初始化

rand(rand_type, rand_seed);  % 随机数生成器初始化
convergence = 0;  % 收敛时的迭代次数
field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
figure(1);
draw_net(field);  % 绘制结点网络图

matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
particle = zeros(particle_cnt, field.NODE_COUNT-1);  % 创建粒子种群
for i = 1 : particle_cnt
    particle(i, :) = randperm(field.NODE_COUNT-1);  % 为每个粒子生成随机的路径序列
end
velocity = rands(particle_cnt, field.NODE_COUNT-1);  % 初始化粒子速度

fit = fitness(particle, field, matrix);  % 适应度是一个两列（T 和 Z）的矩阵
[~, index] = min(weighted(fit, coeff));  % 找群体最优值对应下标
p_best = particle;  % 个体最优对应的粒子群
g_best = particle(index, :);  % 全局最优对应的粒子
p_best_fit = fit;  % 个体最优值
g_best_fit = fit(index, :);  % 全局最优值

%% 粒子群算法核心循环

figure(2);
for i = 1 : loop_cnt
    for j = 1 : particle_cnt
        %% 计算速度与位置
        
        v = velocity(j, :);  % 当前粒子速度
        x = particle(j, :);  % 当前粒子位置
        
        v = w * v + c1 * rand * (p_best(j, :)-x) + ...
            c2 * rand * (g_best-x);  % 速度更新公式
        x = x + v;  % 位置更新公式
        
        [velocity(j, :), particle(j, :)] = validate(v, x);  % 合法化速度与位置
        
        %% 更新个体最优
        
        tmp = fitness(particle(j, :), field, matrix);
        if weighted(tmp, coeff) <= weighted(p_best_fit(j, :), coeff)
            p_best(j, :) = particle(j, :);
            p_best_fit(j, :) = tmp;
        end
    end
    
    %% 更新群体最优
    [~, index] = min(weighted(p_best_fit, coeff));
    tmp = p_best_fit(index, :);
    if weighted(tmp, coeff) < weighted(g_best_fit, coeff)
        g_best = p_best(index, :);
        g_best_fit = tmp;
        convergence = i;  % 更新收敛时的迭代次数
    end
    
    %% 绘图
    
    disp(weighted(g_best_fit, coeff));
    disp(g_best);
    %disp(p_best(1, :));
    plot(i, weighted(g_best_fit, coeff), '.r');
    hold on;
end

%% 绘图

% 结束收敛过程的绘图
title(['PSO 收敛过程（数据集：', dataset, '）']);
xlabel('迭代次数');
ylabel('加权适应度值');
hold off;

% 绘制最优配送安排
% TODO

%% 输出最佳结果的相关数据
disp(convergence);