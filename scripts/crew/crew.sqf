//init.sqf:   [] execvm "crew.sqf";
   
   
Private ["_name","_vehicle","_vehname","_weapname","_weap","_target","_picture","_vehtarget","_azimuth","_wepdir","_hudnames","_ui"];   
	   
disableSerialization;
  while {true} do  {

   	 1000 cutRsc ["HudNames","PLAIN"];
   	 _ui = uiNameSpace getVariable "HudNames";
 	 _HudNames = _ui displayCtrl 99999;

    
 
	   
    if(player != vehicle player) then {
        _name = "";
        _vehicle = assignedVehicle player;
        _vehname= getText (configFile >> "CfgVehicles" >> (typeOf vehicle player) >> "DisplayName");
        _weapname = getarray (configFile >> "CfgVehicles" >> typeOf (vehicle player) >> "Turrets" >> "MainTurret" >> "weapons"); 
        _weap = _weapname select 0;
        _name = format ["<t size='0.85' color='#FFCC00' shadow='1'>%1</t><br/>", _vehname];


					
        {
            if((driver _vehicle == _x) || (gunner _vehicle == _x)) then {
	                
                if(driver _vehicle == _x) then {

                    _name = format ["<t size='0.65' color='#FFFFFF' shadow='1'>%1 %2</t> <br/>", _name, (name _x)];
                }
                
                else
                {
	                _target = cursorTarget;
       				_picture = getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayname");
       				_vehtarget = format ["%1",_picture];
					_wepdir =  (vehicle player) weaponDirection _weap;
					_vehdir = getDir (vehicle player);
					_azimuth = round (((_wepdir select 0) ) atan2 ((_wepdir select 1) ) + 360) % 360;
					
					_clockBase = _vehdir - _azimuth;
					if (_clockBase > 360) then {_clockBase = (_clockBase mod 360)};
					if (_clockBase < 0) then {_clockBase = (_clockBase mod 360) + 360};
					
					_clockDir = 0;
					
					if (_clockBase > 345.5 || _clockBase < 15.5) then {_clockDir = 12};
					if (_clockBase > 315.5 && _clockBase < 345.5) then {_clockDir = 1};
					if (_clockBase > 285.5 && _clockBase < 315.5) then {_clockDir = 2};
					if (_clockBase > 255.5 && _clockBase < 285.5) then {_clockDir = 3};
					if (_clockBase > 225.5 && _clockBase < 255.5) then {_clockDir = 4};
					if (_clockBase > 195.5 && _clockBase < 225.5) then {_clockDir = 5};
					if (_clockBase > 165.5 && _clockBase < 195.5) then {_clockDir = 6};
					if (_clockBase > 135.5 && _clockBase < 165.5) then {_clockDir = 7};
					if (_clockBase > 105.5 && _clockBase < 135.5) then {_clockDir = 8};
					if (_clockBase > 75.5 && _clockBase < 105.5) then {_clockDir = 9};
					if (_clockBase > 45.5 && _clockBase < 75.5) then {_clockDir = 10};
					if (_clockBase > 15.5 && _clockBase < 45.5) then {_clockDir = 11};									
				
//					_name = format ["<t size='0.65' color='#FFFFFF' shadow='1'>%1 %2</t> <img size='0.65' color='#CCFF66' shadow='1' image='a3\ui_f\data\IGUI\Cfg\Actions\getingunner_ca.paa'/><br/> <t size='0.65' color='#FFFFFF'>Heading :<t/> <t size='0.65' color='#ff0000'>%3</t><br/><t size='0.65' color='#FFFFFF'> Target : </t><t size='0.65' color='#ff0000'>%4</t><br/>", _name, (name _x), _Azimuth, _vehtarget];
					_name = format ["<t size='0.65' color='#FFFFFF' shadow='1'>%1 %2</t> <br/> <t size='0.65' color='#FFFFFF'>Heading :<t/> <t size='0.65' color='#ff0000'>%3 o'clock</t><br/><t size='0.65' color='#FFFFFF'>", _name, (name _x), _clockDir];
                };
               
            }
            else
            {
				//_name = format ["<t size='0.65' color='#FFFFFF' shadow='1'>%1 %2</t> <img size='0.65' color='#CCFF66' shadow='1' image='a3\ui_f\data\IGUI\Cfg\Actions\getincargo_ca.paa'/><br/>", _name, (name _x)];
				_name = format ["<t size='0.65' color='#FFFFFF' shadow='1'>%1 %2</t> <br/>", _name, (name _x)];
            };  
              
        } forEach crew _vehicle;

      	_HudNames ctrlSetStructuredText parseText _name;
      	_HudNames ctrlCommit 0;
       	
       
    	};
    sleep 1;
  };  
  