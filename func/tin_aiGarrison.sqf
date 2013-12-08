private ["_aiGroup","_aiRad","_aiPos","_aiUnits","_bldgArray","_validArray","_bldgIndex","_aiBuilding","_newIndex","_newPos","_bldgPosList","_aiOne","_aiTwo","_aiTre"];

_aiGroup 	= _this select 0;
_aiRad 	 	= _this select 1;
_aiPos 		= _this select 2;
_aiUnits 	= units _aiGroup;

_bldgArray 	= [];
_validArray = [];

///// Valid House Finder ///////////
{_bldgArray = _bldgArray + [_x]} forEach (nearestObjects [_aiPos, ["House"], _aiRad]);

{
	_i = 0;

	while {str(_x buildingPos _i) != "[0,0,0]"} do {
		_i = _i + 1;
	};

	if (_i > 3) then {_validArray = _validArray + [[_x,_i]]};
} forEach _bldgArray;
////////////////////////////////////

_aiGroup enableAttack false;
{doStop _x} forEach _aiUnits;

while {(count _aiUnits) >= 3} do {
	_bldgIndex = floor(random(count _validArray));
	_aiBuilding = _validArray select _bldgIndex;
	_validArray = [_validArray,_bldgIndex] call BIS_fnc_removeIndex;

	_bldgPosList = [];
	for "_e" from 0 to ((_aiBuilding select 1)-1) do {_bldgPosList = _bldgPosList + [(_aiBuilding select 0) buildingPos _e]};

	_aiOne = _aiUnits select 0;
	_newIndex = floor(random(count _bldgPosList));
	_newPos = _bldgPosList select _newIndex;
	_bldgPosList = [_bldgPosList,_newIndex] call BIS_fnc_removeIndex;
	_aiOne setPos _newPos;

	_aiTwo = _aiUnits select 1;
	_newIndex = floor(random(count _bldgPosList));
	_newPos = _bldgPosList select _newIndex;
	_bldgPosList = [_bldgPosList,_newIndex] call BIS_fnc_removeIndex;
	_aiTwo setPos _newPos;

	_aiTre = _aiUnits select 2;
	_newIndex = floor(random(count _bldgPosList));
	_newPos = _bldgPosList select _newIndex;
	_bldgPosList = [_bldgPosList,_newIndex] call BIS_fnc_removeIndex;
	_aiTre setPos _newPos;

	_aiUnits = _aiUnits - [_aiOne];
	_aiUnits = _aiUnits - [_aiTwo];
	_aiUnits = _aiUnits - [_aiTre];

	{
		_x doWatch ([getPosATL _x, 100, -([_x, getPosATL (_aiBuilding select 0)] call BIS_fnc_dirTo)] call BIS_fnc_relPos);
	} forEach [_aiOne,_aiTwo,_aiTre];
};

if ((count _aiUnits) mod 3 > 0) then {
	_bldgIndex = floor(random(count _validArray));
	_aiBuilding = _validArray select _bldgIndex;
	_validArray = [_validArray,_bldgIndex] call BIS_fnc_removeIndex;

	_bldgPosList = [];
	for "_e" from 0 to ((_aiBuilding select 1)-1) do {_bldgPosList = _bldgPosList + [(_aiBuilding select 0) buildingPos _e]};

	{
		_newIndex = floor(random(count _bldgPosList));
		_newPos = _bldgPosList select _newIndex;
		_bldgPosList = [_bldgPosList,_newIndex] call BIS_fnc_removeIndex;
		_x setPos _newPos;

		_x doWatch ([getPosATL _x, 100, -([_x, getPosATL (_aiBuilding select 0)] call BIS_fnc_dirTo)] call BIS_fnc_relPos);
	} forEach _aiUnits;
};