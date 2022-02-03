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
% 结点从 0 开始编号，但是 MATLAB 是从 1 开始编号的；
% TSP 背景下，适应度值即为路径长度、成本等，适应度值越小越好；
% 邻接矩阵、风险矩阵的下标从配送原点（0 号结点）开始算起；
% MOPSO 中群体最优 g_best 也是粒子群，学术上叫做 repository，
% 本例中输入的全排列是相当离散的数据，因此 repository 大小基本在 3 个左右，
% 其帕累托前沿图基本就是三个点组成的

% TODO
% draw_pf：前沿连成线
% fitness 函数：性能优化，流程优化等
% draw_distribution 函数：流程性优化；规定参数控制一张图片放几辆车的图
% UTF8 编码问题
% 帕累托前沿暂时按照随机化方法
% 权重建议值

clear;
clc;
close all;

%% 参数设置

rand_type = 'state';  % 随机数类型
rand_seed = 1;  % 随机数种子

dataset = 'c21';  % 数据集名称

loop_cnt = 150;  % 进化次数
particle_cnt = 200;  % 粒子数目
w = 1.5;  % 惯性权重（）
c1 = 4;  % 自我学习因子（两个学习因子建议相等，值在 1 到 5）
c2 = 4;  % 群体学习因子

graph_option.detail = false;  % 是否详细绘图（合法值：true，false）
graph_option.distrib_cnt = 2;  % 一张图中绘制多少辆车的配送方案（合法值：1，2，4，6）

%% 初始化

rand(rand_type, rand_seed);  % 随机数生成器初始化
field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
draw_net(field, graph_option);  % 绘制结点网络图

matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
particle = zeros(particle_cnt, field.NODE_COUNT-1);  % 创建粒子种群
for i = 1 : particle_cnt
    particle(i, :) = randperm(field.NODE_COUNT-1);  % 为每个粒子生成随机的路径序列
end
velocity = rands(particle_cnt, field.NODE_COUNT-1);  % 初始化粒子速度

fit = fitness(particle, field, matrix);  % 适应度是一个两列（T 和 Z）的矩阵
pf = pareto_front(fit);  % 得到当前帕累托前沿解集，是一个逻辑索引

p_best = particle;  % 个体最优对应的粒子群
g_best = particle(pf, :);  % 全局最优对应的粒子，pf 是逻辑索引
p_best_fit = fit;  % 个体最优值
g_best_fit = fit(pf, :);  % 全局最优值

best_history = zeros(loop_cnt, 2);  % 记录迭代：每行包括两目标每次在帕累托前沿中的平均值
convergence = 0;  % 结果收敛时的迭代次数

%% 粒子群算法核心循环

for i = 1 : loop_cnt
    for j = 1 : particle_cnt
        %% 计算速度与位置
        
        v = velocity(j, :);  % 当前粒子速度
        x = particle(j, :);  % 当前粒子位置
        
        v = w * v + c1 * rand * (p_best(j, :)-x) + c2 * rand * ...
            (g_best(randi(size(g_best, 1)), :)-x);  % 速度更新公式
        x = x + v;  % 位置更新公式
        
        [velocity(j, :), particle(j, :)] = validate(v, x);  % 速度与位置冲编码
        
        %% 更新个体最优
        
        tmp = fitness(particle(j, :), field, matrix);
        if sum(tmp < p_best_fit(j, :)) == 2  % 如果新解是占优的才更新
            p_best(j, :) = particle(j, :);
            p_best_fit(j, :) = tmp;
        end
    end
    
    %% 更新群体最优：策略是把新粒子全部加入后，再求一遍帕累托前沿
    g_best = [g_best; p_best];
    g_best_fit = [g_best_fit; p_best_fit];
    
    pf = pareto_front(g_best_fit);  % 帕累托前沿的逻辑索引
    if i == loop_cnt  % 仅绘制最后一次的帕累托前沿
        draw_pf(g_best_fit, pf, field, graph_option);  % 绘制帕累托前沿
    end
    g_best = g_best(pf, :);
    g_best_fit = g_best_fit(pf, :);
    
    %% 记录迭代
    
    avg_fit = mean(g_best_fit);
    best_history(i, :) = avg_fit;
    if i==1 || sum(best_history(i, :)<best_history(i-1, :))==2
        convergence = i;
    end
end

%% 输出

draw_convergence(best_history, convergence, field);  % 绘制收敛过程图

[fit, vehicle, dist, risk] = fitness(g_best, field, matrix);
cnt = size(g_best, 1);  % 帕累托前沿中解的个数

fprintf('对数据集 %s，MOPSO 收敛于第 %d 次迭代，产生含 %d 个非支配解的帕累托前沿解集：\n',...
    dataset, convergence,  cnt);

for i = 1 : cnt
    fprintf('\n【第 %d 个解的详情】\n', i);
    fprintf('粒子编码：%s\n', mat2str(g_best(i, :)));
    fprintf('共需 %d 辆车\n', size(vehicle{i}, 2));
    fprintf('每辆车服务需求点个数：%s\n', mat2str(vehicle{i}));
    fprintf('总运输距离：%.6f 千米\n', dist(i));
    fprintf('消杀次数：%d 次\n', risk(i));
    fprintf('总运输时长 T = %.6f 小时\n', fit(i, 1));
    fprintf('总成本 Z = %.6f 元\n', fit(i, 2));
end

% 绘制用户选定的某个粒子的配送方案
while 1
    No = input('\n请输入要绘制配送方案对应粒子的编号，输入 0 以直接退出：');
    if No == 0
        break;
    elseif ismember(No, 1 : cnt)
        draw_distribution(g_best(No, :), vehicle{No}, field);
        fprintf('绘制完毕\n');
        break;
    else
        No = input(['合法输入应从 ' mat2str(0:cnt), ' 中选择，请重新输入：']);
    end
end
