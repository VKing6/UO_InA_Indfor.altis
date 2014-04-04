// by psycho - dont edit!
_unit = _this select 0;

if (isDedicated && {isPlayer _unit}) exitWith {};				// no player unit controlled on a dedicated server
if (!isDedicated && {!hasInterface}) exitWith {};				// no headless client
if (isNil "_unit") exitWith {};
if (!isNil {_unit getVariable "tcb_ais_aisInit"}) exitWith {};	// prevent that a unit run the init twice
_unit setVariable ["tcb_ais_aisInit",true];
#include "ais_setup.sqf"

lynx_aisDrag = {
	private ["_injured","_helper"];

	_injured 	= _this select 0;
	_helper 	= _this select 1;

	if (local _injured) then {
		_injured setVariable ["dragger",_helper,true];
		_injured attachTo [_helper, [0, 1, 0.08]];
		_injured setDir 180;
	};
};

lynx_aisFirstAid = {
	private ["_injured","_helper","_dir","_offset"];

	_injured 	= _this select 0;
	_helper 	= _this select 1;
	_dir		= _this select 2;
	_offset 	= _this select 3;

	if (local _injured) then {
		_injured attachTo [_helper,_offset];
		_injured setDir _dir;
	};
};

lynx_aisSwitchMove = {
	private ["_unit","_move"];

	_unit 	= _this select 0;
	_move	= _this select 1;
	
	if (local _unit) then {_unit switchMove _move};
};

lynx_aisPlayMove = {
	private ["_unit","_move"];

	_unit 	= _this select 0;
	_move	= _this select 1;
	
	if (local _unit) then {_unit playMoveNow _move};
};

lynx_aisPlayAction = {
	private ["_unit","_action"];

	_unit 	= _this select 0;
	_action = _this select 1;
	
	if (local _unit) then {_unit playAction _action};
};

lynx_aisPlayActionNow = {
	private ["_unit","_action"];

	_unit 	= _this select 0;
	_action = _this select 1;
	
	if (local _unit) then {_unit playActionNow _action};
};

["lynx_aisDrag", lynx_aisDrag] call CBA_fnc_addEventHandler;
["lynx_aisFirstAid", lynx_aisFirstAid] call CBA_fnc_addEventHandler;
["lynx_aisSwitchMove", lynx_aisSwitchMove] call CBA_fnc_addEventHandler;
["lynx_aisPlayMove", lynx_aisPlayMove] call CBA_fnc_addEventHandler;
["lynx_aisPlayAction", lynx_aisPlayAction] call CBA_fnc_addEventHandler;
["lynx_aisPlayActionNow", lynx_aisPlayActionNow] call CBA_fnc_addEventHandler;
//Raise event: ["lynx_aisFirstAid",[_injured,_helper]] call CBA_fnc_globalEvent;

"tcb_ais_in_agony" addPublicVariableEventHandler {
	_unit = (_this select 1) select 0;
	_in_agony = (_this select 1) select 1;
	_side = _unit getVariable "tcb_ais_side";

	if (playerSide == _side) then {
		if (_in_agony) then {
			_unit playActionNow "agonyStart";
			_fa_action = _unit addAction [format["<t color='#F00000'>First Aid to %1</t>",name _unit],{_this spawn tcb_fnc_firstAid},_unit,100,false,true,"",
				"{not isNull (_target getVariable _x)} count ['healer','dragger'] == 0 && {alive _target} && {vehicle _target == _target}
			"];
			_drag_action = _unit addAction [format["<t color='#FC9512'>Drag %1</t>",name _unit],{_this spawn tcb_fnc_drag},_unit,99,false,true,"",
				"{not isNull (_target getVariable _x)} count ['healer','dragger'] == 0 && {alive _target} && {vehicle _target == _target}
			"];
			_unit setVariable ["fa_action", _fa_action];
			_unit setVariable ["drag_action", _drag_action];
			[_unit] execFSM (TCB_AIS_PATH+"fsm\ais_marker.fsm");
		} else {
			_unit playActionNow "agonyStop";
			_unit removeAction (_unit getVariable "fa_action");
			_unit removeAction (_unit getVariable "drag_action");
			_unit setVariable ["fa_action", nil];
			_unit setVariable ["drag_action", nil];
		};
	};
};

tcb_healerStopped = false;
_unit setVariable ["unit_is_unconscious", false];
_unit setVariable ["tcb_ais_headhit", 0];
_unit setVariable ["tcb_ais_handshit", 0];
_unit setVariable ["tcb_ais_bodyhit", 0];
_unit setVariable ["tcb_ais_legshit", 0];
_unit setVariable ["tcb_ais_overall", 0];
_unit setVariable ["tcb_ais_unit_died", false];
_unit setVariable ["tcb_ais_leader", false];
_unit setVariable ["tcb_ais_fall_in_agony_time_delay", 999999];

if (tcb_ais_show_3d_icons == 1) then {
	_icons = addMissionEventHandler ["Draw3D", {
		{
			if ((_x distance player) < 30 && {_x getVariable "tcb_ais_agony"}) then {
				drawIcon3D ["a3\ui_f\data\map\MapControl\hospital_ca.paa", [0.6,0.15,0,0.8], _x, 0.5, 0.5, 0, format["%1 (%2m)", name _x, ceil (player distance _x)], 0, 0.02];
			};
		} forEach playableUnits;
	}];
};

if (tcb_ais_delTime > 0) then {
	_unit AddEventHandler ["killed",{[_this select 0, tcb_ais_delTime] spawn tcb_fnc_delbody}];
};

_timeend = time + 2;
waitUntil {!isNil {_unit getVariable "BIS_fnc_feedback_hitArrayHandler"} || {time > _timeend}};	// work around to ensure this EH is the last one that was added
["%1 --- adding wounding handleDamage eventhandler first time",diag_ticktime] call BIS_fnc_logFormat;
_unit addEventHandler ["HandleDamage", {_this call tcb_fnc_handleDamage}];

[_unit] execFSM (TCB_AIS_PATH+"fsm\ais.fsm");

if (isPlayer _unit) then {
	waitUntil {sleep 0.3; !isNull (findDisplay 46)};
	(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call tcb_fnc_keyUnbind"];
};

if (tcb_ais_dead_dialog == 1) then {
	if (isNil "respawndelay") then {
		_num = getNumber (missionConfigFile/"respawndelay");
		if (_num != 0) then {
			missionNamespace setVariable ["tcb_ais_respawndelay", _num];
		};
	} else {
		missionNamespace setVariable ["tcb_ais_respawndelay", 999];
	};

	tcb_ais_killcam_quotes = [
		[(localize "STR_QUOTE_1"),(localize "STR_AUTHOR_1")],
		[(localize "STR_QUOTE_2"),(localize "STR_AUTHOR_2")],
		[(localize "STR_QUOTE_3"),(localize "STR_AUTHOR_3")],
		[(localize "STR_QUOTE_4"),(localize "STR_AUTHOR_4")],
		[(localize "STR_QUOTE_5"),(localize "STR_AUTHOR_5")],
		[(localize "STR_QUOTE_6"),(localize "STR_AUTHOR_6")],
		[(localize "STR_QUOTE_7"),(localize "STR_AUTHOR_7")],
		[(localize "STR_QUOTE_8"),(localize "STR_AUTHOR_8")],
		[(localize "STR_QUOTE_9"),(localize "STR_AUTHOR_9")],
		[(localize "STR_QUOTE_10"),(localize "STR_AUTHOR_10")],
		[(localize "STR_QUOTE_11"),(localize "STR_AUTHOR_11")],
		[(localize "STR_QUOTE_12"),(localize "STR_AUTHOR_12")],
		[(localize "STR_QUOTE_13"),(localize "STR_AUTHOR_13")],
		[(localize "STR_QUOTE_14"),(localize "STR_AUTHOR_14")],
		[(localize "STR_QUOTE_15"),(localize "STR_AUTHOR_15")],
		[(localize "STR_QUOTE_16"),(localize "STR_AUTHOR_16")],
		[(localize "STR_QUOTE_17"),(localize "STR_AUTHOR_17")],
		[(localize "STR_QUOTE_18"),(localize "STR_AUTHOR_18")],
		[(localize "STR_QUOTE_19"),(localize "STR_AUTHOR_19")],
		[(localize "STR_QUOTE_20"),(localize "STR_AUTHOR_20")],
		[(localize "STR_QUOTE_21"),(localize "STR_AUTHOR_21")],
		[(localize "STR_QUOTE_22"),(localize "STR_AUTHOR_22")],
		[(localize "STR_QUOTE_23"),(localize "STR_AUTHOR_23")],
		[(localize "STR_QUOTE_24"),(localize "STR_AUTHOR_24")],
		[(localize "STR_QUOTE_25"),(localize "STR_AUTHOR_25")],
		[(localize "STR_QUOTE_26"),(localize "STR_AUTHOR_26")],
		[(localize "STR_QUOTE_27"),(localize "STR_AUTHOR_27")],
		[(localize "STR_QUOTE_28"),(localize "STR_AUTHOR_28")],
		[(localize "STR_QUOTE_29"),(localize "STR_AUTHOR_29")],
		[(localize "STR_QUOTE_30"),(localize "STR_AUTHOR_30")],
		[(localize "STR_QUOTE_31"),(localize "STR_AUTHOR_31")],
		[(localize "STR_QUOTE_32"),(localize "STR_AUTHOR_32")],
		[(localize "STR_QUOTE_33"),(localize "STR_AUTHOR_33")],
		[(localize "STR_QUOTE_34"),(localize "STR_AUTHOR_34")],
		[(localize "STR_QUOTE_35"),(localize "STR_AUTHOR_35")],
		[(localize "STR_QUOTE_36"),(localize "STR_AUTHOR_36")],
		[(localize "STR_QUOTE_37"),(localize "STR_AUTHOR_37")],
		[(localize "STR_QUOTE_38"),(localize "STR_AUTHOR_38")],
		[(localize "STR_QUOTE_39"),(localize "STR_AUTHOR_39")],
		[(localize "STR_QUOTE_40"),(localize "STR_AUTHOR_40")],
		[(localize "STR_QUOTE_41"),(localize "STR_AUTHOR_41")],
		[(localize "STR_QUOTE_42"),(localize "STR_AUTHOR_42")],
		[(localize "STR_QUOTE_LAST"),(localize "STR_AUTHOR_LAST")]
	];

	if (_unit == player) then {
		_unit AddEventHandler ["killed",{_this spawn tcb_fnc_deadcam}];
	};
};