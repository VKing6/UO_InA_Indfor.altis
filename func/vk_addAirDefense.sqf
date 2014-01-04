

_getADDist = {
	private ["_baseLoc","_n","_sortedList","_retList","_dist"];
	_baseLoc = _this select 0;
	_n = _this select 1;
	_sortedList = [];
	_retList = [];
	_dist = 0;
	{
		_dist = _baseLoc distance getMarkerPos _x;
		if (count _sortedList == 0) then {
			_sortedList = [_x];
		} else if (_dist > _sortedList select (count _sortedList)-1) then {
			_sortedList set [count _sortedList, _x];
		} else {
			for "_i" from 0 to (count _sortedList)-1 do {
				if (_dist < _sortedList select _i) then {
					exitWith {_sortedList set [_i,_x]};
				};
			};
		};
	} forEach adPositions;
	for "_i" from 0 to _n-1 do {
		_retList set [_i,_sortedList select _i];
	};
	_retList
};

_spawnLevel = [] call vk_getSpawnLevel select 0;
_aaLevel = [] call vk_getSpawnLevel select 1;