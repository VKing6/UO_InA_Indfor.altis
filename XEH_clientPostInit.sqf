
	//Briefing
	_words = [] execVM "briefing.sqf";

	//INDFOR Skins for AH-6 / P-30
	{_x setObjectTexture [0,"\A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]} forEach allMissionObjects "Heli_Light_01_base_F";
	{_x setObjectTexture [0,"A3\Air_F\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]} forEach allMissionObjects "Heli_Light_02_base_F";
	{_x removeMagazine "2Rnd_GBU12_LGB_MI10"; _x removeWeapon "GBU12BombLauncher"; _x addMagazine "2Rnd_LG_scalpel";} forEach allMissionObjects "I_Plane_Fighter_03_CAS_F";
	
	((position hideLogic) nearestObject 872793) hideObject true;

	if (isNil "tin_playerInCRV") then {tin_playerInCRV = false};
	if (isNil "tin_playerInFuel") then {tin_playerInFuel = false};
	if (isNil "tin_playerInAmmo") then {tin_playerInAmmo = false};
	if (isNil "tin_playerInRepair") then {tin_playerInRepair = false};
	if (isNil "tin_repairInProgress") then {tin_repairInProgress = false};
	
	player setVariable ["tin_unitSide", side player, true];

	[] spawn {
		//Nametag Scripts
		[] execVM "scripts\name_tag\init.sqf";
	};	

	////// Vehicle / CVC Check /////////////
	tin_vehicleCheck = [{
		if (isNil "tin_hatStore") then {tin_hatStore = "H_Beret_blk"};

		if (alive player) then {
			if (isNil "tin_hatStore") then {tin_hatStore = "H_Beret_blk"};
			if ((vehicle player) isKindOf "Wheeled_APC_F" || (vehicle player) isKindOf "Tank_F") then {
				if (typeOf player != "I_crew_F" && typeOf player != "I_support_Mort_F" && typeOf player != "I_support_AMort_F") then {
					if ((vehicle player) isKindOf "Tank" || (vehicle player) isKindOf "Wheeled_APC_F") then {
						if ((assignedVehicleRole player) select 0 != "Cargo") then {
							player action ["eject", (vehicle player)];
							player action ["engineOff", (vehicle player)];
							hint "You must be trained crew to operate armored vehicles!";
						};
					};
				} else {
					if ((assignedVehicleRole player) select 0 != "Cargo") then {

						if ((headgear player) != "H_HelmetCrew_B" && (headgear player) != "H_HelmetCrew_O" && (headgear player) != "H_HelmetCrew_I") then {
							tin_hatStore = headgear player;

							switch (side player) do {
								case west: {player addHeadgear "H_HelmetCrew_B"};
								case east: {player addHeadgear "H_HelmetCrew_O"};
								default {player addHeadgear "H_HelmetCrew_I"};
							};
						};
					};

					if ((assignedVehicleRole player) select 0 == "Cargo" && ((headgear player) == "H_HelmetCrew_B" || (headgear player) == "H_HelmetCrew_O" || (headgear player) == "H_HelmetCrew_I")) then {
						player addHeadgear tin_hatStore;
					};
				};
			};

			if ((vehicle player) isKindOf "Helicopter" || (vehicle player) isKindOf "Plane") then {
				if (typeOf player != "I_helipilot_F") then {
					if (driver (vehicle player) == player || str(assignedVehicleRole (vehicle player)) == str(["Turret",[0]])) then {
						player action ["eject", (vehicle player)];
						player action ["engineOff", (vehicle player)];
						hint "You must be a pilot to fly!";
					};
				};
			};

			if (vehicle player == player) then {
				if ((headgear player) == "H_HelmetCrew_B" || (headgear player) == "H_HelmetCrew_O" || (headgear player) == "H_HelmetCrew_I") then {
					player addHeadgear tin_hatStore;
					tin_hatStore = "H_Beret_blk";
				};
			};
		};
	},0] call CBA_fnc_addPerFrameHandler;

	////// Vehicle Service Check ///////////
	tin_serviceCheck = [{
		if (isNil "tin_actionsAdded") then {tin_actionsAdded = false};

		if (alive player) then {
			if ((vehicle player) isKindOf "B_APC_Tracked_01_CRV_F" && !tin_playerInCRV) then {
				tin_playerInCRV = true
			} else {
				if (!((vehicle player) isKindOf "B_APC_Tracked_01_CRV_F") && tin_playerInCRV) then {
					tin_playerInCRV = false
				};
			};

			if ((vehicle player) isKindOf "I_Truck_02_fuel_F" && !tin_playerInFuel) then {
				tin_playerInFuel = true
			} else {
				if (!((vehicle player) isKindOf "I_Truck_02_fuel_F") && tin_playerInFuel) then {
					tin_playerInFuel = false
				};
			};

			if ((vehicle player) isKindOf "I_Truck_02_ammo_F" && !tin_playerInAmmo) then {
				tin_playerInAmmo = true
			} else {
				if (!((vehicle player) isKindOf "I_Truck_02_ammo_F") && tin_playerInAmmo) then {
					tin_playerInAmmo = false
				};
			};

			if ((vehicle player) isKindOf "I_Truck_02_box_F" && !tin_playerInRepair) then {
				tin_playerInRepair = true
			} else {
				if (!((vehicle player) isKindOf "I_Truck_02_box_F") && tin_playerInRepair) then {
					tin_playerInRepair = false
				};
			};

			if (!tin_actionsAdded) then {
				tin_actionsAdded = true;
				_vehSrv1 = player addAction ["Service Vehicle", {[0, {_handle = [_this,[1,0.10],0,1,false] execVM "misc\serviceVehicle.sqf"}, (_this select 1)] call CBA_fnc_globalExecute},"",10,true,false,"","tin_playerInCRV"];
				_vehSrv2 = player addAction ["Refuel Vehicle", {[0, {_handle = [_this,[2,1.0],0,0,true] execVM "misc\serviceVehicle.sqf"}, (_this select 1)] call CBA_fnc_globalExecute},"",10,true,false,"","tin_playerInFuel"];
				_vehSrv3 = player addAction ["Rearm Vehicle", {[0, {_handle = [_this,[0,1.0],1,0,true] execVM "misc\serviceVehicle.sqf"}, (_this select 1)] call CBA_fnc_globalExecute},"",10,true,false,"","tin_playerInAmmo"];
				_vehSrv4 = player addAction ["Repair Vehicle", {[0, {_handle = [_this,[0,1.0],0,1,true] execVM "misc\serviceVehicle.sqf"}, (_this select 1)] call CBA_fnc_globalExecute},"",10,true,false,"","tin_playerInRepair"];

			};
		} else {
			if (tin_repairInProgress) then {tin_repairInProgress = false};

			if (tin_actionsAdded) then {
				tin_actionsAdded = false;

				player removeAction _vehSrv1;
				player removeAction _vehSrv2;
				player removeAction _vehSrv3;
				player removeAction _vehSrv4;
			};
		};
	},0] call CBA_fnc_addPerFrameHandler;

	////// Weapon Check ////////////////////
	tin_weaponCheck = [{
		if ((player hasWeapon "launch_I_Titan_F") || (player hasWeapon "launch_I_Titan_short_F")) then {
			if ((playerSide == west && typeOf player != "B_soldier_LAT_F") || (playerside == east && typeOf player != "O_soldier_LAT_F") || (playerside == resistance && typeOf player != "I_soldier_LAT_F")) then {
				player removeWeapon "launch_I_Titan_F";
				player removeWeapon "launch_I_Titan_short_F";
				player globalChat "Only AT Soldiers are trained in missile launcher operations. Launcher removed.";
			};
		};

		if ("B_UavTerminal" in (assignedItems player) || "I_UavTerminal" in (assignedItems player) || "O_UavTerminal" in (assignedItems player)) then {
			if ((playerSide == west && typeOf player != "B_soldier_UAV_F") || (playerside == east && typeOf player != "O_soldier_UAV_F") || (playerside == resistance && typeOf player != "I_soldier_UAV_F")) then {
				player unassignItem "B_UavTerminal";
				player unassignItem "I_UavTerminal";
				player unassignItem "O_UavTerminal";
				player removeItem "B_UavTerminal";
				player removeItem "I_UavTerminal";
				player removeItem "O_UavTerminal";
				player globalChat "Only UAV Operators are trained in UAV operations. Terminal removed.";
			};
		};
	},1] call CBA_fnc_addPerFrameHandler;

	////// Spawn Protection ////////////////
	[] spawn {
		#define SAFETY_ZONES	[["base", 100]] // Syntax: [["marker1", radius1], ["marker2", radius2], ...]
		#define MESSAGE "Placing / throwing items and firing at base is STRICTLY PROHIBITED!"

		waitUntil {!isNil "PARAMS_SpawnProtection"};

		if (PARAMS_SpawnProtection == 1) then {
			player addEventHandler ["Fired", {
				if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then {
					deleteVehicle (_this select 6);
					titleText [MESSAGE, "PLAIN", 3];
				};

				if (_this select 5 == "RPG32_AA_F") then {
					deleteVehicle (_this select 6);
					titleText [MESSAGE, "PLAIN", 3];
				};
			}];

			player addEventHandler ["WeaponAssembled", {
				deleteVehicle _this select 1;
				titleText [MESSAGE, "PLAIN", 3];
			}];
		};
	};

	////// Player Markers //////////////////
	/*
	[] spawn {
		waitUntil {!isNil "PARAMS_PlayerMarkers"};

		if (PARAMS_PlayerMarkers == 1) then {
			tin_playerMarkers = [{
				_unitNumber = 0;
				{
					_show = false;
					_injured = false;

					if(_show) then {
						_unitNumber = _unitNumber + 1;
						_marker = format["um%1",_unitNumber];
						if(getMarkerType _marker == "") then {
							createMarkerLocal [_marker, getPos vehicle _x];
						} else {
							_marker setMarkerPosLocal getPosATL vehicle _x;
						};
						_marker setMarkerDirLocal getDir vehicle _x;

						if(_injured) then {
							_marker setMarkerColorLocal "ColorRed";
							_marker setMarkerTypeLocal "mil_dot";
							_marker setMarkerSizeLocal [0.8,0.8];
						} else {
							_marker setMarkerColorLocal "ColorGreen";
							_marker setMarkerTypeLocal "mil_triangle";
							if(_x == player) then {
								_marker setMarkerSizeLocal [0.7,1];
							} else {
								_marker setMarkerSizeLocal [0.5,0.7];
							};
						};

						_text = name _x;
						_veh = vehicle _x;
						if (_veh != _x) then {
							_crew = crew _veh;
							if ((count _crew) > 1) then {
								_crewLoopCount = (count _crew) - 1;
								for "_i" from 1 to _crewLoopCount do {
									_text = format["%1, %2", _text, name (_crew select _i)];
								};
							};
							_text = format["%1 [%2]", _text, getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName")];
						};
						_marker setMarkerTextLocal _text;
					};
				} forEach playableUnits;

				_unitNumber = _unitNumber + 1;
				_marker = format["um%1",_unitNumber];

				if ((getMarkerType _marker) != "") then {
					deleteMarkerLocal _marker;
					_unitNumber = _unitNumber + 1;
					_marker = format["um%1",_unitNumber];
				};
			},1] call CBA_fnc_addPerFrameHandler;
		};
	};

	////// Medic markers ///////////////////
	[] spawn {
		waitUntil {!isNil "PARAMS_MedicMarkers"};

		if (PARAMS_MedicMarkers == 1) then {
			if (typeOf player == "I_medic_F") then {
				tin_medicMarkers = [{
					{
						if (!isNil {_x getVariable "BTC_need_revive"}) then {
							if (_x getVariable "BTC_need_revive" select 0 == 1 && (player distance _x) < 500) then {
								_red=0;
								_green=0;
								_blueDec=0;

								_timeLeft = (_x getVariable "BTC_need_revive" select 1) - time;
								_halfMaxTime = BTC_revive_time_max / 2;
								_timeLeftDec = _timeLeft / BTC_revive_time_max;

								if (_timeLeftDec <= 0.5) then{
									_red = 255;
									_green = (255 / _halfMaxTime) * _timeLeft;
								} else {
									_red = 255 - (255 / _halfMaxTime) * (_timeLeft - _halfMaxTime);
									_green = 255;
								};

								_redDec = _red / 255;
								_greenDec = _green / 255;

								drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa",[_redDec,_greenDec,_blueDec,1],_x,1,1,0,format["%1 needs reviving (%2m)", name _x, ceil (player distance _x)],1];
							};
						};
					} forEach playableUnits;
				},0] call CBA_fnc_addPerFrameHandler;
			};

			if (typeOf player == "I_Soldier_repair_F") then {
				tin_repairMarkers = [{
					{
						if (side _x == GUER || side _x == CIV) then {
							if (damage _x > 0.02 && damage _x < 1) then {
								if ((player distance _x) < 1000) then {
									_red = 0;
									_green = 0;
									_blueDec = 0;
									_vehDamage = damage _x;

									if (_vehDamage <= 0.5) then {
										_green = 255;
										_red = ((_vehDamage * 100) * 5.1);
									} else {
										_red = 255;
										_green = 255 - ((_vehDamage * 100) * 2.55 )
									};

									_redDec = _red / 255;
									_greenDec = _green / 255;

									_vehName = getText(configFile>>"CfgVehicles">>typeOf vehicle _x>>"DisplayName");
									drawIcon3D["a3\ui_f\data\map\markers\nato\b_maint.paa",[_redDec,_greenDec,_blueDec,1],_x,1,1,0,format["%1 needs repairing (%2m)", _vehName, ceil (player distance _x)],1];
								};
							};
						};
					} forEach vehicles;
				},0] call CBA_fnc_addPerFrameHandler;
			};
		};
	};
	*/