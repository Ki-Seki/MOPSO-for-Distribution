% 绘制 PSO 收敛过程图
function draw_convergence(f, conv, field)
    % f 记录迭代：每行包括两目标每次在帕累托前沿中的平均值
    % conv 两目标收敛时分别的迭代次数
    % field 数据集
    
    figure('Name','MOPSO 收敛过程','NumberTitle','off')
    suptitle(['MOPSO 两目标收敛过程图（数据集：', field.DATASET, '）']);
    
    %% 绘制 T 的收敛过程
    
    subplot(2, 1, 1);
    plot(f(:, 1), '- .r');
    hold on;
    pt = plot(conv.t, f(conv.t, 1), 'or');
    labelt = [' (' num2str(conv.t) ', ' num2str(f(conv.t, 1)) ')'];  % 收敛点的标签
    
    xlabel('迭代次数');
    ylabel('目标 1：T（小时）');
    legend(pt, ['收敛点' labelt]);
    hold off;
    
    %% 绘制 Z 的收敛过程
    
    subplot(2, 1, 2);
    plot(f(:, 2), '- .r');
    hold on;
    pz = plot(conv.z, f(conv.z, 2), 'or');
    labelz = [' (' num2str(conv.z) ', ' num2str(f(conv.z, 2)) ')'];  % 收敛点的标签
    
    xlabel('迭代次数');
    ylabel('目标 2：Z（元）');
    legend(pz, ['收敛点' labelz]);
    hold off;
end