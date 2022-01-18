#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "include/wpa_ctrl.h"
#include "include/includes.h"
#include "include/common.h"
#define ERROR 1
#define SUCCESS 0
#define REPLY_MESSAGE_LENGTH 3072

/*
 * 2021.11.29
 * It's 00:05 am now, and I'm writing these code.
 * There are many scripts in Github to control wpa_supplicant, including which is written in Python.
 * However it uses D-Bus, not offical API.
 * I think I could use Cython to make it usable with C and Python.
 * Oh my god I'm busy with my Master's Entrance Exam, and you guys see what I'm doing now.
 * All right it's time to sleep, good night.
 */

/*
 * receive command and send it to wpa_supplicant, return reply message
 */
int wpa_connect_get(char *cmd, char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	size_t temp = REPLY_MESSAGE_LENGTH;
	size_t *reply_len = &temp;

	int request_return = wpa_ctrl_request(
	    p_wpa_ctrl, cmd, strlen(cmd), reply_message, reply_len, NULL);
	if (!request_return)
		return SUCCESS;
	else
		return ERROR;
}

/*
 * :reply_message: char* to an array 1000 bytes long to store reply message from wpa_supplicant
 * :p_wpa_ctrl: pointer from wpa_ctrl_open
 */
int get_status(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("STATUS", reply_message, p_wpa_ctrl);
}

int list_networks(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("LIST_NETWORKS", reply_message, p_wpa_ctrl);
}

int scan_results(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("SCAN_RESULTS", reply_message, p_wpa_ctrl);
}

int scan(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("SCAN", reply_message, p_wpa_ctrl);
}

int disconnect(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("DISCONNECT", reply_message, p_wpa_ctrl);
}

/*
 * You should pass 'network_id' like this: SELECT_NETWORK <network_id>, network_id can be received from funtion list_network
 */
int select_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * You should pass 'network_id' like this: ENABLE_NETWORK <network_id>, network_id can be received from funtion list_network
 * Special network id 'all' can be used to enable all network
 */
int enable_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * You should pass 'network_id' like this: DISABLE_NETWORK <network_id>, network_id can be received from funtion list_network
 * Special network id 'all' can be used to disable all network
 */
int disable_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * You should pass 'network_id' like this: REMOVE_NETWORK <network_id>, network_id can be received from funtion list_network
 * Special network id 'all' can be used to remove all network
 */
int remove_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * Set network variables.
 * You should pass 'network_id' like this: SET_NETWORK <network_id> <variable> <value>.
 * Network id can be received from the LIST_NETWORKS command output.
 * This command uses the same variables and data formats as the configuration file.
 * See example wpa_supplicant.conf for more details.
 *
 * ssid (network name, SSID)
 * psk (WPA passphrase or pre-shared key)
 * key_mgmt (key management protocol)
 * identity (EAP identity)
 * password (EAP password)
 * ...
 */
int set_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * Get network variables. Network id can be received from the LIST_NETWORKS command output
 */
int get_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl, char *cmd)
{
	return wpa_connect_get(cmd, reply_message, p_wpa_ctrl);
}

/*
 * Add a new network. This command creates a new network with empty configuration.
 * The new network is disabled and once it has been configured it can be enabled with enable_network.
 * add_network returns the network id of the new network or FAIL on failure
 */
int add_network(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("ADD_NETWORK", reply_message, p_wpa_ctrl);
}

/*
 * Save the current configuration.
 */
int save_config(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("SAVE_CONFIG", reply_message, p_wpa_ctrl);
}

/*
 * Connect if disconnected (i.e., like reassociate, but only connect if in disconnected state)
 */
int reconnect(char *reply_message, struct wpa_ctrl *p_wpa_ctrl)
{
	return wpa_connect_get("RECONNECT", reply_message, p_wpa_ctrl);
}

/*
 * init connect
 */
struct wpa_ctrl *init()
{
	char *ctrl_path = "/var/run/wpa_supplicant/wlan0";
	struct wpa_ctrl *p_wpa_ctrl = wpa_ctrl_open(ctrl_path);
	struct wpa_ctrl *p_wpa_ctrl_unsolicited = wpa_ctrl_open(ctrl_path);
	return p_wpa_ctrl;
}

int main()
{
	// you need to pass the exactly file path to wpa_ctrl_open
	// char *ctrl_path = "/var/run/wpa_supplicant/wlan0";
	// in case of unsolicited message break requests/response
	// call twice refering to the guide
	struct wpa_ctrl *p_wpa_ctrl = init();
	// struct wpa_ctrl *p_wpa_ctrl_unsolicited = wpa_ctrl_open(ctrl_path);

	if (!p_wpa_ctrl)
	{
		printf("Could not get ctrl interface!\n");
		return -1;
	}
	// printf("test : %d\n", p_wpa_ctrl->s);

	// char *ping_cmd = "STATUS";
	char reply[REPLY_MESSAGE_LENGTH];
	// size_t temp = 1000;
	// size_t *reply_len = &temp;
	// int request_return;

	// request_return = wpa_ctrl_request(
	//     p_wpa_ctrl, ping_cmd, strlen(ping_cmd), reply, reply_len, NULL);
	// if (!request_return)
	// {
	// 	printf("reply message: \n%s\n", reply);
	// }

	if (get_status(reply, p_wpa_ctrl) == SUCCESS)
		printf("reply message: \n%s", reply);
	printf("\n");
	memset(reply, 0, sizeof(reply));

	if (list_networks(reply, p_wpa_ctrl) == SUCCESS)
		printf("reply message: \n%s", reply);
	printf("\n");
	memset(reply, 0, sizeof(reply));

	if (scan(reply, p_wpa_ctrl) == SUCCESS)
		printf("Scanning...\n");
	printf("sleep 10s\n");
	sleep(10);
	if (scan_results(reply, p_wpa_ctrl) == SUCCESS)
		printf("scan results: \n%s", reply);
	printf("Done\n");
	return 0;
}
