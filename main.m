% 用优化粒子群算法解决带有风险矩阵的 TSP 问题

% 一些假定或简化
% 初代版本首先将多辆车问题转化为单辆车问题，在结果上用×或÷车数来表示以简化问题
% 速度表示方法先用最简单的随即方法来做，回头再做优化
% 弗洛伊德算法可继续优化

% 算法特色
% 风险矩阵、偏移速度表示方法、多目标适应度函数

% 注意事项
% 结点从 0 开始编号，但是 MATLAB 是从 1 开始编号的

% TODO
% 适应度函数是加权综合一个值好，还是双目标，如果是双目标，怎么双得好
% 适应度函数还没编写完成

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

%% 初始化

field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
particle = zeros(particle_cnt, field.NODE_COUNT);  % 创建粒子种群

% 为每个粒子生成随机的路径序列
for i = 1 : particle_cnt
    particle(i, :) = randperm(field.NODE_COUNT);
end

[pT, pZ] = fitness(particle, field);  % 计算适应度
pBest = particle;
% TODO

%% 程序核心循环
for i = 1 : loop_cnt
    % TODO
end