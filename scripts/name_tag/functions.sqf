FNC_get_near_units = {
	private ["_player","_displayDistance","_result","_nearUnits","_playerSide"];

	_player = _this select 0;
	_displayDistance = _this select 1;
	_displayBase = _displayDistance / 10;
	_displayRange = 20;

	_sunState = sunOrMoon;
	
	if (_sunState <= 0.2) then {_displayDistance = 15};

	_nearUnits = nearestObjects [_player, ["CAManBase"], _displayDistance] - [_player];
	_result = [];

	_playerSide = _player getVariable "tin_unitSide";

	{
		if (isPlayer _x) then {
			if (_sunState <= 0.2) then {
				if (currentVisionMode player > 0) then {
					_displayRange = _displayDistance;
				} else {
					_displayAdd		= 5 * moonIntensity;
					_displayRange = _displayBase + _displayAdd;
				};
			};		
		
			if (_x getVariable "tin_unitSide" == _playerSide) then {
				_erf = terrainIntersect [eyePos _player, eyePos _x];
				_obj = lineIntersects [eyePos _player, eyePos _x, _player];
				_dis = _player distance _x;

				if (!_erf && !_obj && _dis <= _displayRange) then {
					_result set [(count _result), _x];
				};
			};
		};
	} forEach _nearUnits;

	_result
};

FNC_set_name_tag = {
	private ["_player","_unit","_dist","_textColor","_hud","_displayDistance"];

	// Set variable
	_player = _this select 0;
	_unit = _this select 1;
	_index = _this select 2;
	_textColor = _this select 3;
	_displayDistance = _this select 4;
	_ui=uiNamespace getVariable "namehud";

	// Set distance
	_dist=_unit distance vehicle _player;

	// If unit distance is close than 10m
	if (_dist < _displayDistance) then {
		// If unit is not get in vehicle
		if (vehicle _unit == _unit) then {
			// Set position name tag
			_pos=worldToScreen [getPosATL _unit select 0,getPosATL _unit select 1,(getPosATL _unit select 2)+(_unit selectionPosition "launcher" select 2)+0.65];

			if (count _pos>0) then {
				_hud=_ui displayCtrl (23501+_index);
				_hud ctrlSetPosition [(_pos select 0)-0.2,_pos select 1];
				_hud ctrlSetText (if (!visibleMap) then {name _unit} else {""});
				_hud ctrlSetTextColor [_textColor select 0, _textColor select 1, _textColor select 2 ,0.8 min (1.2 - _dist * (1 / _displayDistance))];
				_hud ctrlCommit 0;
				_index = _index + 1;
			};
		};
	};
};

FNC_toggle_name_tag = {
	if (tin_nameTags) then {tin_nameTags = false} else {tin_nameTags = true};
};