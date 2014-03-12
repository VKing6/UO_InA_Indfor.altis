// by BonInf*
// changed by psycho
private["_dragee","_dragger"];
_dragger = _this select 1;
_dragee	= _this select 3;

detach _dragger;
detach _dragee;

_dragee setVariable ["dragger", ObjNull, true];
["lynx_aisPlayMove",[_dragee,"AinjPpneMstpSnonWrflDb_release"]] call CBA_fnc_globalEvent;
["lynx_aisPlayMove",[_dragger,"amovpknlmstpsraswrfldnon"]] call CBA_fnc_globalEvent;

//_dragee playMove "AinjPpneMstpSnonWrflDb_release";
//_dragger playMove "amovpknlmstpsraswrfldnon"; //_dragger playAction "released";

if (!isNil {_dragger getVariable "drop_action"}) then {
	_dragger removeAction (_dragger getVariable "drop_action");
	_dragger setVariable ["drop_action",nil];
};
if (!isNil {_dragger getVariable "carry_action"}) then {
	_dragger removeAction (_dragger getVariable "carry_action");
	_dragger setVariable ["carry_action",nil];
};