# Cpywpa

## 简介

Cpywpa 是用 Cython 编写的用来控制 wpa_supplicant 的工具，借助 Cython 的优势他直接通过 wpa_supplicant 的 **官方 C 接口** 与 wpa_supplicant 进行通讯

[English](REAEDME.md) | 简体中文

## 安装

首先确保你的 pip 是最新版本

```python
python3 -m pip install --upgrade pip
```

然后就可以通过 pip 进行安装了

```python
python3 -m pip install Cpywpa
```

下面是 Cpywpa 的依赖库，在安装过程中他们会被自动安装

> 如果你不想保留这些库 (因为他们只在安装过程中用到)，安装完成后即可将其删除

|     包     | 版本 |
| :--------: | :--: |
| setuptools | any  |
|   wheel    | any  |
|   Cython   | any  |

## 如何使用

⚠ 注意 ⚠

1. **由于只有 root 用户才能与 wpa_supplicant 通信，下面的代码都是通过 sudo 运行或由 root 用户运行**
2. 所有的网络配置都将保存在 /etc/wpa_supplicant/wpa_supplicant.conf 中，由于密码是铭文存储的，所以十分不建议在重要的计算机上使用此程序。

下面是使用指南。

1. 获取当前网络状态

```python
from Cpywpa import NetworkManager
from pprint import pprint

manager = NetworkManager()
pprint(manager.getStatus())
```

2. 列出已知的网络

```python
from Cpywpa import NetworkManager
from pprint import pprint

manager = NetworkManager()
pprint(manager.listNetwork())
```

3. 扫描周围的网络并返回结果

```python
from Cpywpa import NetworkManager
from pprint import pprint
from time import sleep

manager = NetworkManager()
# 你可以使用 scan() 来同时扫描和返回结果
# scan_time 控制了中间睡眠的时间
pprint(manager.scan(scan_time=8))
# 或者使用 onlyScan() 只进行扫描并调用 scanResults() 来获得结果
manager.onlyScan()
sleep(10)
pprint(manager.scanResults())
```

4. 连接到一个网络

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
# 连接到一个已知的网络
# Syize 是 wifi 名称
manager.connect('Syize')
# 连接到一个新的网络，这个网络必须是存在的
manager.connect('Syize', passwd='wifi-password')
```

5. 添加一个网络，但是不连接

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.addNetwork('Syize', 'wifi-password')
```

6. 删除一个保存的网络

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.removeNetwork('Syize')
```

## 已知的问题

- 在扫描结果中中文 Wi-Fi 名称可以被正确显示，**但是添加和连接具有中文名称的网络还没有被测试。**一些意外的问题有可能会发生。

## To-Do

- wpa_supplicant 是一个跨平台的程序，在编译过程中需要传入不同的编译环境宏来生成不同的用于对应平台的函数。由于设备限制的原因，目前我只在 Linux 平台进行了测试，因此 setup.py 中只添加了用于 Linux 平台的编译宏。如果你能帮助我完成这个程序，我将非常感谢。

