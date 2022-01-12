% 用优化粒子群算法解决带有风险矩阵的 TSP 问题

% 算法特色
% 风险矩阵、偏移速度表示方法、多目标适应度函数

% 注意事项
% 结点从 0 开始编号，但是 MATLAB 是从 1 开始编号的
% 函数名后加一下划线表示重载的函数
% VRP 问题背景下，适应度值即为路径长度、成本等，适应度越小越好
% 适应度均用矩阵表示，以增强程序通用性

% 待完善 or 待优化
% 弗洛伊德算法：可继续优化
% 速度表示：暂时采用随机方法
% 适应度排序：暂时采用加权方法

% TODO
% fitness 函数

clear;
clc;
close all;

%% 参数设置

dataset = 'example';  % 数据集名称

loop_cnt = 100;  % 进化次数
particle_cnt = 100;  % 个体数目

w = 0.4;  % 惯性权重
c1 = 2;  % 学习因子，下同
c2 = 2;

coeff_t = 0.95;  % 目标 T 的权重
coeff_z = 0.05;  % 目标 Z 的权重

%% 初始化

field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
particle = zeros(particle_cnt, field.NODE_COUNT);  % 创建粒子种群

% 为每个粒子生成随机的路径序列
for i = 1 : particle_cnt
    particle(i, :) = randperm(field.NODE_COUNT);
end

fit = fitness(particle, field);  % 适应度是一个两列（T 和 Z）的矩阵
[~, index] = min_(fit, coeff_t, coeff_z);  % 使用重载函数找最优值
p_best = particle;  % 个体最优对应的粒子群
g_best = particle(index, :);  % 全局最优对应的粒子
p_best_fit = fit;  % 个体最优值
g_best_fit = fit(index, :);  % 全局最优值

%% 程序核心循环
for i = 1 : loop_cnt
    % TODO
end