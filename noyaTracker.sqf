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
			_freq = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency;
			_markerRadioText = format ["%1 - 단파[%2 Hz]",groupId(group _x), _freq];
			ny_freqs pushBack _markerRadioText;
		};
	} forEach _humanPlayers;

	{
		radioMarkerPos = radioMarkerPos + 100;
		_markerRadioId = format ["SystemMarker_NY_radio_%1",groupId(group _x)];
		_markerRadio = createMarker [_markerRadioId, [10,radioMarkerPos,0]]; 
		_markerRadio setMarkerShape "ICON"; 
		_markerRadio setMarkerType "mil_dot";
		_markerRadio setMarkerText _x;
		_markerRadio setMarkerColor "ColorBlack";
	} forEach (ny_freqs arrayIntersect ny_freqs);
};