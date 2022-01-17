% 用弗洛伊德算法求邻接矩阵
% 此函数可继续优化性能，即可以仅计算上三角矩阵，但暂不优化，待性能不够时再优化
function matrix = floyd_algo(node, edge)
    % node 点集
    % edge 边集
    % matrix 邻接矩阵
    
    node_cnt = size(node, 1);
    edge_cnt = size(edge, 1);
    
    %%  初始化邻接矩阵
    
    % 创建一个由 Inf 值组成的 node_cnt×node_cnt 矩阵
    matrix = Inf(node_cnt);
    
    % 对角线清 0
    for i = 1 : node_cnt
        matrix(i, i) = 0;
    end
    
    % 有边直接相连的初始化
    for i = 1 : edge_cnt
        n1 = edge(i, 1) + 1;  % 起始节点的索引编号
        n2 = edge(i, 2) + 1;  % 结束节点的索引编号
        x1 = node(n1, 2);  % 起始节点的横坐标
        x2 = node(n2, 2);  % 结束节点的横坐标
        y1 = node(n1, 3);  % 起始节点的纵坐标
        y2 = node(n2, 3);  % 结束节点的纵坐标
        matrix(n1, n2) = sqrt(power(x1-x2,2) + power(y1-y2,2));
        matrix(n2, n1) = matrix(n1, n2);  % 对称操作
    end
    
    %% 弗洛伊德算法
    
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