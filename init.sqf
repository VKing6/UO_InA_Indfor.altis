/*
/*
      ::: ::: :::             ::: :::             :::
     :+: :+:   :+:           :+:   :+:           :+:
    +:+ +:+     +:+         +:+     +:+         +:+
   +#+ +#+       +#+       +#+       +#+       +#+
  +#+ +#+         +#+     +#+         +#+     +#+
 #+# #+#           #+#   #+#           #+#   #+#
### ###             ### ###             ### ###

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.82 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/
// JIP Check (This code should be placed first line of init.sqf file)
    if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};

    // Wait until player is initialized
    if (!isDedicated) then {waitUntil {!isNull player && isPlayer player};};


#define WELCOME_MESSAGE	"Welcome to Ahoy World's Invade & Annex ~ALTIS~\n" +\
						"by Rarek (Ahoy World)\n\n" +\
						"Modification for United Operations by TinfoilHate\n" +\
						"www.unitedoperations.net\n\n"


/* =============================================== */
/* =============== GLOBAL VARIABLES ============== */

/*
	These targets are simply markers on the map with
	the same name.

	Each AO will be a randomly-picked "target" from
	this list which will be removed upon completion.

	To ensure the mission works, make sure that any
	new targets you add have a relevant marker on
	the mission map.

	You can NOT have an AO called "Nothing".
*/
enableSaving [false, false];
private ["_pos","_uavAction","_isAdmin","_i","_isPerpetual","_accepted","_position","_randomWreck","_firstTarget","_validTarget","_targetsLeft","_flatPos","_targetStartText","_lastTarget","_initialTargets","_targets","_dt","_enemiesArray","_radioTowerDownText","_targetCompleteText","_null","_unitSpawnPlus","_unitSpawnMinus","_missionCompleteText","_beginTargets","_aiSkill","_serverPop","_spawnLevel"];

_beginTargets = [
	"Poliakko",
	"Neochori",
	"Lakka",
	"Agios Dionysios",
	"Outpost Kilo",
	"Alikampos",
	"Zaros",
	"Stavros"
];

_initialTargets = [
	"Poliakko",
	"Sofia",
	"Dome",
	"Feres",
	"Pyrgos",
	"Kavala",
	"Factory",
	"Syrta",
	"Neochori",
	"Zaros",
	"Chalkeia",
	"Athira",
	"Frini",
	"Abdera",
	"Panochori",
	"Neri",
	"Rodopoli",
	"Galati",
	"Oreokastro",
	"Negades",
	"Agios Dionysios",
	"Outpost Kilo",
	"Dockyard",
	"Airfield",
	"Telos Base",
	"Dorida",
	"Charkia",
	"Kalochori",
	"Lakka",
	"Panagia",
	"Molos",
	"Alikampos",
	"Stavros"
];

_targets = [
	"Poliakko",
	"Sofia",
	"Dome",
	"Feres",
	"Pyrgos",
	"Kavala",
	"Factory",
	"Syrta",
	"Neochori",
	"Zaros",
	"Chalkeia",
	"Athira",
	"Frini",
	"Abdera",
	"Panochori",
	"Neri",
	"Rodopoli",
	"Galati",
	"Oreokastro",
	"Negades",
	"Agios Dionysios",
	"Outpost Kilo",
	"Dockyard",
	"Airfield",
	"Telos Base",
	"Dorida",
	"Charkia",
	"Kalochori",
	"Lakka",
	"Panagia",
	"Molos",
	"Alikampos",
	"Stavros"
];

//Grab parameters and put them into readable variables
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do
{
	call compile format
	[
		"PARAMS_%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

tin_fifo_bodies = [];
enableSentences false;

"GlobalHint" addPublicVariableEventHandler
{
	private ["_GHint"];
	_GHint = _this select 1;
	hint parseText format["%1", _GHint];
};

"runOnServer" addPublicVariableEventHandler
{
	if (isServer) then
	{
		private ["_codeToRun"];
		_codeToRun = _this select 1;
		call _codeToRun;
	};
};

"radioTower" addPublicVariableEventHandler
{
	"radioMarker" setMarkerPosLocal (markerPos "radioMarker");
	"radioMarker" setMarkerTextLocal (markerText "radioMarker");
	"radioMineCircle" setMarkerPosLocal (markerPos "radioMineCircle");
};

"refreshMarkers" addPublicVariableEventHandler
{
	{
		_x setMarkerShapeLocal (markerShape _x);
		_x setMarkerSizeLocal (markerSize _x);
		_x setMarkerBrushLocal (markerBrush _x);
		_x setMarkerColorLocal (markerColor _x);
	} forEach _targets;

	{
		_x setMarkerPosLocal (markerPos _x);
		_x setMarkerTextLocal (markerText _x);
	} forEach ["aoMarker","aoCircle"];
};

"showNotification" addPublicVariableEventHandler
{
	private ["_type", "_message"];
	_array = _this select 1;
	_type = _array select 0;
	_message = "";
	if (count _array > 1) then { _message = _array select 1; };
	[_type, [_message]] call bis_fnc_showNotification;
};

"showSingleNotification" addPublicVariableEventHandler
{
	/* Slam somethin' 'ere */
};

"sideMarker" addPublicVariableEventHandler
{
	"sideMarker" setMarkerPosLocal (markerPos "sideMarker");
	"sideCircle" setMarkerPosLocal (markerPos "sideCircle");
	"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
};

"aw_addAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_actionArray = [(_this select 1) select 1, (_this select 1) select 2];
	_obj addAction _actionArray;
};

"aw_removeAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_id = (_this select 1) select 1;
	_obj removeAction _id;
};

"aw_unitSay" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_sound = (_this select 1) select 1;
	_obj say [_sound,15];
};

"hqSideChat" addPublicVariableEventHandler
{
	_message = _this select 1;
	[GUER,"HQ"] sideChat _message;
};

"debugMessage" addPublicVariableEventHandler
{
	private ["_isAdmin", "_message"];
	_isAdmin = serverCommandAvailable "#kick";
	if (_isAdmin) then
	{
		if (debugMode) then
		{
			_message = _this select 1;
			[_message] call bis_fnc_error;
		};
	};
};


/* =============================================== */
/* ================ PLAYER SCRIPTS =============== */
[player] execVM "scripts\crew\crew.sqf";
//0 = [] execVM 'group_manager.sqf';
_null = [] execVM "taw_vd\init.sqf";

if (isNil "radioTowerAlive") then {radioTowerAlive = false;};
if (isNil "sideMissionUp") then {sideMissionUp = false;};
if (isNil "currentAOUp") then {currentAOUp = false;};

call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";

if (PARAMS_MedicMarkers == 1) then { _null = [] execVM "misc\medicMarkers.sqf"; };
if (PARAMS_PlayerMarkers == 1) then { _null = [] execVM "misc\playerMarkers.sqf"; };

[] spawn {
	scriptName "initMission.hpp: mission start";
	//["rsc\FinalComp.ogv", false] spawn BIS_fnc_titlecard;
	//waitUntil {sleep 0.5; !(isNil "BIS_fnc_titlecard_finished")};
	//[[14600.0,16801.0,100],"We've gotten a foot-hold on the island,|but we need to take the rest.||Listen to HQ and neutralise all enemies designated."] spawn BIS_fnc_establishingShot;
	titleText [WELCOME_MESSAGE, "PLAIN", 3];
};

if (!isServer) then
{
	[] spawn {
		while {true} do {
			waitUntil {sleep 5; currentAOUp};

			{
				_x setMarkerPosLocal (getMarkerPos currentAO);
			} forEach ["aoCircle","aoMarker"];
			"aoMarker" setMarkerTextLocal format["Take %1",currentAO];
			
			waitUntil {sleep 5; !currentAOUp};
			
			{
				_x setMarkerPosLocal [0,0,0];
			} forEach ["aoCircle","aoMarker"];
		};
	};	
	
	[] spawn {
		while {true} do {
			waitUntil {sleep 5; radioTowerAlive};

			"radioMarker" setMarkerPosLocal (getPos radioTower);
			"radioMineCircle" setMarkerPosLocal (getPos radioTower);
			"radioMarker" setMarkerTextLocal (markerText "radioMarker");
			
			waitUntil {sleep 5; !radioTowerAlive};
			
			"radioMarker" setMarkerPosLocal [0,0,0];
			"radioMineCircle" setMarkerPosLocal [0,0,0];
		};
	};	
	
	[] spawn {
		while {true} do {
			waitUntil {sleep 5; sideMissionUp};

			"sideMarker" setMarkerPosLocal (getPos sideObj);
			"sideCircle" setMarkerPosLocal (getPos sideObj);
			"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];

			waitUntil {sleep 5; !sideMissionUp};
			
			"sideMarker" setMarkerPosLocal [0,0,0];
			"sideCircle" setMarkerPosLocal [0,0,0];
		};
	};
};

if (!isServer) exitWith
{
	_spawnBuildings = nearestObjects [(getMarkerPos "respawn"), ["building"], 10];

	{
		_x allowDamage false;
		_x enableSimulation false;
	} forEach _spawnBuildings;
};


/* =============================================== */
/* ============ SERVER INITIALISATION ============ */

//Set a few blank variables for event handlers and solid vars for SM
eastSide = createCenter EAST;

sideMissionUp = false;
currentAOUp = false;
refreshMarkers = true;
sideObj = objNull;
smRewards =
[
	["an AH-99 Blackfoot", "B_Heli_Attack_01_F"],
	["an M2A1 Slammer", "B_MBT_01_cannon_F"],
	["an M4 Scorcher", "B_MBT_01_arty_F"],
	["an M5 Sandstorm MLRS", "B_MBT_01_mlrs_F"],
	["an IFV-6a Cheetah", "B_APC_Tracked_01_AA_F"],
	["an A-143 Buzzard", "I_Plane_Fighter_03_CAS_F"]
];
smMarkerList = ["smReward1","smReward2","smReward3","smReward4","smReward5","smReward6","smReward7","smReward8","smReward9","smReward10","smReward11","smReward12","smReward13","smReward14","smReward15"];
smHangarList = ["smRewardH1","smRewardH2"];

/*---------------------------------------------------------------------------
Disabled while Alpha bug is present
---------------------------------------------------------------------------*/
/* radioChannels = []; publicVariable "radioChannels";
_null = [] execVM "misc\radioChannels.sqf"; */

//Run a few miscellaneous server-side scripts
_null = [] execVM "misc\clearBodiesFIFO.sqf";
_null = [] execVM "misc\clearItems.sqf";

//Run mortar scripts
//_null = [] execVM "misc\mortar\spawnhq.sqf";
//_null = [] execVM "misc\mortar\mortarHEReload.sqf";
//_null = [] execVM "misc\mortar\mortarSupportReload.sqf";

if (PARAMS_Skybunker > 0 && isServer) then {
	tin_skyBunker = "Land_Cargo_Tower_V2_F" createVehicle (position skyBunkerLogic);
	tin_skyBunker setPosATL [(getPosATL skyBunkerLogic select 0),(getPosATL skyBunkerLogic select 1),-0.05];
	tin_skyBunker setDir (getDir skyBunkerLogic);
	tin_skyBunker allowDamage false;
};

_isPerpetual = false;

if (PARAMS_Perpetual == 1) then
{
	_isPerpetual = true;
};

currentAO = "Nothing";
publicVariable "currentAO";
_lastTarget = "Nothing";
_targetsLeft = count _targets;

"TakeMarker" addPublicVariableEventHandler
{
	createMarker [((_this select 1) select 0), getMarkerPos ((_this select 1) select 1)];
	"theTakeMarker" setMarkerShape "ICON";
	"theTakeMarker" setMarkerType "o_unknown";
	"theTakeMarker" setMarkerColor "ColorOPFOR";
	"theTakeMarker" setMarkerText format["Take %1", ((_this select 1) select 1)];
};

"addToScore" addPublicVariableEventHandler
{
	((_this select 1) select 0) addScore ((_this select 1) select 1);
};

AW_fnc_minefield = {
	_centralPos = _this select 0;
	_unitsArray = [];
	for "_x" from 0 to 79 do
	{
		_mine = createMine ["SLAMDirectionalMine", _centralPos, [], 50];
		_unitsArray = _unitsArray + [_mine];
	};

	_distance = 50;
	_dir = 0;
	for "_c" from 0 to 7 do
	{
		_pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
		_sign = "Land_Sign_Mines_F" createVehicle _pos;
		waitUntil {alive _sign};
		_sign setDir _dir;
		_dir = _dir + 45;

		_unitsArray = _unitsArray + [_sign];
	};

	_unitsArray
};

AW_fnc_deleteOldAOUnits =
{
	private ["_unitsArray", "_obj", "_isGroup"];
	sleep 600;
	_unitsArray = _this select 0;
	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false; if (_obj in allGroups) then { _isGroup = true; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

AW_fnc_deleteSingleUnit = {

private ["_obj","_time"];
_obj = _this select 0;
	_time = _this select 1;
	sleep _time;
	deleteVehicle _obj;
};

AW_fnc_rewardPlusHint = {

private ["_veh","_vehName","_vehVarname","_completeText","_reward"];
	_veh = smRewards call BIS_fnc_selectRandom;
	_vehName = _veh select 0;
	_vehVarname = _veh select 1;
	_rewardPos = "";

	_completeText = format[
	"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>We've given you %1 to help with the fight. You'll find it at base.<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>",_vehName];

	if (_vehVarname isKindOf "I_Plane_Fighter_03_CAS_F" && count smHangarList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};
	if (!(_vehVarname isKindOf "I_Plane_Fighter_03_CAS_F") && count smMarkerList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};

	if (_vehVarname isKindOf "I_Plane_Fighter_03_CAS_F") then {
		_rewardPos = smHangarList call BIS_fnc_selectRandom;
		smHangarList = smHangarList - [_rewardPos];
	} else {
		_rewardPos = smMarkerList call BIS_fnc_selectRandom;
		smMarkerList = smMarkerList - [_rewardPos];
	};

	_rewardPos = [_rewardPos];

	_reward = createVehicle [_vehVarname, getMarkerPos "smReward0",_rewardPos,0,"NONE"];
	waitUntil {alive _reward};
	_reward setDir 130.5;
	_reward setPosATL [(getPosATL _reward select 0),(getPosATL _reward select 1),0.5];
	_rewardName = "reward_" + str(floor random 500000);
	_reward SetVehicleVarName _rewardName;

	if (_reward isKindOf "Heli_Light_01_base_F") then {[-1, {_this setObjectTexture [0,"\A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]}, _reward] call CBA_fnc_globalExecute;};
	if (_reward isKindOf "Heli_Light_02_base_F") then {[-1, {_this setObjectTexture [0,"A3\Air_F\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]}, _reward] call CBA_fnc_globalExecute;};
	_veh = [_reward, 600, 3600, 0, FALSE] execVM "vehicle.sqf";

	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedSideMission", sideMarkerText]; publicVariable "showNotification";
	showNotification = ["Reward", format["Your team received %1!", _vehName]]; publicVariable "showNotification";
};

_unitSpawnPlus = PARAMS_AOSize;
_unitSpawnMinus = _unitSpawnPlus - (_unitSpawnPlus * 2);

tin_aiGarrison = {
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
};

AW_fnc_spawnUnits = {

	private ["_randomPos","_spawnGroup","_pos","_x","_spawnLevel","_aaLevel","_serverPop"];
	_pos = getMarkerPos (_this select 0);
	_enemiesArray = [grpNull];
	_aiSkill = [0.3,0.3,0.3];
	if (PARAMS_AISkill == 1) then {_aiSkill = [0.3,0.4,0.3]};
	if (PARAMS_AISkill == 2) then {_aiSkill = [0.3,0.7,0.3]};

	_spawnLevel = 0;
	_aaLevel = 0;
	_serverPop = count(playableUnits);
	if (_serverPop >= 10) then {_spawnLevel = 1};
	if (_serverPop >= 25) then {_spawnLevel = 2};
	if (_serverPop >= 35) then {_spawnLevel = 3};

	if (_spawnLevel >= 2) then {_aaLevel = 1};

	_x = 0;
	for "_x" from 1 to _spawnLevel do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 50] call aw_fnc_spawn2_perimeterPatrol;

		{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

		_enemiesArray = _enemiesArray + [_spawnGroup];

		diag_log format["%1 Patrol Squad",_spawnGroup];
	};

	_x = 0;
	for "_x" from 0 to (_spawnLevel + 2) do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		[_spawnGroup, PARAMS_AOSize, _pos] call tin_aiGarrison;

		{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

		_enemiesArray = _enemiesArray + [_spawnGroup];

		diag_log format["%1 Defenders",_spawnGroup];
	};

	_x = 0;
	for "_x" from 0 to ((_spawnLevel + 2) * 2) do {
		_randomPos = [[[getMarkerPos currentAO, 20],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_spawn2_randomPatrol;		

		{_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}]} forEach (units _spawnGroup);

		_enemiesArray = _enemiesArray + [_spawnGroup];

		diag_log format["%1 Patrol Team",_spawnGroup];
	};

	_x = 0;
	for "_x" from 0 to _spawnLevel do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

		if(random 1 > 0.50) then {
			_angryGroup = ["O_APC_Tracked_02_cannon_F","O_MBT_02_cannon_F"];
			_spawnGroup	= (_angryGroup call BIS_fnc_selectRandom) createVehicle _randomPos;
			createVehicleCrew vehicle _spawnGroup;
		} else {
			_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		};

		[_spawnGroup, _pos, PARAMS_AOSize] call bis_fnc_taskPatrol;

		{
			_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}];
		} forEach (units _spawnGroup);

		_enemiesArray = _enemiesArray + [_spawnGroup];

		diag_log format["%1 Motor",_spawnGroup];
	};

	_x = 0;
	for "_x" from 0 to _spawnLevel do {

		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

		if(random 1 > 0.70) then {
			_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Armored" >> "OIA_TankSection"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		} else {
			_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Mechanized" >> "OIA_MechInf_AT"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
		};

		[_spawnGroup, _pos, PARAMS_AOSize] call bis_fnc_taskPatrol;

		{
			_x addEventHandler ["killed", {tin_fifo_bodies = tin_fifo_bodies + [_this select 0]}];
		} forEach (units _spawnGroup);

		_enemiesArray = _enemiesArray + [_spawnGroup];

		diag_log format["%1 Mech",_spawnGroup];
	};

	_x = 0;
	for "_x" from 0 to _aaLevel do {

		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;

		if(random 1 > 0.70) then {
			_spawnGroup	= "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			createVehicleCrew vehicle _spawnGroup;
		} else {
			_spawnGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA"),[],[],_aiSkill] call BIS_fnc_spawnGroup;
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
};

//Set time of day
skipTime PARAMS_TimeOfDay;

//Set weather
0 setWindForce random 1;
0 setWindDir random 360;
0 setGusts random 1;

switch (PARAMS_Weather) do
{
	case 1: {
		0 setOvercast 0;
		0 setRain 0;
		0 setFog 0;
	};

	case 2: {
		0 setOvercast 1;
		0 setRain 1;
		0 setFog 0.2;
		0 setGusts 1;
		0 setLightnings 1;
		0 setWaves 1;
		0 setWindForce 1;
	};

	case 3: {
		0 setOvercast 0.7;
		0 setRain 0;
		0 setFog 0;
		0 setGusts 0.7;
		0 setWaves 0.7;
		0 setWindForce 0.4;
	};

	case 4: {
		0 setOvercast 0.7;
		0 setRain 0;
		0 setFog 0.7;
	};
};

//Begin generating side missions
_null = [] execVM "sm\sideMissions.sqf";

//Priority Targets (dat artillery)
_null = [] execVM "sm\priorityTargets.sqf";

_firstTarget = true;
_lastTarget = "Nothing";

while {count _targets > 0} do
{
	sleep 10;

	//Set new current target and calculate targets left
	if (_isPerpetual) then
	{
		_validTarget = false;
		while {!_validTarget} do
		{
			if (count _initialTargets == count _targets) then {
				currentAO = _beginTargets call BIS_fnc_selectRandom;
				_validTarget = true;
			} else {
				currentAO = _targets call BIS_fnc_selectRandom;
				if (currentAO != _lastTarget) then
				{
					_validTarget = true;
				};

			};
		};
	} else {
		if (count _initialTargets == count _targets) then {
			currentAO = _beginTargets call BIS_fnc_selectRandom;
		} else {
			currentAO = _targets call BIS_fnc_selectRandom;
			_targetsLeft = count _targets;
		};
	};

	//Set currentAO for UAVs and JIP updates
	publicVariable "currentAO";
	currentAOUp = true;
	publicVariable "currentAOUp";

	//Edit and place markers for new target
	//_marker = [currentAO] call AW_fnc_markerActivate
	{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle","aoMarker"];
	"aoMarker" setMarkerText format["Take %1",currentAO];
	sleep 5;
	publicVariable "refreshMarkers";

	//Create AO detection trigger
	_dt = createTrigger ["EmptyDetector", getMarkerPos currentAO];
	_dt setTriggerArea [PARAMS_AOSize, PARAMS_AOSize, 0, false];
	_dt setTriggerActivation ["EAST", "PRESENT", false];
	_dt setTriggerStatements ["this","",""];

	//Spawn enemies
	_enemiesArray = [currentAO] call AW_fnc_spawnUnits;

	//Spawn radiotower
	_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];

	while {(count _flatPos) < 1} do
	{
		_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];
	};

	radioTower = "Land_TTowerBig_2_F" createVehicle _flatPos;
	waitUntil {sleep 0.5; alive radioTower};
	radioTower setVectorUp [0,0,1];
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos (getPos radioTower);

	//Spawn mines
	_chance = random 10;
	if (_chance < PARAMS_RadioTowerMineFieldChance) then
	{
		_mines = [_flatPos] call AW_fnc_minefield;
		_enemiesArray = _enemiesArray + _mines;
		"radioMineCircle" setMarkerPos (getPos radioTower);
		"radioMarker" setMarkerText "Radiotower (Minefield)";
	} else {
		"radioMarker" setMarkerText "Radiotower";
	};

	publicVariable "radioTower";

	//Set target start text
	_targetStartText = format
	[
		"<t align='center' size='2.2'>New Target</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>We did a good job with the last target, lads. I want to see the same again. Get yourselves over to %1 and take 'em all down!<br/><br/>Remember to take down that radio tower so you can use your Personal UAVs, too.",
		currentAO
	];

	if (!_isPerpetual) then
	{
		_targetStartText = format
		[
			"%1 Only %2 more targets to go!",
			_targetStartText,
			_targetsLeft
		];
	};

	//Show global target start hint
	GlobalHint = _targetStartText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["NewMain", currentAO]; publicVariable "showNotification";
	showNotification = ["NewSub", "Destroy the enemy radio tower."]; publicVariable "showNotification";


	/* =============================================== */
	/* ========= WAIT FOR TARGET COMPLETION ========== */
	waitUntil {sleep 5; count list _dt > PARAMS_EnemyLeftThreshhold};
	waitUntil {sleep 0.5; !alive radioTower};
	radioTowerAlive = false;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos [0,0,0];
	_radioTowerDownText =
		"<t align='center' size='2.2'>Radio Tower</t><br/><t size='1.5' color='#08b000' align='center'>DESTROYED</t><br/>____________________<br/>The enemy radio tower has been destroyed! Fantastic job, lads! You're now all free to use your Personal UAVs!<br/><br/>Keep up the good work, lads; we're countin' on you.";
	GlobalHint = _radioTowerDownText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedSub", "Enemy radio tower destroyed."]; publicVariable "showNotification";
	showNotification = ["Reward", "Personal UAVs now available."]; publicVariable "showNotification";

	waitUntil {sleep 5; count list _dt < PARAMS_EnemyLeftThreshhold};

	//Set enemy kill timer
	[_enemiesArray] spawn AW_fnc_deleteOldAOUnits;

	//Delete markers and trigger
	/* if (_isPerpetual) then
	{
		//_perimeterMarker = [currentAO] call AW_fnc_markerDeactivate;
		if (count _targets == 1) then
		{
			_targets = _initialTargets;
			_lastTarget = currentAO;
			publicVariable "refreshMarkers";
		} else {
			_targets = _targets - [currentAO];
		};
	} else {
		_targets = _targets - [currentAO];
		//deleteMarker currentAO;
	}; */

	if (_isPerpetual) then
	{
		_lastTarget = currentAO;
		if ((count (_targets)) == 1) then
		{
			_targets = _initialTargets;
		} else {
			_targets = _targets - [currentAO];
		};
	} else {
		_targets = _targets - [currentAO];
	};

	publicVariable "refreshMarkers";
	currentAOUp = false;
	publicVariable "currentAOUp";

	//Delete detection trigger and markers
	deleteVehicle _dt;
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";

	//Small sleep to let deletions process
	sleep 5;

	//Set target completion text
	_targetCompleteText = format
	[
		"<t align='center' size='2.2'>Target Taken</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/><t align='left'>Fantastic job taking %1, boys! Give us a moment here at HQ and we'll line up your next target for you.</t>",
		currentAO
	];

	{_x setMarkerPos [0,0,0];} forEach ["aoCircle","aoMarker","radioMineCircle"];

	//Show global target completion hint
	GlobalHint = _targetCompleteText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedMain", currentAO]; publicVariable "showNotification";
};

//Set completion text
_missionCompleteText = "<t align='center' size='2.0'>Congratulations!</t><br/>
<t size='1.2' align='center'>You've successfully completed Ahoy World Invade &amp; Annex!</t><br/>
____________________<br/>
<br/>
Thank you so much for playing and we hope to see you in the future. For more and to aid in the development of this mission, please visit www.AhoyWorld.co.uk.<br/>
<br/>
The game will return to the mission screen in 30 seconds. Consider turning Perpetual Mode on in the parameters to make the game play infinitely.";

//Show global mission completion hint
GlobalHint = _missionCompleteText;
publicVariable "GlobalHint";
hint parseText GlobalHint;

//Wait 30 seconds
sleep 30;

//End mission
endMission "END1";