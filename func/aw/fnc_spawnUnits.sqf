
private ["_randomPos","_spawnGroup","_pos","_x","_spawnLevel","_aaLevel","_aiSkill","_enemiesArray","_grpUnits"];
_pos = getMarkerPos (_this select 0);
_enemiesArray = [grpNull];
_aiSkill = [0.3,0.3,0.3];
if (PARAMS_AISkill == 1) then {_aiSkill = [0.3,0.4,0.3]};
if (PARAMS_AISkill == 2) then {_aiSkill = [0.3,0.7,0.3]};

_spawnLevel = [] call vk_getSpawnLevel select 0;
_aaLevel = [] call vk_getSpawnLevel select 1;

//spawn patrolling infantry squad
_x = 0;
for "_x" from 1 to _spawnLevel do {
	_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	[_spawnGroup, _pos, 50] call aw_fnc_spawn2_perimeterPatrol;

	{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 Patrol Squad",_spawnGroup];
};

//spawn units to garrison buildings: number of squads = spawn level (1 to 3) + 2, maximum of 5 squads.
_x = 0;
for "_x" from 0 to (_spawnLevel + 2) do {
	_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	[_spawnGroup, PARAMS_AOSize, _pos] call tin_aiGarrison;

	{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 Defenders",_spawnGroup];
};

//spawn patrolling infantry team: Number of teams = 2(SL+2) Maximum of 10 teams, minimum of 6
_x = 0;
for "_x" from 0 to ((_spawnLevel + 2) * 2) do {
	_randomPos = [[[getMarkerPos currentAO, 20],_dt],["water","out"]] call BIS_fnc_randomPos;
	_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	[_spawnGroup, getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_spawn2_randomPatrol;		

	{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 Patrol Team",_spawnGroup];
};
//spawning patrolling vehicles, 50% chance for either IFV or Tank to spawn instead of a motor inf team, maximum should be 3 of each.
_x = 0;
for "_x" from 0 to _spawnLevel do {
	_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

	if(random 1 > 0.50) then {
		_angryGroup = ["B_APC_Tracked_01_rcws_F","B_APC_Wheeled_01_cannon_F","B_MBT_01_cannon_F"];
		_spawnGroup	= (_angryGroup call BIS_fnc_selectRandom) createVehicle _randomPos;
		createVehicleCrew vehicle _spawnGroup;
	} else {
		_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized_MTP" >> "BUS_MotInf_Team"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	};

	[_spawnGroup, _pos, PARAMS_AOSize] call bis_fnc_taskPatrol;

	{
		_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}];
	} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 Motor",_spawnGroup];
};

//spawn armour, 30% chance for up to 6 tanks
_x = 0;
for "_x" from 0 to (floor(_spawnLevel/1.5)) do {

	_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

	if(random 1 > 0.70) then {
		_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >>"Armored" >> "BUS_TankSection"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	} else {
		_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >>"Mechanized" >> "BUS_MechInf_AT"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	};

	[_spawnGroup, _pos, PARAMS_AOSize] call bis_fnc_taskPatrol;

	{
		_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}];
	} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 Mech",_spawnGroup];
};

//Spawn Air threats 
_x = 0;
for "_x" from 0 to _aaLevel do {

	_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

	if(random 1 > 0.70) then {
		_spawnGroup	= "B_APC_Tracked_01_AA_F" createVehicle _randomPos;
		createVehicleCrew vehicle _spawnGroup;
	} else {
		_spawnGroup = [_randomPos, WEST,(configfile >> "CfgGroups" >> "West" >> "BLU_F" >>"Infantry" >> "BUS_InfTeam"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
	};

	[_spawnGroup, _pos, PARAMS_AOSize] call bis_fnc_taskPatrol;

	{
		_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}];
	} forEach (units _spawnGroup);

	_enemiesArray = _enemiesArray + [_spawnGroup];

	diag_log format["%1 AA",_spawnGroup];
};

diag_log _enemiesArray;

{
	_grpUnits = units _x;
	{
		if (vehicle _x != _x) then {
			[-2, {_this lock true}, vehicle _x] call CBA_fnc_globalExecute;
			(vehicle _x) allowCrewInImmobile true;
			diag_log format["Locking: %1",vehicle _x];
		};
	} forEach _grpUnits;
} forEach _enemiesArray;

_enemiesArray