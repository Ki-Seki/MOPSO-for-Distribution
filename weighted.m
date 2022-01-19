% 按照加权的方法，变适应度矩阵为适应度向量
function weighted_fit = weighted(fit, coeff)
    % fit 适应度矩阵
    % coeff 结构体，包含目标 T 和目标 Z 的权重
    % weighted_fit 适应度向量，也就是将矩阵中的 T 和 Z 综合成一个目标
    
    weighted_fit = coeff.t * fit(:, 1) + coeff.z * fit(:, 2);
end