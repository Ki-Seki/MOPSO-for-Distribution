% 在 TSP 问题背景下，使 PSO 中的速度与位置合法化，也就是使生成的解是有效解
function [v, x] = validate(v, x)
    % v 速度向量
    % x 位置向量
    
    n = size(x, 2);
    m = min(x);
    M = max(x);
    
    x_old = round(x - v);  % 复原原来位置，为避免浮点数计算影响，加上四舍五入运算
    x_new = (n-1) / (M-m) * (x-m) + 1;  % 坐标变换：[m, M] → [1, n]
    x_new = round(x_new);  % 变换为整数
    x_new = reorganize(x_new);  % 熨平粒子
    
    v = x_new - x_old;
    x = x_new;
end