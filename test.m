clear;
clc;
close all;

%% 暴力搜索方法找到最优解

dataset = 'example';  % 数据集名称
coeff.t = 0.95;  % 目标 T 的权重
coeff.z = 0.05;  % 目标 Z 的权重
field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
all_particle = perms(1:6);  % 生成所有可能的解
fit = fitness(all_particle, field, matrix);  % 适应度是一个两列（T 和 Z）的矩阵
[~, index] = min(weighted(fit, coeff));  % 找群体最优值对应下标
disp(all_particle(index, :));  % 输出最好的粒子

%% 测试二

field = read_dataset(dataset);  % 读数据集到 field 结构体，它包含数据集中所有字段值
matrix = floyd_algo(field.NODE, field.EDGE);  % 用弗洛伊德算法求邻接矩阵
disp(fitness([1     3     2     5     6     4], field, matrix))
disp(fitness([1     2     3     5     6     4], field, matrix))
disp(fitness([3     4     2     5     6     1], field, matrix))
