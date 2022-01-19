# Cpywpa

## Introduction

Cpywpa is another simple tool to control wpa_supplicant for Python. However, rather than using d-Bus, **it wrote with Cython so it can directly use OFFICIAL C interface.**

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

| package name | version |
| :----------: | :-----: |
|  setuptools  |  None   |
|    wheel     |  None   |
|    Cython    |  None   |

## How to use

⚠ NOTE ⚠

**While only root user can access wpa_supplicant interface, all codes below are running with sudo or by root user.**

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

3. Connect to a network

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
# connect to a known network
# Syize is my wifi name
manager.connect('Syize')
# connect to a new network
manager.connect('Syize', passwd='wifi-password')
```

4. Add a network but don't connect

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.addNetwork('Syize', 'wifi-password')
```

5. Delete a network

```python
from Cpywpa import NetworkManager

manager = NetworkManager()
manager.removeNetwork('Syize')
```



For more information, please head to [GitHub](https://github.com/Syize/Cpywpa)