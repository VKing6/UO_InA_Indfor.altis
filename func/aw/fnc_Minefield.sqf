// AW_fnc_minefield
// extracted and modified by Toadball
private ["_centralPos","_unitsArray","_mine","_unitsArray","_distance","_dir","_pos"];

_centralPos = _this select 0;
_unitsArray = [];

for "_x" from 0 to 79 do {
	_mine = createMine ["APERSBoundingMine", _centralPos, [], 50];
	_unitsArray = _unitsArray + [_mine];
};

_distance = 50;
_dir = 0;
for "_c" from 0 to 7 do {
	_pos = [_centralPos, _distance, _dir] call BIS_fnc_relPos;
	_sign = "Land_Sign_Mines_F" createVehicle _pos;
	waitUntil {alive _sign};
	_sign setDir _dir;
	_dir = _dir + 45;

	_unitsArray = _unitsArray + [_sign];
};

_unitsArray