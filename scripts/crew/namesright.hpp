

#define names_idc 99999

class HudNames {
	idd = -1;
    fadeout=0;
    fadein=0;
	duration = 10000000000;
	name= "HudNames";
	onLoad = "uiNamespace setVariable ['HudNames', _this select 0]";
	
	class controlsBackground {
		class HudNames_1:RscStructuredText {
			idc = names_idc;
			type = CT_STRUCTURED_TEXT;
			size = 0.040;
			x = (SafeZoneX + 2.2);
			y = (SafeZoneY + 0.60);
			w = 0.3; h = 0.5;
			colorText[] = {1,1,1,1};
			lineSpacing = 3;
			colorBackground[] = {0,0,0,0};
			text = "";
			font = "PuristaMedium";
			shadow = 2;
			class Attributes {
				align = "left";
			};
		};

	};
};