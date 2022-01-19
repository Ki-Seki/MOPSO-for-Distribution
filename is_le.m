% 判断适应度 f1 是否小于等于 f2
function flag = is_le(f1, f2, coeff)
    % f1 第一个 1×2 的适应度矩阵
    % f2 第二个 1×2 的适应度矩阵
    % coeff 结构体，包含目标 T 和目标 Z 的权重
    % flag 如果小于等于，那么返回 true
    
    flag = (coeff.t * f1(1) + coeff.z * f1(2) <= ...
        coeff.t * f2(1) + coeff.z * f2(2));
end