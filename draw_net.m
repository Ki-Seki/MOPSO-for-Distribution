% 绘制结点网络图
function draw_net(field, graph_option)
    % field 数据集
    % graph_option 绘图选项，定义在 main.m 中
    
    node = field.NODE;
    
    %% 结点网络路径图
    
    figure('Name','结点网络路径图','NumberTitle','off')
    scatter(node(:,2), node(:,3), 'filled');
    
    % 添加标签
    for i = 1 : field.NODE_COUNT
        x = node(i, 2);  % 横坐标
        y = node(i, 3);  % 纵坐标
        label = [num2str(i-1) ' (' num2str(x) ',' num2str(y) ') '];  % 结点标签
        if i > 1  % 如果是需求点
            label = [label num2str(field.DEMAND(i-1,2))];  % 结点标签加上需求量
        end
        offset = 3;  % 防止标签被 marker 挡住
        text(x+offset, y+offset, label);  % 写标签
    end
    
    % 如果要求详细绘图，添加边
    if graph_option.detail == true
        hold on;
        for i = 1 : field.EDGE_COUNT
            n1 = field.EDGE(i, 1) + 1;  % 起始点编号
            n2 = field.EDGE(i, 2) + 1;  % 结束点编号
            x = [node(n1,2), node(n2,2)];
            y = [node(n1,3), node(n2,3)];
            plot(x, y, 'red');  % 连接两个点
        end
        hold off;
    end
    
    
    % 添加说明
    xlabel('横坐标（千米）');
    ylabel('纵坐标（千米）');
    title(['结点网络路径图（数据集：', field.DATASET, '）']);
    if graph_option.detail == true
        legend('结点（编号 坐标 需求量）' ,'边');
    else
        legend('结点（编号 坐标 需求量）');
    end
    
    %% 结点网络拓扑图
    
    g = graph(create_matrix(field.NODE, field.EDGE, 0));
    figure('Name','结点网络拓扑图','NumberTitle','off')
    plot(g, 'NodeLabel', 0:field.NODE_COUNT-1, 'EdgeLabel', g.Edges.Weight);
    title(['结点网络拓扑图（数据集：', field.DATASET, '）']);
    set(gca,'xtick',[],'xticklabel',[]);  % 隐藏坐标轴，因为无实际含义，下同
    set(gca,'ytick',[],'yticklabel',[]);
end