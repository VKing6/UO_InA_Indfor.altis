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