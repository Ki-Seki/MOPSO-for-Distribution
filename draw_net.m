% 绘制结点网络图
function draw_net(field)
    % field 数据集
    
    node = field.NODE;
    
    %% 绘制散点图
    
    scatter(node(:,2), node(:,3), 'filled');
    
    %% 添加标签
    
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
    
    %% 添加边
    
    hold on;
    for i = 1 : field.EDGE_COUNT
        n1 = field.EDGE(i, 1) + 1;  % 起始点编号
        n2 = field.EDGE(i, 2) + 1;  % 结束点编号
        x = [node(n1,2), node(n2,2)];
        y = [node(n1,3), node(n2,3)];
        plot(x, y, 'red');  % 连接两个点
    end
    hold off;
    
    %% 添加说明
    
    xlabel('横坐标（千米）');
    ylabel('纵坐标（千米）');
    title(['结点网络图（数据集：', field.DATASET, '）']);
    legend('结点（编号、坐标、需求量）' ,'边');
end