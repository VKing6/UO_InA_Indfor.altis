	
	private ["_player","_textColor","_nearUnits","_index","_displayDistance"];
	disableSerialization;
	
	if (isNil "tin_nameTags") then {tin_nameTags = true};

	call compile preprocessFileLineNumbers "scripts\name_tag\functions.sqf";

	_textColor = [0.5 , 1, 0.5];
	_displayDistance = 20;

	[{
		if (tin_nameTags && alive player) then {
			_distance = (_this select 0) select 0;
			_color = (_this select 0) select 1;
			_player = player;		
			_nearUnits = [_player, _distance] call FNC_get_near_units;
			
			if (count _nearUnits > 0) then {
				1 cutRsc ["namehud","PLAIN"];
				_index = 0;
				{
					[_player, _x, _index, _color, _distance] call FNC_set_name_tag;
				} forEach _nearUnits;
			};
		};
	}, 0, [_displayDistance,_textColor]] call CBA_fnc_addPerFrameHandler;