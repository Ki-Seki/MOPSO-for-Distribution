# 用改进后的多目标粒子群优化（MOPSO）算法解决带有风险矩阵的多辆车配送旅行商问题（TSP）

- [用改进后的多目标粒子群优化（MOPSO）算法解决带有风险矩阵的多辆车配送旅行商问题（TSP）](#用改进后的多目标粒子群优化mopso算法解决带有风险矩阵的多辆车配送旅行商问题tsp)
  - [项目说明](#项目说明)
  - [使用](#使用)
  - [出现乱码？](#出现乱码)
    - [将文件编码转为系统默认编码](#将文件编码转为系统默认编码)
    - [将 MATLAB 配置文件修改为以 UTF-8 编码为准](#将-matlab-配置文件修改为以-utf-8-编码为准)
  - [数据集](#数据集)
  - [算法](#算法)

## 项目说明

此代码是河南财经政法大学硕士项目的一部分，受 GPL-3.0-only 开源协议保护。GitHub 地址：https://github.com/Ki-Seki/MATLAB/tree/master/006

This code is a part of a HUEL master degree project under the protection of GPL-3.0-only license. GitHub Link: https://github.com/Ki-Seki/MATLAB/tree/master/006

## 使用

1. 将数据集文件复制粘贴在本文件夹内（有关数据集的内容在后面会详细介绍）
2. 修改 main.m 中“%% 参数设置”部分的参数
3. 运行 main.m 程序
4. 在命令行窗口查看输出，在图片窗口中查看输出的图表
5. 在命令行窗口输入要查看详细配送方案的粒子的编号，或输入 0 直接推出程序

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

网上并无现成的数据集，需要自己制作数据集。本文件夹提供了三个数据集，其文件名分别为：`example.txt`, `b50.txt`, `c21.txt`。其中，`example.txt` 是一个示例测试数据集，仅有 7 个结点，其他两个数据集后缀的数字均为其中结点数量。在 [`数据集说明.docx`](./说明/数据集说明.docx) 文档中以 `example.txt` 为例，详细地对数据集进行了说明。

## 算法

