% 多目标适应度函数，计算粒子（群） p 的配送总时间和总成本
function [T, Z] = fitness(p, field)
    % p 粒子、多个例子构成的粒子群（此时一行代表一个粒子）
    % field 数据集
    % T 总时间；如果 p 是粒子群，那么 T 是一个列向量
    % Z 总成本；如果 p 是粒子群，那么 Z 是一个列向量

    % 以下是占位数据用于临时测试
    T = ones(size(p));
    Z = ones(size(p));
end