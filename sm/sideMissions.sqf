/*
	Insert public variable event handler into player init:

	"sideMarker" addPublicVariableEventHandler
	{
		"sideMarker" setMarkerPos (markerPos "sideMarker");
	};

	Also, we need an event handler for playing custom sounds via SAY.
	Pass the EH a variable that it can use to play the correct sound.

	For the addAction issue, we need to run the addAction command LOCALLY. Using forEach allUnits won't work as the action is still being run on the server.
	So, set up an EH that can add actions to units.

	For deletion of contact (and this applies to AO units, too!)...
		Using []spawn { }; will run code that then ignores the rest of the script!
		AWESOME!
*/
// #define DEBUG_MODE_FULL
#include "\x\cba\addons\main\script_macros_common.hpp"
//Create base array of differing side missions

private ["_firstRun","_mission","_isGroup","_obj","_skipTimer","_briefing","_flatPos","_randomPos","_spawnGroup","_unitsArray","_randomDir","_hangar","_sideMissions","_completeText","_spawnLevel","_aaLevel","_smPos","_smRadius","_fuzzyPos","_accepted","_unit","_hutPos","_validSM","_lastSM"];
_sideMissions =

[
	"destroyChopper",
	"destroySmallRadar",
	"destroyOutpost"
];

_mission = "";

_completeText =
"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";

//Set up some vars
_firstRun = true; //debug
_skipTimer = false;
_unitsArray = [sideObj];

switch (PARAMS_SMArea) do {
	case 0: {_smPos = island; _smRadius = 16000};
	case 1: {_smPos = southWest; _smRadius = 5000};
	default {_smPos = []};
};

while {true} do {
	if (_firstRun) then {
		//Debug if statement only...
		_firstRun = false;
		sleep 10;
		//Select random mission from the SM list
		_mission = _sideMissions call BIS_fnc_selectRandom;
		 _lastSM = "Nothing";
		_validSM = false;
	} else {
		if (!_skipTimer) then {

			switch (PARAMS_SmIntervalTime) do {
				case 0: {
					//Wait between 5-10 minutes before assigning a mission
					sleep (300 + (random 300));
				};
				case 1: {
					//Wait between 10-20 minutes before assigning a mission
					sleep (600 + (random 600));
				};
				case 2: {
					//Wait between 15-30 minutes before assigning a mission
					sleep (900 + (random 900));
				};
				case 3: {
					//Wait 1 before assigning a mission
					sleep (10);
				};
				default {sleep (900 + (random 900))};
			};

			//Delete old PT objects
			for "_c" from 0 to (count _unitsArray) do {
				_obj = _unitsArray select _c;
				if (isNil "_obj") then {_obj = objNull};
				_isGroup = false;
				if (_obj in allGroups) then { _isGroup = true; } else { _isGroup = false; };
				if (_isGroup) then {
					{
						if (!isNull _x) then {
							deleteVehicle _x;
						};
					} forEach (units _obj);
					deleteGroup _obj;
				} else {
					if (!isNull _obj) then {
						deleteVehicle _obj;
					};
				};
			};
		} else {
			//Reset skipTimer
			_skipTimer = false;
		};
	};
	while {!_validSM} do {
		//Select random mission from the SM list
		_mission = _sideMissions call BIS_fnc_selectRandom;
		if (_mission != _lastSM) then {_validSM = true;};
	};
	//reset the checker:
	_validSM = false;

	_spawnLevel = [] call vk_getSpawnLevel select 0;
	_aaLevel = [] call vk_getSpawnLevel select 1;

	//Grab the code for the selected mission
	switch (_mission) do {

		case "destroyChopper": {

			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Chopper</t><br/>____________________<br/>OPFOR forces have been provided with a new prototype attack chopper and they're keeping it in a hangar somewhere on the island.<br/><br/>We've marked the suspected location on your map; head to the hangar and destroy that chopper. Fly it into the sea if you have to, just get rid of it.</t>";

			_flatPos = [0,0,0];

			while {_flatPos select 2 < 3} do {
				_flatpos = [
					getPos _smPos,
					0,
					_smRadius,
					10,
					0,
					0.2,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
			};

			//Spawn hangar and chopper
			_randomDir = (random 360);
			_hangar = "Land_TentHangar_V1_F" createVehicle _flatPos;
			waitUntil {alive _hangar};
			_hangar setPos [(getPos _hangar select 0), (getPos _hangar select 1), ((getPos _hangar select 2) - 1)];
			sideObj = "O_Heli_Light_02_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			{_x setDir _randomDir} forEach [sideObj,_hangar];
			sideObj setVehicleLock "LOCKED";
			_unitsArray = [sideObj];

			//Spawn outbuildings
			for "_i" from 0 to floor(random 2) do {
				_hutPos = [
					_flatPos,
					sizeOf "Land_TentHangar_V1_F" + 5,
					sizeOf "Land_TentHangar_V1_F" + 20,
					sizeOf "Land_Cargo_House_V1_F",
					0,
					0.35,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
				_spawnGroup = "Land_Cargo_House_V1_F" createVehicle _hutPos;
				waitUntil {alive _spawnGroup};
				_spawnGroup setDir (random 360);
				_spawnGroup setVectorUp [0,0,1];
				_unitsArray = _unitsArray + [_spawnGroup];
			};

			//Spawn some enemies around the objective
			for "_i" from 0 to _spawnLevel do {
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn units to patrol the perimeter
			for "_i" from 0 to (_spawnLevel + 1) do {
				_randomPos = [[[getPos sideObj, 90]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 200] call aw_fnc_spawn2_perimeterPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn some enemies to patrol the area
			for "_i" from 0 to (_spawnLevel+1) do {
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			// Spawn mounted patrol
			if (_spawnLevel >= 2 || random 1 > 0.85) then {
				_randomPos = [[[getPos sideObj, 100]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			
			// Spawn area AAA
			[_flatpos] call vk_addAirDefense;

			_accepted = false;
			_fuzzyPos = _flatPos;
			while {!_accepted} do {
				LOG("Start Fuzzy Loop");
				_fuzzyPos =
				[
					((_flatPos select 0) - 500) + (random 1000),
					((_flatPos select 1) - 500) + (random 1000),
					0
				];
				if (!surfaceisWater _fuzzyPos) then {
					_accepted = true;
					LOG("Fuzzy Loop Accepted");
				};
			};

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Chopper";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Send new side mission hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
			showNotification = ["NewSideMission", "Destroy Enemy Chopper"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Chopper";
			publicVariable "sideMarkerText";

			//Wait until objective is destroyed
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Send completion hint
			[] call AW_fnc_rewardPlusHint;
			//define last mission completed:
			 _lastSM = "destroyChopper";
			//Hide SM marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

			//PROCESS REWARD HERE
		}; /* case "destroyChopper": */

		case "destroySmallRadar": {
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Radar</t><br/>____________________<br/>OPFOR forces have erected a small radar on the island as part of a project to keep friendly air support at bay.<br/><br/>We've marked the position on your map; head over there and take down that radar.</t>";

			_flatPos = [0,0,0];

			while {_flatPos select 2 < 3} do {
				_flatPos = [
					getPos _smPos,
					0,
					_smRadius,
					sizeOf "Land_Radar_small_F",
					0,
					0.7,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
			};

			//Spawn radar, set vector and add marker
			sideObj = "Land_Radar_small_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 2)];
			sideObj setVectorUp [0,0,1];
			_unitsArray = [sideObj];

			//Spawn outbuildings
			for "_i" from 0 to floor(random 2) do {
				_hutPos = [
					_flatPos,
					sizeOf "Land_Radar_small_F" + 5,
					sizeOf "Land_Radar_small_F" + 20,
					sizeOf "Land_Cargo_House_V1_F",
					0,
					0.35,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
				_spawnGroup = "Land_Cargo_House_V1_F" createVehicle _hutPos;
				waitUntil {alive _spawnGroup};
				_spawnGroup setDir (random 360);
				_spawnGroup setVectorUp [0,0,1];
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			//Spawn some enemies around the objective
			for "_i" from 0 to _spawnLevel do {
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn units to patrol the perimeter
			for "_i" from 0 to (_spawnLevel + 1) do {
				_randomPos = [[[getPos sideObj, 90]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 200] call aw_fnc_spawn2_perimeterPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn some enemies to patrol the objective area
			for "_i" from 0 to (_spawnLevel+1) do {
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			// Spawn mounted patrol
			if (_spawnLevel >= 2 || random 1 > 0.85) then {
				_randomPos = [[[getPos sideObj, 100]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			
			// Spawn area AAA
			[_flatpos] call vk_addAirDefense;

			_accepted = false;
			_fuzzyPos = _flatPos;
			while {!_accepted} do {
				LOG("Start Fuzzy Loop");
				_fuzzyPos =
				[
					((_flatPos select 0) - 500) + (random 1000),
					((_flatPos select 1) - 500) + (random 1000),
					0
				];
				if (!surfaceisWater _fuzzyPos) then {
					_accepted = true;
					LOG("Fuzzy Loop Accepted");
				};
			};

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Radar";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Throw out objective hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Enemy Radar"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Radar";
			publicVariable "sideMarkerText";

			waitUntil {sleep 0.5; !alive sideObj}; //wait until the objective is destroyed

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Throw out objective completion hint
			[] call AW_fnc_rewardPlusHint;
			 _lastSM = "destroySmallRadar";
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

			//provide players with reward. Place an MH-9 in the hangar, maybe?
		}; /* case "destroySmallRadar": */

		case "destroyOutpost": {

			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Outpost</t><br/>____________________<br/>The OPFOR have established a mobile coordinating HQ near grid %1<br/><br/>We've marked the building on your map; head over there and destroy it to hamper their command and control.</t>";

			_flatPos = [0,0,0];

			while {_flatPos select 2 < 3} do {
				_flatPos = [
					getPos _smPos,
					0,
					_smRadius,
					sizeOf "Land_Cargo_HQ_V1_F",
					0,
					0.35,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
			};

			//Spawn Mobile HQ
			_randomDir = (random 360);
			sideObj = "Land_Cargo_HQ_V1_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			[sideObj,0] call BIS_fnc_setHeight;
			sideObj setDir _randomDir;
			sideObj setVectorUp [0,0,1];

			_unitsArray = [sideObj];

			//Spawn outbuildings
			for "_i" from 0 to floor(random 4) do {
				_hutPos = [
					_flatPos,
					sizeOf "Land_Cargo_HQ_V1_F" + 5,
					sizeOf "Land_Cargo_HQ_V1_F" + 20,
					sizeOf "Land_Cargo_House_V1_F",
					0,
					0.35,
					0,
					[base,aoTrigger]
				] call bis_fnc_findSafePos;
				_spawnGroup = "Land_Cargo_House_V1_F" createVehicle _hutPos;
				waitUntil {alive _spawnGroup};
				_spawnGroup setDir (random 360);
				_spawnGroup setVectorUp [0,0,1];
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			//Spawn some AA yo!
			if (_aaLevel >= 1 || {random 1 > 0.75}) then {
				_spawnGroup = createGroup East;
				_unit = _spawnGroup createUnit ["O_soldier_AA_F",_flatPos,[],0,"NONE"];
				_unit setpos (sideObj buildingPos 4);
				_unit setDir (_randomDir + 90);
				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

				_spawnGroup = createGroup East;
				_unit = _spawnGroup createUnit ["O_soldier_AA_F",_flatPos,[],0,"NONE"];
				_unit setpos (sideObj buildingPos 6);
				_unit setDir (_randomDir - 90);
				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn units to patrol the objective area
			for "_i" from 0 to (_spawnLevel + 1) do {
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn units to patrol the perimeter
			for "_i" from 0 to (_spawnLevel + 1) do {
				_randomPos = [[[getPos sideObj, 90]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 200] call aw_fnc_spawn2_perimeterPatrol;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			//Spawn units to garrison the objective
			for "_i" from 0 to _spawnLevel do {
				_randomPos = [[[getPos sideObj, 20]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;

				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};
			// Spawn mounted patrol
			if (_spawnLevel >= 2 || random 1 > 0.85) then {
				_randomPos = [[[getPos sideObj, 100]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
				
				_unitsArray = _unitsArray + [_spawnGroup]; {_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);
			};


			// Spawn area AAA
			[_flatpos] call vk_addAirDefense;

			//Set marker up
			_accepted = false;
			_fuzzyPos = _flatPos;
			while {!_accepted} do {
				LOG("Start Fuzzy Loop");
				_fuzzyPos =
				[
					((_flatPos select 0) - 500) + (random 1000),
					((_flatPos select 1) - 500) + (random 1000),
					0
				];
				if (!surfaceisWater _fuzzyPos) then {
					_accepted = true;
					LOG("Fuzzy Loop Accepted");
				};
			};

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Outpost";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Throw briefing hint
			GlobalHint = format [_briefing, mapgridPosition _fuzzyPos]; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Outpost"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Outpost";
			publicVariable "sideMarkerText";

			//Wait for boats to be dead
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";



			//Throw completion hint
			[] call AW_fnc_rewardPlusHint;
			 _lastSM = "destroyOutpost";
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			sleep 5;
			publicVariable "sideMarker";
		}; /* case "destroyOutpost": */
	};
};