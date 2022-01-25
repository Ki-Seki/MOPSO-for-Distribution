% 测试程序以 example 数据集为例

%% 一些先行过程

clear;
clc;
close all;
dataset = 'test';  % 数据集名称
coeff.t = 0.95;  % 目标 T 的权重
coeff.z = 0.05;  % 目标 Z 的权重
field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵

%% 暴力搜索方法找到最优解

all_particle = perms(1:field.NODE_COUNT-1);  % 生成所有可能的解
fit = fitness(all_particle, field, matrix);  % 适应度是一个两列（T 和 Z）的矩阵
[~, index] = min(weighted(fit, coeff));  % 找群体最优值对应下标
disp(all_particle(index, :));  % 输出最好的粒子

%% 测试几个适应度相似的粒子

disp(fitness([1     3     2     5     6     4], field, matrix))
disp(fitness([1     2     3     5     6     4], field, matrix))
disp(fitness([3     4     2     5     6     1], field, matrix))

%% 测试需要五辆车时，图会不会正常地被画出来

p = [3,4,6,2,1,5];  % 这个粒子需要 5 辆车
[fit, vehicle, dist, risk] = fitness(p, field, matrix);
draw_distribution(p, vehicle, field);  % 绘制最佳配送方案
