clear;
clc;
close all;

%% 参数设置

dataset = 'example';  % 数据集名称

%% 读取数据及初始化

field = read_dataset(dataset);
disp(field);