用优化粒子群算法解决带有风险矩阵的 TSP 问题

- [项目说明](#项目说明)
- [使用](#使用)
- [出现乱码？](#出现乱码)
  - [将文件编码转为系统默认编码](#将文件编码转为系统默认编码)
  - [将 MATLAB 配置文件修改为以 UTF-8 编码为准](#将-matlab-配置文件修改为以-utf-8-编码为准)
- [数据集](#数据集)
- [example.txt 的说明](#exampletxt-的说明)
  - [example.txt 文件内容](#exampletxt-文件内容)
  - [如何计算风险矩阵？](#如何计算风险矩阵)
  - [关于邻接矩阵](#关于邻接矩阵)

## 项目说明

此代码是河南财经政法大学硕士项目的一部分，受 GPL-3.0-only 开源协议保护。GitHub 地址：https://github.com/Ki-Seki/MATLAB/tree/master/006

This code is a part of a HUEL master degree project under the protection of GPL-3.0-only license. GitHub Link: https://github.com/Ki-Seki/MATLAB/tree/master/006

## 使用

1. 将数据集文件复制粘贴在本文件夹内
2. 修改 main.m 中“%% 参数设置”部分的参数
3. 运行 main.m 程序
4. 在命令行窗口查看输出，在图片窗口中查看输出的图表
5. 最后可在命令行窗口单独运行 draw_distribution_in_subplot 函数，以绘制所有车辆配送方案在同一版面的图

## 出现乱码？

如果打开代码文件出现乱码，请阅读本小节

MATLAB 对文件的编码遵照系统默认编码格式（GB 2312），而非 UTF-8 这一广泛使用的编码格式。而本项目，包括本文件都是 UTF-8 编码的。为了解决这一冲突，提供如下两个解决方案（推荐第一种，因为比较简单）：

### 将文件编码转为系统默认编码

* 在文件管理器中打开文件夹 `006`，运行 `execute re-encoding.m` 文件
* 与 `006` 文件夹同级的文件夹 `encoded` 就包含重新编码后的文件
* 在 MATLAB 中打开 `encoded` 即可

### 将 MATLAB 配置文件修改为以 UTF-8 编码为准

编辑 matlab 的 locale 数据库文件 `lcdata.xml` (matlab bin 目录下).

删除

```xml
<encoding name="GBK">
    <encoding_alias name="936"/>
</encoding>
```

并将

```xml
<encoding name="UTF-8">
    <encoding_alias name="utf8"/>
</encoding>
```

改为

```xml
<encoding name="UTF-8">
    <encoding_alias name="utf8"/>
    <encoding_alias name="GBK"/>
</encoding>
```

重启 matlab 之后，即以 utf-8 编码.

> 方法作者：mozooo
> 
> 链接：https://www.zhihu.com/question/27933621/answer/249429313
> 
> 来源：知乎
> 
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 数据集

网上并无现成的数据集，需要自己制作数据集。本文件夹提供了三个数据集，其文件名分别为：`example.txt`, `b50.txt`, `c21.txt`。`example.txt` 是一个示例测试数据集，仅有 7 个结点。其他两个数据集后缀的数字均为其中结点数量。接下来的小节会详细介绍 `example.txt`

## example.txt 的说明

`example.txt` 是一个测试数据集。其中的数据均为随机生成的。其特点是数据量比较小，仅有 7 个结点，7 条边。这就方便了用 `example.txt` 进行测试。下面包含一些手算的结果，方便测试：

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

这个案例中假设 7 个结点的风险程度分别是

结点编号  0  1  2  3  4  5  6

风险程度 48 59 67 40  0 89 91

降序排列后：

6 5 2 1 0 3 4

所以风险矩阵为：

```text
1 0 0 1 1 0 0
1 1 0 1 1 0 0
1 1 1 1 1 0 0
0 0 0 1 1 0 0
0 0 0 0 1 0 0
1 1 1 1 1 1 0
1 1 1 1 1 1 1
```

### 关于邻接矩阵

原始的邻接矩阵为

```
0	Inf	145.1240848	Inf	223.2330621	Inf	Inf
Inf	0	200.8033864	Inf	Inf	124.7757989	Inf
145.1240848	200.8033864	0	50.99019514	Inf	Inf	Inf
Inf	Inf	50.99019514	0	Inf	Inf	155.3093687
223.2330621	Inf	Inf	Inf	0	Inf	Inf
Inf	124.7757989	Inf	Inf	Inf	0	147.0034013
Inf	Inf	Inf	155.3093687	Inf	147.0034013	0
```

经过弗洛伊德算法计算后的邻接矩阵

```text
0	345.9274713	145.1240848	196.11428	223.2330621	470.7032702	351.4236487
345.9274713	0	200.8033864	251.7935816	569.1605333	124.7757989	271.7792003
145.1240848	200.8033864	0	50.99019514	368.3571469	325.5791854	206.2995638
196.11428	251.7935816	50.99019514	0	419.347342	302.31277	155.3093687
223.2330621	569.1605333	368.3571469	419.347342	0	693.9363323	574.6567107
470.7032702	124.7757989	325.5791854	302.31277	693.9363323	0	147.0034013
351.4236487	271.7792003	206.2995638	155.3093687	574.6567107	147.0034013	0
```