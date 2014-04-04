//Written by beta and Krause
//AI can hear you talk on ACRE
//Modified for ARMA3 by TinfoilHate
//version 2

	if (isDedicated) exitWith { };

	private ["_nearAI", "_revealAmount", "_sideUnit", "_nearAISingle", "_sideAI", "_sideUnits", "_inContact", "_enemyInContact", "_talkTime", "_dist"];

	_talkTime = 0;

	b_hasRadioCheck = {
		private ["_nearAISingle"];

		_nearAISingle = _this select 0;

		([weapons _nearAISingle, "ACRE_PRC117F"] call acre_api_fnc_hasKindOfRadio) || ([weapons _nearAISingle, "ACRE_PRC119"] call acre_api_fnc_hasKindOfRadio) || ([weapons _nearAISingle, "ACRE_PRC148"] call acre_api_fnc_hasKindOfRadio)
	};

	lynx_revealToAI = {(_this select 0) reveal (_this select 1)};

	[{
		if ((player getVariable "acre_sys_core_isSpeaking") == 1) then
		{
			_talkTime = _talkTime + 0.25;

			if (_talkTime >= 1.0) then
			{
				_dist = 40;
				switch (stacre_VolumeLevel) do
				{
					case -2: 	{_dist = 5;};
					case -1: 	{_dist = 10;};
					case 0: 	{_dist = 40;};
					case 1: 	{_dist = 60;};
					case 2: 	{_dist = 80;};
				};

				_nearAI = nearestObjects [player, ["Man"], _dist];
				_nearAI = _nearAI - [playableUnits];

				{
					if ((alive _x) && (_x knowsAbout player < 1.0) && !(_x knowsAbout player >= 4.0)) then
					{
						_nearAISingle = _x;
						_sideAI = side _nearAISingle;
						_sideUnits = [];
						_inContact = false;

						//AI hears talking
						_revealAmount = 1.0;

						//Command and control checks
						if ([_nearAISingle] call b_hasRadioCheck) then {
							_revealAmount = _revealAmount + 1.0;
							//AI has a radio
							{
								if ((side _x == _sideAI) && !(isplayer _x)) then {
									_sideUnits = _sideUnits + [_x];
								};
							}
							foreach allunits;

							{
								_sideUnit = _x;
								{
									if ((_sideUnit knowsAbout _x > 2) && ([_nearAISingle] call b_hasRadioCheck)) exitWith {
										_inContact = true;
										_revealAmount = _revealAmount + 1.0;
										//AI has radio link to other troops in contact
									};

								}
								foreach playableunits;
							}
							foreach _sideUnits;


						};

						if (!isNull ((leader (group _nearAISingle)) findNearestEnemy (getPos leader (group _nearAISingle)))) then {

							_enemyInContact = (leader (group _nearAISingle)) findNearestEnemy (getPos leader (group _nearAISingle));

							if (_enemyInContact distance _nearAISingle < 2000) then {
								_revealAmount = _revealAmount + 1.0;
								//AI is already in contact with enemy
							};
						};

						[[_nearAISingle, [player, _revealAmount]],"lynx_revealToAI",false,false] spawn BIS_fnc_MP;
					};
				} forEach _nearAI;
			};
		}
		else
		{
			if (_talkTime > 0) then { _talkTime = 0; };
		};
	}, 0.25] call cba_fnc_addPerFrameHandler;