% 用改进后的多目标粒子群优化（MOPSO）算法解决带有风险矩阵的多辆车配送旅行商问题（TSP）

% -*- coding: utf-8 -*-
% @Time: 
% @Author: Song Shichao
% @Email: song.shichao@outlook.com
% @Software: Matlab R2015b
% @Platform: Windows11 64x 21H2
% @CPU: Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz   2.11 GHz
% @RAM: 16.0 GB
% @Notice: This code is a part of a HUEL master degree project 
%          under the protection of GPL-3.0-only license.
% @Link: https://github.com/Ki-Seki/MATLAB/tree/master/006

% 算法特色
% 多目标粒子群优化（MOPSO）、风险矩阵、适应度矩阵、速度与位置的重编码、帕累托前沿

% 算法的输入与输出
% 输入：在“参设设置”节
% 输出：命令行输出结果、结点网络路径图、结点网络拓扑图、PSO 收敛过程图、每辆车的配送路径图

% 注意事项
% 结点从 0 开始编号，但是 MATLAB 是从 1 开始编号的
% TSP 背景下，适应度值即为路径长度、成本等，适应度值越小越好
% 邻接矩阵、风险矩阵的下标从配送原点（0 号结点）开始算起

% TODO
% pareto_front.m
% 该 [~, index] = min(weighted(fit, coeff));  % 找群体最优值对应下标
% 适应度排序：采用帕累托占优方法
% fitness 函数：性能优化，流程优化等
% draw_distribution 函数：流程性优化；规定参数控制一张图片放几辆车的图

clear;
clc;
close all;

%% 参数设置

rand_type = 'state';  % 随机数类型
rand_seed = 1;  % 随机数种子

dataset = 'c21';  % 数据集名称

loop_cnt = 100;  % 进化次数
particle_cnt = 30;  % 粒子数目
w = 1.5;  % 惯性权重
c1 = 4;  % 自我学习因子
c2 = 4;  % 群体学习因子

graph_option.detail = true;  % 是否在所有输出的图中显示详细信息
graph_option.distrib_cnt = 2;  % 一张图中绘制多少辆车的配送方案（合法值：1，2，4，6）

%% 初始化

rand(rand_type, rand_seed);  % 随机数生成器初始化
convergence = 0;  % 收敛时的迭代次数
field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
draw_net(field, graph_option);  % 绘制结点网络图

matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
particle = zeros(particle_cnt, field.NODE_COUNT-1);  % 创建粒子种群
for i = 1 : particle_cnt
    particle(i, :) = randperm(field.NODE_COUNT-1);  % 为每个粒子生成随机的路径序列
end
velocity = rands(particle_cnt, field.NODE_COUNT-1);  % 初始化粒子速度

fit = fitness(particle, field, matrix);  % 适应度是一个两列（T 和 Z）的矩阵
pf = pareto_front(fit);  % 得到当前帕累托前沿
[~, index] = min(weighted(fit, coeff));  % 找群体最优值对应下标
p_best = particle;  % 个体最优对应的粒子群
g_best = particle(index, :);  % 全局最优对应的粒子
p_best_fit = fit;  % 个体最优值
g_best_fit = fit(index, :);  % 全局最优值
best_history = zeros(1, loop_cnt);  % 历次迭代的全局最优的适应度值

%% 粒子群算法核心循环

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
    
    %% 保存结果
    
    best_history(i) = weighted(g_best_fit, coeff);
end

%% 输出

draw_convergence(best_history, convergence, field);  % 绘制收敛过程图

[fit, vehicle, dist, risk] = fitness(g_best, field, matrix);
draw_distribution(g_best, vehicle, field);  % 绘制最佳配送方案图

fprintf('对数据集 %s 的计算结果如下：\n', dataset)
fprintf('PSO 收敛于第 %d 次迭代\n', convergence);
fprintf('最优粒子为：%s\n', mat2str(g_best));
fprintf('共需 %d 辆车\n', size(vehicle{1}, 2));
fprintf('每辆车服务需求点个数：%s\n', mat2str(vehicle{1}));
fprintf('总运输距离：%.6f 千米\n', dist);
fprintf('消杀次数：%d 次\n', risk);
fprintf('总运输时长 T = %.6f 小时\n', fit(1));
fprintf('总成本 Z = %.6f 元\n', fit(2));