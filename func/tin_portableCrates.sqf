
	_crateList = [stuffBox_01,stuffBox_02,stuffBox_03,stuffBox_04];

	lynx_fnc_crateRefill = {
		private ["_fillCrate"];

		_fillCrate = _this;

		if (isServer) then {
			clearItemCargoGlobal _fillCrate;
			clearWeaponCargoGlobal _fillCrate;
			clearMagazineCargoGlobal _fillCrate;
			clearBackpackCargoGlobal _fillCrate;

			_weapons	= [["launch_NLAW_F",2],["TMR_launch_NLAW_MPV_F",2]];
			_magazines 	= [["30Rnd_556x45_Stanag",50],["30Rnd_556x45_Stanag_Tracer_Yellow",15],["20Rnd_762x51_Mag",15],["200Rnd_65x39_cased_Box",10],["tb_100Rnd_556x45_box",10],["150Rnd_762x51_Box",10],["30Rnd_45ACP_Mag_SMG_01",5],["tb_8Rnd_12ga_slug",5],["tb_8Rnd_12ga_buck",5],["30Rnd_9x21_Mag",5],["16Rnd_9x21_Mag",5],["9Rnd_45ACP_Mag",5],["1Rnd_HE_Grenade_shell",50],["1Rnd_Smoke_Grenade_shell",5],["1Rnd_SmokeRed_Grenade_shell",5],["1Rnd_SmokeGreen_Grenade_shell",5],["1Rnd_SmokeYellow_Grenade_shell",5],["1Rnd_SmokePurple_Grenade_shell",5],["1Rnd_SmokeBlue_Grenade_shell",5],["1Rnd_SmokeOrange_Grenade_shell",5],["Titan_AT",2],["tb_mk13_heat",5],["tb_mk13_hedp",5],["HandGrenade",15],["SmokeShell",5],["SmokeShellRed",5],["SmokeShellGreen",5],["SmokeShellYellow",5],["SmokeShellPurple",5],["SmokeShellBlue",5],["SmokeShellOrange",5],["Chemlight_green",5],["Chemlight_red",5],["Chemlight_yellow",5],["Chemlight_blue",5],["SatchelCharge_Remote_Mag",2],["DemoCharge_Remote_Mag",5],["Laserbatteries",2]];

			{_fillCrate addWeaponCargoGlobal _x} forEach _weapons;
			{_fillCrate addMagazineCargoGlobal _x} forEach _magazines;
		};
	};

	lynx_fnc_crateAddAction = {
		private ["_crate"];

		_crate = _this;

		refillCrate = _crate addAction ["Refill Crate", {["lynx_fnc_crateRefill",(_this select 0)] call CBA_fnc_globalEvent}, "", 0, true, true, "","_target distance hideLogic_2 < 500"];
	};

	["lynx_fnc_crateRefill", lynx_fnc_crateRefill] call CBA_fnc_addEventHandler;
	["lynx_fnc_crateAddAction", lynx_fnc_crateAddAction] call CBA_fnc_addEventHandler;
	//Raise event: ["lynx_fnc_crateRefill",stuffBox_01] call CBA_fnc_globalEvent;

	if (isServer) then {
		sleep 0.1;

		{
			if (time < 5) then {
				["lynx_fnc_crateAddAction",_x] call CBA_fnc_globalEvent
			};

			["lynx_fnc_crateRefill",_x] call CBA_fnc_globalEvent;
		} forEach _crateList;
	};
	
	if (!isDedicated && hasInterface && time >= 5) then {
		player removeAction refillCrate; 
		{
			["lynx_fnc_crateAddAction",_x] call CBA_fnc_localEvent;
		} forEach _crateList;
	};