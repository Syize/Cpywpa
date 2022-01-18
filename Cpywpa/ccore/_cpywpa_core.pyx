from libc.stdlib cimport malloc, free
from libc.string cimport memset
ctypedef unsigned short int sa_family_t
DEF ERROR = 1
DEF SUCCESS = 0
DEF REPLY_MESSAGE_LENGHT = 3072

cdef extern from "include/wpa_ctrl.c":
    struct wpa_ctrl:
        pass

cdef extern from "include/os_unix.c":
    pass

cdef extern from "c_cpw_core.c":
    wpa_ctrl* init()
    int wpa_connect_get(char* cmd, char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int get_status(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int list_networks(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int scan_results(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int scan(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int disconnect(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int select_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int enable_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int disable_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int remove_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int set_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int get_network(char* reply_message, wpa_ctrl* p_wpa_ctrl, char* cmd)
    int add_network(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int save_config(char* reply_message, wpa_ctrl* p_wpa_ctrl)
    int reconnect(char* reply_message, wpa_ctrl* p_wpa_ctrl)


cdef class cpw_core():
    cdef:
        wpa_ctrl* p_wpa_ctrl
        char* reply_message
        int size_of_reply

    def __cinit__(self):
        self.p_wpa_ctrl = init()
        if not self.p_wpa_ctrl:
            print "Could not get control interface!\nCheck if you are root user"
            raise ValueError
        self.size_of_reply = REPLY_MESSAGE_LENGHT * sizeof(char)
        self.reply_message = <char*>malloc(self.size_of_reply)
        if self.reply_message == NULL:
            raise MemoryError

    cdef to_string(self):
        py_string = self.reply_message
        return py_string.decode('UTF-8')

    cdef clear_message(self):
        memset(self.reply_message, 0, self.size_of_reply)

    def _GetStatus(self):
        """
        Get network status that you've connected
        -----
        return:
            String: Message from wpa_supplicant
            1: ERROR
        """
        self.clear_message()
        if get_status(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _ListNetworks(self):
        """
        List configured networks
        -----
        return:
            String: Message from wpa_supplicant
            1: ERROR
        """
        self.clear_message()
        if list_networks(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _ScanResults(self):
        """
        Scan results
        -----
        return:
            String: Message from wpa_supplicant
            1: ERROR
        """
        self.clear_message()
        if scan_results(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _Scan(self):
        """
        Tell wpa_supplicant to scan networks. You should wait several seconds before call ScanResults
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        if scan(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _Disconnect(self):
        """
        Disconnect from current network
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        if disconnect(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _SelectNetwork(self, network_id):
        """
        Select a network (disable others). Network id can be received from the ListNetworks output
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'SELECT_NETWORK ' + network_id
        temp = temp.encode('UTF-8')
        if select_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _EnableNetwork(self, network_id):
        """
        Enable a network. Network id can be received from the ListNetworks output. 
        Special network id all can be used to enable all network.
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'ENABLE_NETWORK ' + network_id
        temp = temp.encode('UTF-8')
        if enable_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _DisableNetwork(self, network_id):
        """
        Disable a network. Network id can be received from the ListNetworks output.
        Special network id all can be used to disable all network.
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'DISABLE_NETWORK ' + network_id
        temp = temp.encode('UTF-8')
        if disable_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _RemoveNetwork(self, network_id):
        """
        Remove a network. Network id can be received from the ListNetworks output.
        Special network id all can be used to remove all network.
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'REMOVE_NETWORK ' + network_id
        temp = temp.encode('UTF-8')
        if remove_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _SetNetwork(self, network_id, variable, value):
        """
        Set network variables.
        This command uses the same variables and data formats as the configuration file. See example wpa_supplicant.conf for more details.
        - ssid (network name, SSID)
        - psk (WPA passphrase or pre-shared key)
        - key_mgmt (key management protocol)
        - identity (EAP identity)
        - password (EAP password)
        - ...
        !!! AND REMEBER !!!
        'ssid' and 'psk' should be placed between \" \". For example
        SetNetwork('0', 'ssid', '\"WIFI-NAME\"')
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'SET_NETWORK ' + network_id + ' ' + variable + ' ' + value
        temp = temp.encode('UTF-8')
        if set_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _GetNetwork(self, network_id, variable):
        """
        Get network variables.
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        temp = 'GET_NETWORK ' + network_id + ' ' + variable
        temp = temp.encode('UTF-8')
        if get_network(self.reply_message, self.p_wpa_ctrl, temp) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _AddNetwork(self):
        """
        Add a new network. This command creates a new network with EMPTY configuration.
        The new network is disabled and once it has been configured it can be enabled with EnableNetwork. 
        AddNetwork returns the network id of the new network or FAIL on failure.
        -----
        return:
            network id if success
            FAIL if fail
        """
        self.clear_message()
        if add_network(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return self.to_string()

    def _SaveConfig(self):
        """
        Save the current configuration.
        -----
        return:
            0: SUCCESS
            1: ERROR
        """
        self.clear_message()
        if save_config(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def _Reconnect(self):
        self.clear_message()
        if reconnect(self.reply_message, self.p_wpa_ctrl) == SUCCESS:
            return self.to_string()
        else:
            return ERROR

    def __dealloc__(self):
        if self.reply_message != NULL:
            free(self.reply_message)
