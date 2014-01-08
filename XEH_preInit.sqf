
	tin_vehiclePrep = {
		private ["_unit","_magType","_traType","_sawType"];

		if (isServer) then {
			_unit = _this select 0;

			clearItemCargoGlobal _unit;
			clearWeaponCargoGlobal _unit;
			clearMagazineCargoGlobal _unit;
			clearBackpackCargoGlobal _unit;

			[-2, {_this setAmmoCargo 0}, _unit] call CBA_fnc_globalExecute;
			[-2, {_this setRepairCargo 0}, _unit] call CBA_fnc_globalExecute;
			[-2, {_this setFuelCargo 0}, _unit] call CBA_fnc_globalExecute;

			/*
			_magType = "30Rnd_65x39_caseless_mag";
			_traType = "30Rnd_65x39_caseless_mag_Tracer";
			_sawType = "100Rnd_65x39_caseless_mag";

			_magType = "30Rnd_65x39_caseless_green";
			_traType = "30Rnd_65x39_caseless_green_mag_Tracer";
			_sawType = "150Rnd_762x51_Box";
			*/
			_magType = "30Rnd_556x45_Stanag";
			_traType = "30Rnd_556x45_Stanag_Tracer_Yellow";
			_sawType = "200Rnd_65x39_cased_Box";

			if (_unit isKindOf "Wheeled_APC_F") then {
				_unit addWeaponCargoGlobal ["launch_NLAW_F",4];
				_unit addMagazineCargoGlobal ["Titan_AT",2];
				
				_unit addItemCargoGlobal ["FirstAidKit",20];

				_unit addMagazineCargoGlobal [_magType,40];
				_unit addMagazineCargoGlobal [_traType,10];
				_unit addMagazineCargoGlobal [_sawType,20];

				_unit addMagazineCargoGlobal ["HandGrenade",20];
				_unit addMagazineCargoGlobal ["SmokeShell",20];

				_unit addMagazineCargoGlobal ["Chemlight_green",20];
				_unit addMagazineCargoGlobal ["Chemlight_red",10];

				_unit addBackpackCargoGlobal ["B_GMG_01_A_weapon_F",1];
				_unit addBackpackCargoGlobal ["B_HMG_01_support_F",1];
			};

			if (_unit isKindOf "Tank_F") then {
				_unit addWeaponCargoGlobal ["launch_NLAW_F",4];
				_unit addMagazineCargoGlobal ["Titan_AT",2];
				
				_unit addItemCargoGlobal ["FirstAidKit",5];

				_unit addMagazineCargoGlobal [_magType,40];
				_unit addMagazineCargoGlobal [_traType,10];
				_unit addMagazineCargoGlobal [_sawType,20];

				_unit addMagazineCargoGlobal ["HandGrenade",20];
				_unit addMagazineCargoGlobal ["SmokeShell",20];

				_unit addMagazineCargoGlobal ["Chemlight_green",20];
				_unit addMagazineCargoGlobal ["Chemlight_red",10];

				_unit addBackpackCargoGlobal ["B_Mortar_01_weapon_F",1];
				_unit addBackpackCargoGlobal ["B_Mortar_01_support_F",1];
			};

			if (_unit isKindOf "I_MRAP_03_hmg_F") then {
				[-2,{
					_this addMagazineTurret ["200Rnd_127x99_mag_Tracer_Yellow", [0]];
					_this addMagazineTurret ["200Rnd_127x99_mag_Tracer_Yellow", [0]];
				},_unit] call CBA_fnc_globalExecute;
			};
			
			if (_unit isKindOf "MRAP_03_base_F") then {
				_unit addWeaponCargoGlobal ["launch_NLAW_F",2];
				
				_unit addItemCargoGlobal ["FirstAidKit",10];

				_unit addMagazineCargoGlobal [_magType,20];
				_unit addMagazineCargoGlobal [_traType,5];
				_unit addMagazineCargoGlobal [_sawType,10];

				_unit addMagazineCargoGlobal ["HandGrenade",10];
				_unit addMagazineCargoGlobal ["SmokeShell",10];

				_unit addMagazineCargoGlobal ["Chemlight_green",20];
				_unit addMagazineCargoGlobal ["Chemlight_red",10];
			};

			if (_unit isKindOf "Truck_F") then {
				_unit addWeaponCargoGlobal ["launch_NLAW_F",8];
				_unit addMagazineCargoGlobal ["Titan_AT",4];
				
				_unit addItemCargoGlobal ["FirstAidKit",40];

				_unit addMagazineCargoGlobal [_magType,80];
				_unit addMagazineCargoGlobal [_traType,20];
				_unit addMagazineCargoGlobal [_sawType,20];

				_unit addMagazineCargoGlobal ["HandGrenade",20];
				_unit addMagazineCargoGlobal ["SmokeShell",20];

				_unit addMagazineCargoGlobal ["Chemlight_green",50];
				_unit addMagazineCargoGlobal ["Chemlight_red",25];
			};
		};
	};

	vk_getSpawnLevel = {
		private ["_spawnLevel","_aaLevel","_serverPop"];
		_spawnLevel = 0;
		_aaLevel = 0;
		_serverPop = count(playableUnits);
		if (_serverPop >= 12) then {_spawnLevel = 1};
		if (_serverPop >= 25) then {_spawnLevel = 2};
		if (_serverPop >= 35) then {_spawnLevel = 3};

		if (_spawnLevel >= 2) then {_aaLevel = 1};
		[_spawnLevel,_aaLevel]
	};
	
	///// awFunctions.sqf /////
	aw_fnc_loiter = {
		private["_group","_wp","_pos"];
		_group = _this select 0;
		_pos = _this select 1;
		_wp = _group addWaypoint [_pos, 0];
		_wp setWaypointType "LOITER";
	};

	aw_fnc_fuelMonitor = {
		if(!isServer OR (vehicle _this == _this)) exitWith {};
		while{(alive _this) AND (({side _x == WEST} count (crew _this)) > 0)} do {
			waitUntil{sleep 2;(fuel _this < 0.1) OR !(alive _this) OR !(({side _x == WEST} count (crew _this)) > 0)};
			if((alive _this) AND (({side _x == WEST} count (crew _this)) > 0)) then {_x setFuel 1};
		};
	};

	aw_fnc_randomPos = {
		private["_center","_radius","_exit","_pos","_angle","_posX","_posY","_size","_flatPos"];
		_center = _this select 0;
		_size = if(count _this > 2) then {_this select 2};
		_exit = false;

		while{!_exit} do {
			_radius = random (_this select 1);
			_angle = random 360;
			_posX = (_radius * (sin _angle));
			_posY = (_radius * (cos _angle));
			_pos = [_posX + (_center select 0),_posY + (_center select 1),0];
			if(!surfaceIsWater [_pos select 0,_pos select 1]) then {
				if(count _this > 2) then {
					_flatPos = _pos isFlatEmpty [_size / 2,0,0.7,_size,0,false];
					if(count _flatPos != 0) then {
						_pos = _flatPos;
						_exit = true
					};
				} else {_exit = true};
			};
		};

		_pos;
	};

	aw_fnc_spawn2_waypointBehaviour = {
		if(!isServer) exitWith{};
		while{({alive _x} count (units _this) > 0)} do {
			waitUntil{sleep 1;({(_x select 2) == west} count ((leader _this) nearTargets 1000) > 1) OR !({alive _x} count (units _this) > 0)};
			if({alive _x} count (units _this) > 0) then {
				{
					if(waypointType _x == "MOVE") then {_x setWaypointBehaviour "SAD"};
					_x setWaypointBehaviour "COMBAT";
					_x setWaypointBehaviour "WEDGE";
				}forEach (waypoints _this);
			};
			waitUntil{sleep 1;({(_x select 2) == west} count ((leader _this) nearTargets 1600) < 1) OR !({alive _x} count (units _this) > 0)};
			if({alive _x} count (units _this) > 0) then {
				{
					if(waypointType _x == "SAD") then {_x setWaypointBehaviour "MOVE"};
					_x setWaypointBehaviour "SAFE";
					_x setWaypointBehaviour "STAG COLUMN";
				}forEach (waypoints _this);
			};
		};
	};

	aw_fnc_radPos = {
		if(!isServer) exitWith{};
		private["_center","_radius","_angle","_pos","_exit","_posX","_posY"];
		_center = _this select 0;
		_radius = _this select 1;
		_angle = _this select 2;
		_exit = false;

		while{!_exit} do {
			_posX = (_radius * (sin _angle));
			_posY = (_radius * (cos _angle));
			_pos = [_posX + (_center select 0),_posY + (_center select 1),0];
			if(!surfaceIsWater [_pos select 0,_pos select 1]) then {_exit = true} else {_radius = _radius - 1};
			if(_radius == 0) then {_pos = _center;_exit = true};
		};
		_pos;
	};

	aw_fnc_spawn2_hold = {
		if(!isServer) exitWith{};
		private["_group","_wp","_pos"];
		_group = _this select 0;
		_pos = _this select 1;

		_wp = _group addWaypoint [_pos, 0];
		_wp setWaypointType "HOLD";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointSpeed "LIMITED";
	};

	aw_fnc_spawn2_randomPatrol = {
		if(!isServer) exitWith{};
		private["_group","_center","_radius","_wp","_checkDist","_angle","_currentAngle","_pos","_wp1"];
		_group = _this select 0;
		_center = _this select 1;
		_radius = _this select 2;
		_waypointNumbers = if(count _this > 3) then {_this select 3} else {20 + floor ((random 10))};

		for "_i" from 1 to _waypointNumbers do {
			_pos = [_center,(random _radius),(random 360)] call aw_fnc_radPos;
			_wp = _group addWaypoint [_pos,0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointFormation "STAG COLUMN";
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointTimeOut [0,10,40];

			if(_i == 1) then {_wp1 = _wp};
		};

		_wp = _group addWaypoint [waypointPosition _wp1,0];
		_wp setWaypointType "CYCLE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "STAG COLUMN";
		_wp setWaypointBehaviour "SAFE";

		_group spawn aw_fnc_spawn2_waypointBehaviour;
	};

	aw_fnc_spawn2_perimeterPatrol = {
		if(!isServer) exitWith{};
		private["_group","_center","_radius","_wp","_angle","_currentAngle","_wp1","_pos","_toCenter"];
		_group = _this select 0;
		_center = _this select 1;
		_radius = _this select 2;
		_waypointNumbers = if(count _this > 3) then {_this select 3} else {20 + floor ((random 10))};
		_toCenter = if(count _this > 4) then {_this select 4} else {false};

		_angle = 360 / _waypointNumbers;
		_currentAngle = _angle + (random 360);

		for "_i" from 1 to _waypointNumbers do {
			_pos = [_center,_radius,_currentAngle] call aw_fnc_radPos;
			_wp = _group addWaypoint [_pos,0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointFormation "STAG COLUMN";
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointTimeOut [0,10,40];

			if(_i == 1) then {_wp1 = _wp};
			_currentAngle = _currentAngle + _angle;
		};

		if(_toCenter) then {
			_wp = _group addWaypoint [_center,0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointFormation "STAG COLUMN";
		};

		_wp = _group addWaypoint [waypointPosition _wp1,0];
		_wp setWaypointType "CYCLE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "STAG COLUMN";

		_group spawn aw_fnc_spawn2_waypointBehaviour;
	};

	aw_setGroupSkill = {
		if(!isServer) exitWith{};
		{
			_x setSkill ["aimingAccuracy",0.3];
			_x setSkill ["aimingSpeed",0.3];
			_x setSkill ["aimingShake",0.8];
			_x setSkill ["spottime", 0.4];
			_x setSkill ["spotdistance", 0.6];
			_x setSkill ["commanding", 1];
		} forEach (_this select 0);
	};

	aw_cleanGroups = {
		if(!isServer) exitWith{};
		{
			if(count (units _x) == 0) then {deleteGroup _x};
		}forEach allGroups;

	};

	aw_deleteUnits = {
		private["_deleteVehicles"];
		if(!isServer) exitWith{};

		_deleteVehicles = if(count _this > 1) then {_this select 1} else {true};

		{
			if(_deleteVehicles) then {deleteVehicle (vehicle _x)} else{moveOut _x};
			deleteVehicle _x;
		}forEach (_this select 0);

		[] spawn aw_cleanGroups;
	};

	aw_serverRespawn = {
		if(!serverCommandAvailable "#kick") exitWith{};
		private ["_y"];
		{
			_x setVelocity [0,0,0];
			_x setPos [getPos _x select 0,getPos _x select 1,0];

			hint format["Deleting %1",typeOf _x];

			for "_y" from 0 to (count (crew _x) -1) do {
				moveOut ((crew _x) select _y);
				((crew _x) select _y) setPos [getPos ((crew _x) select _y) select 0,(getPos ((crew _x) select _y) select 1) + 5,0];
			};
			_x setPos [0,0,0];
			_x setDamage 1;
		} forEach ((getPos trg_aw_admin) nearEntities [["Air","Car","Motorcycle","Tank"],5000]);
	};

	aw_serverSingleRespawn = {
		private ["_unit","_pos","_units"];

		if(!serverCommandAvailable "#kick") exitWith{};

		_pos = screenToWorld [0.5,0.5];

		_units = _pos nearEntities [["Car","Air","Tank","Ship","Motorcycle"],5];

		if(count _units > 0) then {
			_unit =_units select 0;
			_unit setVelocity [0,0,0];
			_unit setPos [getPos _unit select 0,getPos _unit select 1,0];

			hint format["Deleting %1",typeOf _unit];

			for "_i" from 0 to (count (crew _unit) -1) do {
				moveOut ((crew _unit) select _i);
				((crew _unit) select _i) setPos [getPos ((crew _unit) select _i) select 0,(getPos ((crew _unit) select _i) select 1) + 5,0];
			};
			_unit setPos [0,0,0];
			_unit setDamage 1;
		};
	};

	aw_serverCursorTP = {
		if(!serverCommandAvailable "#kick") exitWith{};
		player setPos (screenToWorld [0.5,0.5]);
	};

	aw_serverMapTP = {
		if(!serverCommandAvailable "#kick") exitWith{};
		onMapSingleClick "player setPos _pos;onMapSingleClick '';true";
	};