
	if (isDedicated) exitWith {};
	if (isNil "lynx_sys_nameHUD_init") then {lynx_sys_nameHUD_init = true} else {if (lynx_sys_nameHUD_init) exitWith {diag_log format["Nametags already initialized for %1",player];}};

	private ["_displayDistance"];
	disableSerialization;

	if (isNil "lynx_sys_nameHUD_enabled") then {lynx_sys_nameHUD_enabled = true};

	call compile preprocessFileLineNumbers "scripts\nametags\functions.sqf";

	_displayDistance = 20;

	[{
		if (lynx_sys_nameHUD_enabled && alive player) then {
			_distance = (_this select 0) select 0;
			_nearUnits = [_distance] call lynx_sys_nameHUD_get_near_units;

			if (count _nearUnits > 0) then {
				1 cutRsc ["lynx_sys_nameHUD","PLAIN"];
				_index = 0;
				_teamColor = [1,1,1,1];
				{
					if (_x in units group player) then {
						if (_x == leader (group player)) then {
							_teamColor = [0.85, 0.4, 0, 1]
						} else {
							switch (assignedTeam _x) do {
								case "RED": 	{_teamColor = [1, 0, 0, 1]};
								case "GREEN": 	{_teamColor = [0, 1, 0, 1]};
								case "BLUE": 	{_teamColor = [0, 0, 1, 1]};
								case "YELLOW": 	{_teamColor = [0.85, 0.85, 0, 1]};
								default 		{_teamColor = [1,1,1,1]};
							};
						};
					} else {_teamColor = [0.8,0.8,0.8,1]};
					[_x, _index, _teamColor, _distance] call lynx_sys_nameHUD_set_name_tag;
				} forEach _nearUnits;
			};
		};
	}, 0, [_displayDistance]] call CBA_fnc_addPerFrameHandler;