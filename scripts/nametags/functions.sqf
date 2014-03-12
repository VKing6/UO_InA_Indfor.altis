lynx_sys_nameHUD_get_near_units = {
	private ["_displayDistance","_result","_nearUnits","_playerSide"];

	_displayDistance = _this select 0;
	_displayBase = _displayDistance / 10;
	_displayRange = 20;

	_sunState = sunOrMoon;

	if (_sunState <= 0.2) then {_displayDistance = 15};

	_nearUnits = nearestObjects [player,["CAManBase"],_displayDistance] - [player];
	_result = [];

	_playerSide = player getVariable ["lynx_unitSide", side player];

	{
		if ((vehicle _x) == _x) then {
			if (_sunState <= 0.2) then {
				if (currentVisionMode player > 0) then {
					_displayRange = _displayDistance;
				} else {
					_displayAdd		= 15 * moonIntensity;
					_displayRange = _displayBase + _displayAdd;
				};
			};

			if (_x getVariable ["lynx_unitSide", side _x] == _playerSide) then {
				_erf = terrainIntersect [eyePos player, eyePos _x];
				_obj = lineIntersects [eyePos player, eyePos _x, player];
				_dis = player distance _x;

				if (!_erf && !_obj && _dis <= _displayRange) then {
					_result set [(count _result), _x];
				};
			};
		};
	} forEach _nearUnits;

	_result
};

lynx_sys_nameHUD_set_name_tag = {
	private ["_unit","_dist","_color","_hud","_displayDistance"];

	// Set variable
	_unit = _this select 0;
	_index = _this select 1;
	_color = _this select 2;
	_displayDistance = _this select 3;
	_ui = uiNamespace getVariable "lynx_sys_nameHUD";

	// Set distance
	_dist = _unit distance (vehicle player);

	// If unit distance is close than 10m
	if (_dist < _displayDistance) then {
		// If unit is not get in vehicle
		if (vehicle _unit == _unit) then {
			// Set position name tag
			_pos = worldToScreen [getPosATL _unit select 0,getPosATL _unit select 1,(getPosATL _unit select 2)+(_unit selectionPosition "launcher" select 2)+0.65];

			if (count _pos>0) then {
				_hud = _ui displayCtrl (23501 + _index);

				_hud ctrlSetPosition [(_pos select 0)-0.2,_pos select 1];
				_hud ctrlSetText (if (!visibleMap) then {name _unit} else {""});
				_hud ctrlSetTextColor [(_color select 0),(_color select 1),(_color select 2),0.8 min (1.2 - _dist * (1 / _displayDistance))];
				_hud ctrlCommit 0;
				_index = _index + 1;
			};
		};
	};
};

lynx_sys_nameHUD_toggle_name_tag = {
	if (lynx_sys_nameHUD_enabled) then {lynx_sys_nameHUD_enabled = false} else {lynx_sys_nameHUD_enabled = true};
};