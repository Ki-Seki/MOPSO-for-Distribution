% 用弗洛伊德算法求邻接矩阵
% 此函数可继续优化性能，即可以仅计算上三角矩阵，但暂不优化，待性能不够时再优化
function matrix = floyd_algo(node, edge)
    % node 点集
    % edge 边集
    % matrix 邻接矩阵
    
    node_cnt = size(node, 1);
    matrix = create_matrix(node, edge, Inf);
    
    for k = 1 : node_cnt  % 遍历所有中介点
        for i = 1 : node_cnt
            for j = 1 : node_cnt
                if (matrix(i, k) ~= Inf && matrix(k, j) ~= Inf && ...
                        matrix(i, k) + matrix(k, j) < matrix(i, j))
                    matrix(i, j) = matrix(i, k) + matrix(k, j);  % 松弛操作
                end
            end
        end
    end
end