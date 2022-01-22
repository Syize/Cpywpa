# 开发指南

## 使用 Cython 的扩展类或者 C 函数

[Dev Guide](DevelopmentGuide.md) | 开发指南

文件 *c\_cpw\_core.c* 使用 wpa 官方的 C 接口通讯，其中定义了一系列函数帮助方便的与 wpa 进行通讯。

文件 *\_cpywpa\_core.pyx* 定义了一个 Cython 的扩展类 *cpw\_core*，对 *c\_cpw\_core.c* 中的 C 函数进行包装和调用。

具体的函数定义列在了下面。

~~懒得再转成汉语了~~

```c
// C funtions

// Return a pointer to wpa_ctrl struct, this pointer is used to communicate with wpa
struct wpa_ctrl* init()
// Receive command from user and send it to wpa. You can use functions below instead of this.
int wpa_connect_get(char* cmd, char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// All functions below return 1(ERROR) or 0(SUCCESS), message from wpa is stored in reply_message.
// reply_message is 3074 * sizeof(char) long.
// Get wpa status
int get_status(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// List saved network
int list_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// Get scan results
int scan_results(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// Tell wpa to scan
int scan(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// Disconnect from current network
int disconnect(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// Connct to a saved network, cmd here stores command
// Command should like this: SELECT_NETWORK <network_id>
// network_id can be received from funtion list_network()
// This function will enable the network you select and disable any other
int select_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// New network added to configuration or after using funtion select_network(), use this function to enable disabled network.
// Command should like this: ENABLE_NETWORK <network_id>
int enable_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Disable a network
// Command should like this: DISABLE_NETWORK <network_id>
int disable_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Remove a saved network
// Command should like this: REMOVE_NETWORK <network_id>
int remove_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Set network variables. More detailed about variables, please look at wpa_supplicant.conf
// Command should like this: SET_NETWORK <network_id> <variable> <value>
// IMPORTANT NOTE: ssid and psk should be wrapped by " ", for instance, I have a Wi-Fi called Syize and password is 123456, then the command is:
// SET_NETWORK 0 ssid "Syize" & SET_NETWORK 0 psk "123456"
int set_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Get network variables
int get_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Add a new network with empty configuration and return network_id. Use set_network() to set variables
int add_network(char* reply_message, struct wpa_ctrl* p_wpa_ctrl, char* cmd)
// Save wpa configuration to file
int save_config(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
// Reconnect is disconnected
int reconnect(char* reply_message, struct wpa_ctrl* p_wpa_ctrl)
```

```cython
# cpw_core funtions
# all funtions below except _AddNetwork() return message if success or 1 if error occurs
# transform C char* stored in reply_message to Python string and return it.
cdef to_string(self)
# fill reply_message with 0
cdef clear_message(self)
# Get network status
def _GetStatus(self)
# List saved network
def _ListNetworks(self)
# Get scan results
def _ScanResults(self)
# Tell wpa to scan
def _Scan(self)
# Disconnect
def _Disconnect(self)
# connect to a network
def _SelectNetwork(self, network_id)
# enable a network
def _EnableNetwork(self, network_id)
# disable a network
def _DisableNetwork(self, network_id)
# remove a network
def _RemoveNetwork(self, network_id)
# set network variable
def _SetNetwork(self, network_id, variable, value)
# get network variable
def _GetNetwork(self, network_id, variable)
# add a network
def _AddNetwork(self)
# save a network
def _SaveConfig(self)
# reconnect
def _Recconect(self)
```

你可以定义一个 Python 的类来继承 Cython 的扩展类 *cpw\_core*，并使用 super 函数来进行初始化。然后你就可以愉快的在使用 *cpw\_core* 中函数的同时用 Python 进行开发啦！

```python
from ccore import cpw_core

class YourOwnClass(cpw_core):
    def __init__(self):
        super(YourOwnClass, self).__init__()
```