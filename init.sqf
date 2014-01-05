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

//create the Public Variable EventHandlers
aPEH = [] execVM "scripts\addPublicVariableEventHandlers.sqf";


/* =============================================== */
/* ================ PLAYER SCRIPTS =============== */
[player] execVM "scripts\crew\crew.sqf";
//0 = [] execVM 'group_manager.sqf';
_null = [] execVM "taw_vd\init.sqf";

if (isNil "radioTowerAlive") then {radioTowerAlive = false;};
if (isNil "sideMissionUp") then {sideMissionUp = false;};
if (isNil "currentAOUp") then {currentAOUp = false;};

call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";

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
	["an AH-9 Pawnee", "B_Heli_Light_01_armed_F"],
	["an MH-9 Hummingbird", "B_Heli_Light_01_F"],
	["an MH-9 Hummingbird", "B_Heli_Light_01_F"],
	["an MBT-52 Kuma", "I_MBT_03_cannon_F"],
	["an IFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F"],
	["an M4 Scorcher", "B_MBT_01_arty_F"],
	["an A-143 Buzzard", "I_Plane_Fighter_03_CAS_F"]
];
smMarkerList = ["smReward1","smReward2","smReward3","smReward4","smReward5","smReward6","smReward7","smReward8"];
smHangarList = ["smRewardP1","smRewardP2"];
smHeliList = ["smRewardH1","smRewardH2","smRewardH3","smRewardH4"];

activeAD = [];
adPositions = ["ada01","ada02","ada03","ada04","ada05","ada06","ada07","ada08","ada09","ada10","ada11","ada12","ada13","ada14","ada15","ada16","ada17","ada18","ada19","ada20","ada21","ada22","ada23","ada24","ada25"]; //,"adm01","adm02"

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

_unitSpawnPlus = PARAMS_AOSize;
_unitSpawnMinus = _unitSpawnPlus - (_unitSpawnPlus * 2);

//Compile all functions.
call compile (preprocessFileLineNumbers "func\compile.sqf");

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