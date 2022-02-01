% 将粒子中多余的和缺失的元素熨平，使其成为一个全排列
function x = reorganize(x)
    % x 是一个非法的粒子，其最大最小值确实为全排列里的最值，但中间的元素存在冗余和缺失
    % 返回值 x 是一个经过变换后合法的粒子
    
    %% 判定是否是全排列，如果是，直接返回即可
    % 判定定理：n 维全排列的求和与求积值是一定的，且不可能有 n 维非全排列和、积与其相同
    
    n = numel(x);
    if prod(x)==prod(1:n) && sum(x)==sum(1:n)
        return;
    end
    
    %% 找多余的和缺失的元素
    
    dup = [];  % 重复出现的元素所在位置
    miss = [];  % 缺少出现的元素的值
    for i = 1 : size(x, 2)
        occur = find(x == i);
        if size(occur, 2) == 0  % 若缺失
            miss = [miss i];
        elseif size(occur, 2) > 1  % 若冗余
            dup = [dup occur(2:end)];
        end
    end
    
    %% 将缺失的元素回填至冗余元素出现的位置
    
    for i = 1 : size(dup, 2)
        x(dup(i)) = miss(i);
    end
end