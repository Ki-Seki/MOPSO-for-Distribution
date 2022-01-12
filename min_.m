% 在适应度矩阵中找到最小的元素
function [value, index] = min_(fit, coeff_t, coeff_z)
    % fit 适应度矩阵，在 fitness.m 中定义
    % coeff_t 目标 T 的权重
    % coeff_z 目标 Z 的权重
    % value 最小值
    % index 最小值对应的下标
    
    % 优先级方案
    %{
    n = size(fit, 1);
    min_t = min(fit(:, 1));
    min_z = Inf;
    for i = 1 : n
        if fit(i, 1) == min_t && fit(i, 2) < min_z
            min_z = fit(i, 2);
            index = i;
        end
    end
    value = [min_t, min_z];
    %}
    
    % 加权方案
    final = coeff_t * fit(:, 1) + coeff_z * fit(:, 2);
    [value, index] = min(final);
end