private ["_veh","_vehName","_vehType","_vehVarname","_completeText","_reward","_dir"];
	_veh = smRewards call BIS_fnc_selectRandom;
	_vehName = _veh select 0;
	_vehVarname = _veh select 1;
	_rewardPos = "";

	_completeText = format[
	"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>We've given you %1 to help with the fight. You'll find it at base.<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>",_vehName];
	
	//I need dis \0/
	if ((_vehVarname isKindOf "plane") && (_vehVarname isKindOf "UAV")) then { _vehType = "UAV"; };
	if ((_vehVarname isKindOf "plane") && !(_vehVarname isKindOf "UAV")) then { _vehType = "Plane"; };
	if ((_vehVarname isKindOf "helicopter")) then {	 _vehType = "Helicopter"; };
	if (!(_vehVarname isKindOf "Plane") && !(_vehVarname isKindOf "Helicopter")) then { _vehType = "Ground"; };
	
	//makes dis tidier!
	if ((_vehType = "Plane") && count smHangarList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};
	if ((_vehType = "UAV") && count smUAVList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};
	if ((_vehType = "Helicopter") && count smHeliList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};
	if ((_vehType = "Ground") && count smMarkerList == 0) exitWith {[-1, {"All reward locations full! No reward given."}] call CBA_fnc_globalExecute};

	//switch-a-roo
	switch (_vehType) do {
		case "Plane" : {
			_rewardPos = smHangarList select 0;
			smHangarList = smHangarList - [_rewardPos];
			_dir = 121;
		};
		case "UAV" : {
			_rewardPos = smUAVList select 0;
			smHangarList = smUAVList - [_rewardPos];
			_dir = 120
		};
		case "Helicopter" : {
			_rewardPos = smHeliList select 0;
			smHeliList = smHeliList - [_rewardPos];
			_dir = 305;
		};
		case "Ground" : {
			_rewardPos = smMarkerList select 0;
			smMarkerList = smMarkerList - [_rewardPos];
			_dir = 38;
		};
	};

	_reward = createVehicle [_vehVarname, getMarkerPos _rewardPos,[],0,"NONE"];
	waitUntil {alive _reward};
	if ((_reward isKindOf "UGV_01_base_F") || (_reward isKindOf "UGV_01_rcws_base_F") || (_reward isKindOf "UAV_02_base_F")) then {createVehicleCrew _reward};
	_reward setDir _dir;
	_reward setPosATL [(getPosATL _reward select 0),(getPosATL _reward select 1),0.5];
	_rewardName = "reward_" + str(floor random 500000);
	_reward SetVehicleVarName _rewardName;

	if (_reward isKindOf "Heli_Light_01_base_F") then {[-1, {_this setObjectTexture [0,"\A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]}, _reward] call CBA_fnc_globalExecute;};//littlebird tex
	if (_reward isKindOf "Heli_Light_02_base_F") then {[-1, {_this setObjectTexture [0,"A3\Air_F\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]}, _reward] call CBA_fnc_globalExecute;};//orca tex
	_veh = [_reward, 600, 3600, 0, FALSE] execVM "vehicle.sqf";

	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedSideMission", sideMarkerText]; publicVariable "showNotification";
	showNotification = ["Reward", format["Your team received %1!", _vehName]]; publicVariable "showNotification";