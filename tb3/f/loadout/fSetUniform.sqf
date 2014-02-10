private ["_unit", "_uniform", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	// first get naked
	removeUniform _unit;

	// and now put some clothes on, you hippie!
	_uniform = _this select 1;

	_unit addUniform _uniform;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
