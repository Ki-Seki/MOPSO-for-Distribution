% 根据结点集和边集创建邻接矩阵
function m = create_matrix(n, e, default)
    % n 结点集，三列（结点编号，横坐标，纵坐标）的矩阵
    % e 边集，两列（起点，终点）的矩阵
    % default 用 0 还是 Inf 来填充无边相连的点
    % m 邻接矩阵
    
    n_cnt = size(n, 1);
    e_cnt = size(e, 1);
    m = repmat(default, n_cnt);  % 初始化邻接矩阵
    
    % 对角线清 0
    for i = 1 : n_cnt
        m(i, i) = 0;
    end
    
    for i = 1 : e_cnt
        n1 = e(i, 1) + 1;  % 起始节点的索引编号
        n2 = e(i, 2) + 1;  % 结束节点的索引编号
        x1 = n(n1, 2);  % 起始节点的横坐标
        x2 = n(n2, 2);  % 结束节点的横坐标
        y1 = n(n1, 3);  % 起始节点的纵坐标
        y2 = n(n2, 3);  % 结束节点的纵坐标
        m(n1, n2) = sqrt(power(x1-x2,2) + power(y1-y2,2));
        m(n2, n1) = m(n1, n2);  % 对称操作
    end
end