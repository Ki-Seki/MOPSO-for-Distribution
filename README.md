# 用优化粒子群算法解决带有风险矩阵的 TSP 问题

## 使用

1. 将数据集文件复制粘贴在本文件夹内
2. 修改 main.m 中“%% 参数设置”部分的参数
3. 运行 main.m 程序
4. 在命令行窗口查看输出，在图片窗口中查看输出的图表
5. 最后可在命令行窗口单独运行 draw_distribution_in_subplot 函数，以绘制所有车辆配送方案在同一版面的图

## example.txt 的说明

### example.txt 文件内容

```text
DATASET: example
NODE_COUNT: 7
NODE: 
0 345 184
1 21 99
2 200 190
3 150 200
4 177 37
5 76 211
6 75 64
EDGE_COUNT: 7
EDGE: 
0 2
0 4
1 2
1 5
2 3
3 6
5 6
VEHICLE_COUNT: 10
VEHICLE_CAPACITY: 450
VEHICLE_SHIPPING_COST: 0.5
VEHICLE_FIXED_COST: 100
VEHICLE_DISINFECTION_COST: 10
VEHICLE_VELOCITY: 80
DEMAND: 
1 345
2 134
3 200
4 365
5 220
6 44
RISK_MATRIX: 
1 0 0 1 1 0 0
1 1 0 1 1 0 0
1 1 1 1 1 0 0
0 0 0 1 1 0 0
0 0 0 0 1 0 0
1 1 1 1 1 1 0
1 1 1 1 1 1 1
EOF
```

### 如何计算风险矩阵？

这个案例中 7 个结点的风险程度分别是

结点编号  0  1  2  3  4  5  6
风险程度 48 59 67 40  0 89 91

降序排列后：

6 5 2 1 0 3 4

所以风险矩阵为：

1 0 0 1 1 0 0
1 1 0 1 1 0 0
1 1 1 1 1 0 0
0 0 0 1 1 0 0
0 0 0 0 1 0 0
1 1 1 1 1 1 0
1 1 1 1 1 1 1