% 绘制某个粒子代表的配送方案
function draw_distribution(p, v, field)
    % p 最优粒子
    % v 车辆配送方案，元胞数组
    % field 数据集
    
    v = v{1};  % 提取需要的部分
    g = graph(create_matrix(field.NODE, field.EDGE, 0));  % 创建图对象
    st = 1;  % 某辆车起始服务点，p(st) 是服务点编号
    for i = 1 : size(v, 2)  % 遍历每辆车
        ed = st + v(i) - 1;  % 某辆车终止服务点，p(ed) 是服务点编号
        
        %注意：下面常出现 p()，一般要令其 +1，是因为 matrix 是包括原点的
        
        %% 获得被该车辆服务的需求点的坐标，以便绘图
        
        servee = zeros(v(i), 2);
        for j = st : ed
            x = field.NODE(p(j) + 1, 2);
            y = field.NODE(p(j) + 1, 3);
            servee(j - st + 1, 1) = x;
            servee(j - st + 1, 2) = y;
        end
        
        %% 计算路径
        
        full_path = [shortestpath(g, 0+1, p(st)+1)];  % 加上原点到第一服务点路径
        for j = st+1 : ed  % 遍历每辆车服务的点
            path = shortestpath(g, p(j-1)+1, p(j)+1);
            full_path = [full_path path(2:end)];
        end
        path = shortestpath(g, p(ed)+1, 0+1);
        full_path = [full_path path(2:end)];
        path_size = size(full_path, 2);
        
        %% 字符串化路径方便展示
        
        % 注意：需要 -1，因为 Matlab 下标从 1 开始
        
        txt_path = num2str(full_path(1)-1);
        for j = 2 : path_size
            txt_path = [txt_path '→' num2str(full_path(j)-1)];
        end
        
        %%  绘图
        
        figure('Name',['第' num2str(i) '辆车配送路径'],'NumberTitle','off');
        
        % 绘制散点图
        scatter(field.NODE(:,2), field.NODE(:,3), 'b');
        hold on;
        scatter(servee(:, 1), servee(:, 2), 'filled', 'b');
        
        % 添加标签
        for j = 1 : field.NODE_COUNT
            x = field.NODE(j, 2);  % 横坐标
            y = field.NODE(j, 3);  % 纵坐标
            label = [num2str(j-1) ' (' num2str(x) ',' num2str(y) ') '];
            if j > 1  % 如果是需求点
                label = [label num2str(field.DEMAND(j-1,2))];
            end
            offset = 3;  % 防止标签被 marker 挡住
            text(x+offset, y+offset, label);  % 写标签
        end
        
        % 绘制路径
        X = zeros(path_size);
        Y = zeros(path_size);
        for j = 1 : path_size
            X(j) = field.NODE(full_path(j), 2);
            Y(j) = field.NODE(full_path(j), 3);
        end
        plot(X, Y, '-r');
        title(['第' num2str(i) '辆车配送路径（数据集：' field.DATASET '）']);
        xlabel('横坐标（千米）');
        ylabel('纵坐标（千米）');
        legend('途径点（编号、坐标、需求量）', '需求点（编号、坐标、需求量）', ['路径：' txt_path]);
        hold off;
        
        %% 更新 st
        
        st = ed + 1;  
    end
end