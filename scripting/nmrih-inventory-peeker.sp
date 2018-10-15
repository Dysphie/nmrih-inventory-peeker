#include <sourcemod>

public Plugin myinfo =
{
	name = "Inventory Peek",
	author = "Dysphie",
	description = "Get the players inventory contents and search them for specific items",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{
	//RegAdminCmd("sm_getinv", GetInv, ADMFLAG_GENERIC, "Lists the inventory contents for a player or everyone");
	RegAdminCmd("sm_whohas", WhoHas, ADMFLAG_GENERIC, "Searches players inventories for a specific item");
}
 
public Action WhoHas(int client, int args)
{
	if (args < 1)
	{
		PrintToConsole(client, "Usage: sm_whohas <item>");
		return Plugin_Handled;
	}

	int m_hMyWeapons = FindSendPropInfo("CNMRiH_Player", "m_hMyWeapons");	
	if(m_hMyWeapons < 0)
		return Plugin_Handled;

	if(client != 0)
	{
		PrintToChat(client, "Check console for output.");		
	}

	char search[32]; 
	GetCmdArg(1, search, sizeof(search));
	char buffer[128];
	int amount;

	for (int i=1; i<=MaxClients; i++)
	{
		if (!IsClientConnected(i) || !IsPlayerAlive(i))
			continue;

		int maxWeapons = GetEntPropArraySize(i, Prop_Data, "m_hMyWeapons");
		for (int j; j < maxWeapons; j++)
		{
			int item = GetEntPropEnt(i, Prop_Data, "m_hMyWeapons", j);
			if (!IsValidEntity(item))
				continue;

			GetEntityClassname(item, buffer, sizeof(buffer));
			if(StrContains(buffer, search) != -1)
			{
				PrintToConsole(client, "- %N (%s)", i, buffer);
				amount++;
			}
		}
	}
 
	if(amount <= 0)
	{
		PrintToConsole(client, "No one has that item.");
		return Plugin_Handled;
	}
	return Plugin_Handled;
}



