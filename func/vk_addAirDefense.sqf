// #define DEBUG_MODE_FULL
#include "\x\cba\addons\main\script_macros_common.hpp"

_getADList = {
	private ["_baseLoc","_n","_sortedList","_retList","_dist","_adDebugMarker"];
	_baseLoc = _this select 0;
	_n = _this select 1;
	_sortedList = [];
	_retList = [];
	_dist = 0;
	
	_sortedList = [adPositions,[_baseLoc],{_input0 distance getMarkerPos _x},"ASCEND",{(_input0 distance getMarkerPos _x < 2500)}] call BIS_fnc_sortBy;
	
	TRACE_1("",_sortedList);
	for "_i" from 0 to _n-1 do {
		_retList set [_i,_sortedList select _i];
	};
	TRACE_1("",_retList);
	_retList
};

PARAMS_1(_pos);
private ["_spawnLevel","_aaLevel","_level","_num","_adList","_adVeh"];

_spawnLevel = [] call vk_getSpawnLevel select 0;
_aaLevel = [] call vk_getSpawnLevel select 1;

_level = _spawnLevel+_aaLevel;
// _num = floor (random (_level)) max 1;
_num = 1 + _aaLevel;
TRACE_2("",_level,_num);

_adList = [_pos,_num] call _getADList;

if (count _adList > 0) then {
	{
		if !(_x in activeAD) then {
			PUSH(activeAD,_x);
			_adVeh = createVehicle ["O_APC_Tracked_02_AA_F",getMarkerPos _x, [], 0, "NONE"];
			_adVeh removeWeapon "missiles_titan";
			_adVeh setFuel 0;
			_adVeh allowCrewInImmobile true;
			_adVeh setVariable ["adName",_x];
			_adVeh setDir floor(random 360);
			_adVeh addEventHandler ["fired",{_this select 0 setVehicleAmmo 1}];
			_adVeh addEventHandler ["killed", {activeAD = activeAD - [(_this select 0) getVariable "adName"]; tin_fifo_bodies = tin_fifo_bodies + [(_this select 0)] + crew (_this select 0)}];
			createVehicleCrew _adVeh;
			
			_x setMarkerType "o_unknown";
		};
	} forEach _adList;
};