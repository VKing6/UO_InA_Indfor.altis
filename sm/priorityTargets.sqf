//by Rarek [AW] with modifications by VKing

// #define DEBUG_MODE_FULL
#include "\x\cba\addons\main\script_macros_common.hpp"

private ["_firstRun","_isGroup","_obj","_position","_flatPos","_nearUnits","_accepted","_debugCounter","_pos","_barrier","_dir","_unitsArray","_randomPos","_spawnGroup","_unit","_targetPos","_debugCount","_radius","_randomWait","_briefing","_flatPosAlt","_flatPosClose","_priorityGroup","_distance","_firingMessages","_completeText","_SPG","_isFlatEmptyArray","_spawnMagnitude","_spawnVehicleType","_hintNotification","_ammo","_roundCount","_minRange","_maxRange","_fuzzyPos"];
_firstRun = true;
_unitsArray = [objNull];
_completeText =
"<t align='center' size='2.2'>Priority Target</t><br/><t size='1.5' color='#08b000'>NEUTRALISED</t><br/>____________________<br/>Incredible job, boys! Make sure you jump on those priority targets quickly; they can really cause havoc if they're left to their own devices.<br/><br/>Keep on with the main objective; we'll tell you if anything comes up.";

while {true} do {
	LOG("Start");
	_randomWait = (random 1200);
	sleep (600 + _randomWait);
	if (_firstRun) then {
		_firstRun = false;
	} else {
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
	};
	debugMessage = format["PT: Waiting %1 before next PT.",(_randomWait + 600)];
	publicVariable "debugMessage";

	/* ================================ */
	/* ====== CREATE MORTAR TEAM ====== */
	/* ================================ */

	debugMessage = "Priority Target started.";
	publicVariable "debugMessage";

	_SPG = if (random 1 > 0.9) then {true} else {false};
	// _SPG = true;
	
	//Define hint
	_briefing = if (_SPG) then {
		"<t align='center' size='2.2'>Priority Target</t><br/><t size='1.5' color='#b60000'>Enemy Artillery</t><br/>____________________<br/>OPFOR forces are setting up an artillery unit to hit you guys damned hard! We've picked up their positions with thermal imaging scans and have marked it on your map.<br/><br/>This is a priority target, boys! They're just setting up now; they'll be ready to fire in about five minutes!";
	} else {
		"<t align='center' size='2.2'>Priority Target</t><br/><t size='1.5' color='#b60000'>Enemy Mortars</t><br/>____________________<br/>OPFOR forces are setting up a mortar team to hit you guys damned hard! We've picked up their positions with thermal imaging scans and have marked it on your map.<br/><br/>This is a priority target, boys! They're just setting up now; they'll be ready to fire in about one minute!";
	};

	//	Find flat position that's not near spawn or within (PARAMS_AOSize + 200) of AO
	//	Possibly change this to include mortar teams spawning on a minimum elevation?

	_flatPos = [0];
	_accepted = false;
	_debugCounter = 1;
	_isFlatEmptyArray = if (_SPG) then {[10, 0, 0.4, 10, 0, false]} else {[5, 0, 0.2, 5, 0, false]};
	
	while {!_accepted} do {
		LOG("Start Creation Loop");
		debugMessage = format["PT: Finding flat position.<br/>Attempt #%1",_debugCounter];
		publicVariable "debugMessage";
		_debugCounter = _debugCounter + 1;

		while {(count _flatPos) < 3} do {
			_position = [[[getMarkerPos currentAO,2500]],["water","out"]] call BIS_fnc_randomPos;
			_flatPos = _position isFlatEmpty _isFlatEmptyArray;
		};

		if ((_flatPos distance (getMarkerPos "respawn")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 1500) then {
			_nearUnits = 0;
			{
				if ((_flatPos distance (getPos _x)) < 500) then {
					_nearUnits = _nearUnits + 1;
				};
			} forEach playableUnits;

			if (_nearUnits == 0) then {
				_accepted = true;
				LOG("Creation Loop Accepted");
			};
		} else {
			_flatPos = [0];
		};
	};

	debugMessage = "PT: Spawning mortars, units and fire teams.";
	publicVariable "debugMessage";

	//Spawn units
	_spawnMagnitude = if (_SPG) then {8} else {2};
	_spawnVehicleType = if (_SPG) then {"O_MBT_02_arty_F"} else {"O_Mortar_01_F"};
	_flatPosAlt = [(_flatPos select 0) - _spawnMagnitude, (_flatPos select 1), (_flatPos select 2)];
	_flatPosClose = [(_flatPos select 0) + _spawnMagnitude, (_flatPos select 1), (_flatPos select 2)];
	_priorityGroup = createGroup EAST;
	priorityVeh1 = _spawnVehicleType createVehicle _flatPosAlt;
	priorityVeh2 = _spawnVehicleType createVehicle _flatPosClose;
	priorityVeh1 addEventHandler["Fired",{if (!isPlayer (gunner priorityVeh1)) then { priorityVeh1 setVehicleAmmo 1; };}];
	priorityVeh2 addEventHandler["Fired",{if (!isPlayer (gunner priorityVeh2)) then { priorityVeh2 setVehicleAmmo 1; };}];
	"O_Soldier_F" createUnit [_flatPosAlt, _priorityGroup, "priorityTarget1 = this; this moveInGunner priorityVeh1;"];
	"O_Soldier_F" createUnit [_flatPosClose, _priorityGroup, "priorityTarget2 = this; this moveInGunner priorityVeh2;"];
	waitUntil {alive priorityTarget1 && alive priorityTarget2};
	priorityVeh1 allowCrewInImmobile true;
	priorityVeh2 allowCrewInImmobile true;
	priorityTargets = [priorityTarget1, priorityTarget2];
	{ publicVariable _x; } forEach ["priorityTarget1", "priorityTarget2", "priorityTargets", "priorityVeh1", "priorityVeh2"];
	LOG("Vehicles Created");
	//Small sleep to let units settle in
	sleep 10;

	//Define unitsArray for deletion after completion
	_unitsArray = [PriorityTarget1, PriorityTarget2, priorityVeh1, priorityVeh2];

	//Spawn H-Barrier cover "Land_HBarrierBig_F"
	_distance = if (_SPG) then {20} else {12};
	_dir = 0;
	for "_c" from 0 to 15 do {
		_pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
		_barrier = "Land_HBarrier_3_F" createVehicle _pos;
		waitUntil {alive _barrier};
		_barrier setDir _dir;
		_dir = _dir + 22.5;

		_unitsArray = _unitsArray + [_barrier];
	};

	//Spawn some enemies protecting the units
	for "_c" from 0 to 0 do {
		_randomPos = [[[_flatPos, 85]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_AT")] call BIS_fnc_spawnGroup;
		// [_spawnGroup, _flatPos] call BIS_fnc_taskDefend;
		[_spawnGroup, _flatPos, 250] call aw_fnc_spawn2_perimeterPatrol;

		_unitsArray = _unitsArray + [_spawnGroup];
	};

	for "_c" from 0 to 2 do {
		_randomPos = [[[_flatPos, 50]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 100] call bis_fnc_taskPatrol;

		_unitsArray = _unitsArray + [_spawnGroup];
	};
	LOG("Guards Created");
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

	{ _x setMarkerPos _fuzzyPos; } forEach ["priorityMarker", "priorityCircle"];
	if (_SPG) then {
		"priorityMarker" setMarkerText "Priority Target: Artillery Unit";
		"priorityMarker" setMarkerType "o_art";
	} else {
		"priorityMarker" setMarkerText "Priority Target: Mortar Team";
		"priorityMarker" setMarkerType "o_mortar";
	};
	publicVariable "priorityMarker";
	priorityTargetUp = true;
	priorityTargetText = if (_SPG) then {"Artillery Unit"} else {"Mortar Team"};
	publicVariable "priorityTargetUp";
	publicVariable "priorityTargetText";

	//Send Global Hint
	GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
	_hintNotification = if (_SPG) then {"Destroy Enemy Artillery Unit"} else {"Destroy Enemy Mortar Team"};
	showNotification = ["NewPriorityTarget", _hintNotification]; publicVariable "showNotification";

	debugMessage = "Letting mortars 'set up'.";
	publicVariable "debugMessage";

	//Wait for 1-2 minutes while the mortars "set up"
	sleep (if (_SPG) then {(random 300) max 60} else {random 60});

	//Set mortars attacking while still alive
	_firingMessages =
	[
		"Thermal scans are picking up those enemy mortars firing! Heads down!",
		"Enemy mortar rounds incoming! Advise you seek cover immediately.",
		"OPFOR mortar rounds incoming! Seek cover immediately!",
		"The mortar team's firing, boys! Down on the ground!",
		"Get that damned mortar team down; they're firing right now! Seek cover!",
		"They're zeroing in! Incoming mortar fire; heads down!"
	];
	// _radius = 100; //Declared here so we can "zero in" gradually
	_radius = 60 + random 40;
	while {alive priorityVeh1 || alive priorityVeh2} do {
		LOG("Start Engagement Loop");
		_accepted = false;
		_unit = objNull;
		_targetPos = [0,0,0];
		_debugCount = 1;
		_minRange = false;
		_maxRange = false;
		while {!_accepted && !(isNull gunner priorityVeh1 || isNull gunner priorityVeh2)} do {
			LOG("Start Targeting Loop");
			debugMessage = format["PT: Finding valid target.<br/><br/>Attempt #%1",_debugCount]; publicVariable "debugMessage";
			
			if (count playableUnits > 0) then {
				_unit = (playableUnits select (floor (random (count playableUnits))));
			} else {
				_unit = player;
			};
			_targetPos = getPos _unit;
			
			if (_SPG) then {
				_minRange = ((_targetPos distance _flatPos) < 840);
				_maxRange = false;
			} else {
				_minRange = false;
				_maxRange = ((_targetPos distance _flatPos) > 4075);
			};
			
			if ((_targetPos distance (getMarkerPos "respawn")) > 1000 /* && vehicle _unit == _unit */ && side _unit != EAST && EAST knowsAbout vehicle _unit > 3 && !_minRange && !_maxRange && (_targetPos select 2) < 3) then {
				_accepted = true;
				LOG("Targeting Loop Accepted");
			};

			_debugCount = _debugCount + 1;
			sleep 4;
		};
		if (_accepted) then {
			debugMessage = "PT: Valid target found; warning players and beginning fire sequence.";
			publicVariable "debugMessage";

			// hqSideChat = _firingMessages call BIS_fnc_selectRandom; 
			_firingMessage = if (_SPG) then {
				format ["<t align='center' size='1.5'>Artillery Firing</t><br/>Four rounds incoming to grid <t color='#b60000'>%1</t>",mapGridPosition _targetPos];
			} else {
				format ["<t align='center' size='1.5'>Mortars Firing</t><br/>Six rounds incoming to grid <t color='#b60000'>%1</t>",mapGridPosition _targetPos];
			};
			GlobalHint = _firingMessage;
			publicVariable "GlobalHint"; hint parseText GlobalHint;
			// [-1, {[Independent,"Firefinder Battery"] SideChat _this}, _mortarChat] call CBA_fnc_globalExecute;
			
			LOG("Starting Firing Section");
			_dir = [_flatPos, _targetPos] call BIS_fnc_dirTo;
			if (!_SPG) then {{ _x setDir _dir; } forEach [priorityVeh1, priorityVeh2]};
			_ammo = if (_SPG) then {"32Rnd_155mm_Mo_shells"} else {"8Rnd_82mm_Mo_shells"};
			_roundCount = if (_SPG) then {2} else {3};
			sleep 5;
			{
				LOG("Start Firing Loop");
				if (alive _x) then {
					for "_c" from 1 to _roundCount do {
						_pos =
						[
							(_targetPos select 0) - _radius + (2 * random _radius),
							(_targetPos select 1) - _radius + (2 * random _radius),
							0
						];
						_x doArtilleryFire [_pos, _ammo, 1];
						sleep 5;
					};
				};
				LOG("Rounds Complete");
			} forEach priorityTargets;

			if (_radius > 10) then { _radius = _radius - 10; }; /* zeroing in */

			sleep 300; //(if (_radius > 50) then {150} else {300});
		};
	};

	//Send completion hint
	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedPriorityTarget", "Enemy Mortar Team Neutralised"]; publicVariable "showNotification";

	//Set global VAR saying mission is complete
	priorityTargetUp = false;
	publicVariable "priorityTargetUp";

	//Hide priorityMarker
	"priorityMarker" setMarkerPos [0,0,0];
	"priorityCircle" setMarkerPos [0,0,0];
	publicVariable "priorityMarker";
};