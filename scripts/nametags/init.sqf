
	if (isDedicated) exitWith {};
	if (isNil "lynx_sys_nameHUD_init") then {lynx_sys_nameHUD_init = true} else {if (lynx_sys_nameHUD_init) exitWith {diag_log format["Nametags already initialized for %1",player];}};

	disableSerialization;

	if (isNil "lynx_sys_nameHUD_enabled") then {lynx_sys_nameHUD_enabled = true};
	if (isNil "lynx_sys_nameHUD_drawDistance") then {lynx_sys_nameHUD_drawDistance = 20};

	call compile preprocessFileLineNumbers "scripts\nametags\functions.sqf";

	[lynx_sys_nameHUD_drawDistance] spawn {
		while {lynx_sys_nameHUD_enabled} do {
			if (lynx_sys_nameHUD_enabled && alive player) then {
				_nearUnits = [lynx_sys_nameHUD_drawDistance] call lynx_sys_nameHUD_get_near_units;

				if (leader (group player) == player) then {
					{
						_unitTeam = _x getVariable ["lynx_sys_nameHUD_groupAssignment","MAIN"];
						if (_unitTeam != assignedTeam _x) then {
							_x setVariable ["lynx_sys_nameHUD_groupAssignment",assignedTeam _x,true];
						};
					} forEach units (group player);
				} else {
					{
						_unitTeam = _x getVariable ["lynx_sys_nameHUD_groupAssignment","MAIN"];
						if (_unitTeam != assignedTeam _x) then {
							_x assignTeam _unitTeam;
						};
					} forEach units (group player);
				};
			};

			sleep 5;
		};
	};

	[{
		if (lynx_sys_nameHUD_enabled && alive player) then {
			_nearUnits = [lynx_sys_nameHUD_drawDistance] call lynx_sys_nameHUD_get_near_units;

			if (count _nearUnits > 0) then {
				1 cutRsc ["lynx_sys_nameHUD","PLAIN"];
				_index = 0;
				_teamColor = [1,1,1,1];
				{
					if (_x in units group player) then {
						if (_x == leader (group player)) then {
							_teamColor = [0.85, 0.4, 0, 1]
						} else {
							_liveTeam = _x getVariable ["lynx_sys_nameHUD_groupAssignment","MAIN"];
							switch (_liveTeam) do {
								case "RED": 	{_teamColor = [1, 0, 0, 1]};
								case "GREEN": 	{_teamColor = [0, 1, 0, 1]};
								case "BLUE": 	{_teamColor = [0, 0, 1, 1]};
								case "YELLOW": 	{_teamColor = [0.85, 0.85, 0, 1]};
								default 		{_teamColor = [1,1,1,1]};
							};
						};
					} else {_teamColor = [0.8,0.8,0.8,1]};
					[_x, _index, _teamColor, lynx_sys_nameHUD_drawDistance] call lynx_sys_nameHUD_set_name_tag;
				} forEach _nearUnits;
			};
		};
	}, 0] call CBA_fnc_addPerFrameHandler;