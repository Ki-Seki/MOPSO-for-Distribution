% 绘制 PSO 收敛过程图
function draw_convergence(f, conv, field)
    % f 历次迭代的全局最优的适应度值
    % conv 收敛时的迭代次数
    
    figure('Name','PSO 收敛过程图','NumberTitle','off')
    
    plot(f, '.b');
    hold on;
    p = plot(conv, f(conv), '*r');
    label = ['(' num2str(conv) ', ' num2str(f(conv)) ')'];  % 收敛点的标签
    
    title(['PSO 收敛过程图（数据集：', field.DATASET, '）']);
    xlabel('迭代次数');
    ylabel('加权适应度值');
    legend(p, ['收敛点' label]);
    hold off;
end