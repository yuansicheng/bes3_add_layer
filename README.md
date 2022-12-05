# BESIII束流管外加物质对重建精度的影响

## 1. 研究背景
模拟在束流管和MDC内筒之间加入一定量的液氢或液氘对带电粒子pi, K, p的动量分辨和tracking效率有什么样的影响。该研究可以为测量一些反中子相关的参数提供理论基础。

## 2. 代码

### 2.1. boss框架相关代码
#### 2.1.1. 模拟
code/boss/workarea/Simulation/BOOST
- BesSim
    - BesPip.cc：模拟时增加一层物质。

#### 2.1.2. 重建
code/boss/workarea/Resconstruction
- KalFitAlg
    - KalFitReadGdml.cxx：KalFit时增加同样一层物质。

#### 2.1.3. 提取重建信息（新增包）
code/boss/workarea/ExtractRecInfo
- ExtractRecInfo
- 提取重建信息
    - mdc_track、kal_track的动量及各分量。

#### 2.1.4. 用于参数传递的svc（新增包）
code/boss/workarea/AddLayerSvc
- AddLayerSvc
- 在svc中定义需要使用的物质；
- 增加物质的厚度；
- 模拟粒子的种类。

### 2.2. 数据产生
code/boss/gen
- gen2root.py：对某一组参数，执行模拟+重建+信息提取，执行多组参数时对循环执行即可。

### 2.3. 分析
code/boss/analyse
- single_pp_fixed_enery_and_direction_func.py：提取root文件中的动量信息，对动量和theta分布进行高斯拟合，检查新增物质对重建中心值和精度的影响


