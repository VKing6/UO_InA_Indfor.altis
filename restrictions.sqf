/* by wildw1ng */
[] spawn
{
	while {true} do
	{
		if ((player hasWeapon "launch_I_Titan_F") || (player hasWeapon "launch_I_Titan_short_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_LAT_F") || (playerside == east && typeOf player != "O_soldier_LAT_F") || (playerside == resistance && typeOf player != "I_soldier_LAT_F")) then
			{
				player removeWeapon "launch_NLAW_F";
				player removeWeapon "launch_I_Titan_F";
				player removeWeapon "launch_I_Titan_short_F";
				player globalChat "Only AT Soldiers are trained in missile launcher operations. Launcher removed.";
			};
		};
		if ("B_UavTerminal" in (assignedItems player) || "I_UavTerminal" in (assignedItems player) || "O_UavTerminal" in (assignedItems player)) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_UAV_F") || (playerside == east && typeOf player != "O_soldier_UAV_F") || (playerside == resistance && typeOf player != "I_soldier_UAV_F")) then
			{
				player unassignItem "B_UavTerminal";
				player unassignItem "I_UavTerminal";
				player unassignItem "O_UavTerminal";
				player removeItem "B_UavTerminal";
				player removeItem "I_UavTerminal";
				player removeItem "O_UavTerminal";
				player globalChat "Only UAV Operators are trained in UAV operations. Terminal removed.";
			};
		};		
		if ((player hasWeapon "srifle_GM6_F") || (player hasWeapon "srifle_LRR_F") || (player hasWeapon "srifle_GM6_SOS_F") || (player hasWeapon "srifle_LRR_SOS_F")) then
		{
			if ((playerSide == west && typeOf player != "B_sniper_F") || (playerside == east && typeOf player != "O_sniper_F")) then
			{
				player removeWeapon "srifle_GM6_F";
				player removeWeapon "srifle_LRR_F";
				player removeWeapon "srifle_GM6_SOS_F";
				player removeWeapon "srifle_LRR_SOS_F";
				player globalChat "Only Snipers are trained with this caliber weapon. Sniper rifle removed.";
			};
		};
		sleep 1.0;
	} foreach allUnits;
};