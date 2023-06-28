while{true} do {

	sleep 10;
	radioMarkerPos = 0;
	
	{
		if ("SystemMarker_NY_" in _x) then {
			deleteMarker _x;
		}
	} forEach allMapMarkers;
	
	_headlessClients = entities "HeadlessClient_F";
	_humanPlayers = allPlayers - _headlessClients;
	ny_freqs = [];
	ny_gears = [];

	{
		_isLeader = (_x == leader  _x);
		if(_isLeader) then {
			//분대 위치 추척
			_markerId = format ["SystemMarker_NY_squad_%1",groupId(group _x)];
			_marker = createMarker [_markerId, _x]; 
			_marker setMarkerShape "ICON"; 
			_marker setMarkerType "b_inf";
			_marker setMarkerText groupId(group _x);
			
			if(side _x == west) then {
				_marker setMarkerColor "colorBLUFOR";
			} else {
				_marker setMarkerColor "colorOPFOR";
			};
			
			//분대 무전 표시
			_freq = (assignedItems _x select { _x find "TFAR_anprc" == 0}) call TFAR_fnc_getSwFrequency;
			if(_freq != "any") then {
				_markerRadioText = format ["%1 - 단파[%2 Hz]",groupId(group _x), _freq];
				ny_freqs pushBack _markerRadioText;
			};

			//분대 장비 표시
			_uniform = uniform player;  
			_helmet = headgear player;  
			_vest = vest player;  
			_weapon = primaryWeapon player; 

			ny_gears pushBack ( format ["유니폼 : %1" 	, getText (configFile >> "CfgWeapons" >> _uniform >> "displayName")]);  
			ny_gears pushBack ( format ["조끼 : %1" 	, getText (configFile >> "CfgWeapons" >> _vest >> 	 "displayName")]);  
			ny_gears pushBack ( format ["헬멧 : %1" 	, getText (configFile >> "CfgWeapons" >> _helmet >>  "displayName")]);  
			ny_gears pushBack ( format ["주무기 : %1" 	, getText (configFile >> "CfgWeapons" >> _weapon >>  "displayName")]);  
		};
	} forEach _humanPlayers;

	ny_freqs = ny_freqs arrayIntersect ny_freqs;
	ny_freqs sort false;

	{
		radioMarkerPos = radioMarkerPos + 1000;
		_markerRadioId = format ["SystemMarker_NY_radio_%1",_x];
		_markerRadio = createMarker [_markerRadioId, [10,radioMarkerPos,0]]; 
		_markerRadio setMarkerShape "ICON"; 
		_markerRadio setMarkerType "mil_dot";
		_markerRadio setMarkerText _x;
		_markerRadio setMarkerColor "ColorBlack";
	} forEach ny_freqs;

	radioMarkerPos = 0;
	{
		radioMarkerPos = radioMarkerPos + 1000;
		_markerRadioId = format ["SystemMarker_NY_radio_%1",_x];
		_markerRadio = createMarker [_markerRadioId, [10000,radioMarkerPos,0]]; 
		_markerRadio setMarkerShape "ICON"; 
		_markerRadio setMarkerType "mil_dot";
		_markerRadio setMarkerText _x;
		_markerRadio setMarkerColor "ColorBlack";
	} forEach ny_gears;
};