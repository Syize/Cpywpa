# Cpywpa

## Introduction

Cpywpa is another simple tool to control wpa_supplicant for Python. However, rather than using d-Bus, **it wrote with Cython so it can directly use OFFICIAL C interface.**

English | [简体中文](README_CN.md)

## Installation

First, make sure you have the latest pip

```bash
python3 -m pip install --upgrade pip
```

Then you can install Cpywpa with this command

```bash
python3 -m pip install Cpywpa
```

Here is the dependent packages and they will be installed during installation.

> If you don't want to keep them, you can remove them after installation.

| package name | version |
| :----------: | :-----: |
|  setuptools  |   any   |
|    wheel     |   any   |
|    Cython    |   any   |

## How to use

⚠ NOTE ⚠

1. **While only root user can access wpa_supplicant interface, all codes below are running with sudo or by root user.**
2. all network configuration will be saved in /etc/wpa_supplicant/wpa_supplicant.conf, while the password is saved without encryption, it is not recommended to use this on your important computer.

And here is the guide.

1. Get current network status

```python
from Cpywpa import NetworkManager
from pprint import pprint

manager = NetworkManager()
pprint(manager.getStatus())
```

2. List known network
```python
from Cpywpa import NetworkManager
from pprint import pprint

manager = NetworkManager()
pprint(manager.listNetwork())
```
3. Scan network around and get scan results

```python
from Cpywpa import NetworkManager
from pprint import pprint
from time import sleep

manager = NetworkManager()
# you can use scan() to scan and get scan results
# use scan_time to set sleep time
pprint(manager.scan(scan_time=8))
# or use onlyScan() to scan and use scanResults() to get results
manager.onlyScan()
sleep(10)
pprint(manager.scanResults())
```

4. Connect to a network

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
# connect to a known network
# Syize is my wifi name
manager.connect('Syize')
# connect to a new network
# This new network must exist
manager.connect('Syize', passwd='wifi-password')
```

5. Add a network but don't connect

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.addNetwork('Syize', 'wifi-password')
```

6. Delete a network

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.removeNetwork('Syize')
```

## How to development

See [Dev Guide](DevelopmentGuide.md) | [开发指南](DevGuide_CN.md)

## Issues

- Chinese Wi-Fi name can show correctly in scan and scanResults, but add Wi-Fi with Chinese name **HASN'T BEEN TESTED YET.** Unexpected problems may occur.

## To-Do

- While wpa_supplicant is cross-plantform, different gcc's macro is required during installation. But till now only Linux version has been tested, and I only add Linux's macro to setup.py. It will be great if you help me completely complete this program.
- For now, Cpywpa only supportes several parameters including ssid, psk, priority and key_mgmt. I'm going to add other parameters support. However I merely use them. So it is diffcult to say when I will add.