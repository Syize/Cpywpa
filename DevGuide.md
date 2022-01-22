# DevGuide

## Use Cython extension or C

Dev Guide | [开发指南](DevGuide_CN.md)

File *c\_cpw\_core.c* uses wpa_supplicant **OFFCIAL C** interface and defines a set of functions to make it easier to interact with wpa_supplicant.

File *\_cpywpa\_core.pyx* defines a Cython extension class *cpw\_core*, it wraps C funtions in file *c\_cpw\_core.c*. 

Functions are listed below.

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

You can simple define another **Python** class inherits from *cpw\_core*. But do remember to call super in \_\_init\_\_. Then you can use all the functions defined in *cpw\_core*.

```python
from ccore import cpw_core

class YourOwnClass(cpw_core):
    def __init__(self):
        super(YourOwnClass, self).__init__()
```