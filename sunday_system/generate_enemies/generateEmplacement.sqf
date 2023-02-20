params ["_AOIndex"];

if (count (((AOLocations select _AOIndex) select 2) select 4) > 0) then {	
	_pos = [(((AOLocations select _AOIndex) select 2) select 4)] call sun_selectRemove; 
	_objects = (selectRandom compositionsEmplacements);	
	_spawnedObjects = [_pos, random 360, _objects] call BIS_fnc_ObjectsMapper;
	
	_numInf = [3,5] call BIS_fnc_randomInt;
	_dirMod = 360 / _numInf;
	_direction = (random 360);	
	_leader = nil;
	_leaderChosen = false;	
	for "_i" from 1 to _numInf step 1 do {	
		_spawnPos = [_pos, (5 + random 2), _direction] call dro_extendPos;		
		_dirOut = [_pos, _spawnPos] call BIS_fnc_dirTo;
		_direction = _direction + _dirMod;		
		_minAI = round (1 * aiMultiplier);
		_maxAI = round (2 * aiMultiplier);
		_guardGroup = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;
		waitUntil {!isNil "_guardGroup"};
		_guardUnit = ((units _guardGroup) select 0);					
		_guardUnit setFormDir _dirOut;
		_guardUnit setDir _dirOut;				
		if (!_leaderChosen) then {
			_leader = _guardUnit;
			_leaderChosen = true;
		} else {
			[_guardUnit] joinSilent _leader;
			doStop _guardUnit;
		};
		if (random 1 > 0.6) then {
			[_guardUnit, (selectRandom ["STAND", "STAND_IA", "KNEEL", "WATCH", "WATCH1", "WATCH2"]), "ASIS"] call BIS_fnc_ambientAnimCombat;
		};
	};

	if (count eStaticClasses > 0) then {
		if ((random 1) > 0.4) then {
			_turretClass = selectRandom eStaticClasses;
			_turretPos = _pos findEmptyPosition [5, 20, _turretClass];
			if (count _turretPos > 0) then {
				_turret = _turretClass createVehicle _turretPos;
				[_turret] call sun_createVehicleCrew;
				//createVehicleCrew _turret;
			};
		} else {
			if ((random 1) > 0.75) then {
				_mortarClass = selectRandom eMortarClasses;
				_mortarPos = _pos findEmptyPosition [5, 20, _mortarClass];
				if (count _mortarPos > 0) then {
					_mortar = _mortarClass createVehicle _mortarPos;
					[_mortar] call sun_createVehicleCrew;
					//createVehicleCrew _turret;
				};
			};
		};
	};

	// Create Marker
	_markerName = format["emplaceMkr%1", floor(random 10000)];
	_markerEmplace = createMarker [_markerName, _pos];			
	_markerEmplace setMarkerShape "ICON";
	_markerEmplace setMarkerType "hd_warning";
	_markerEmplace setMarkerText "Emplacement";
	_markerEmplace setMarkerColor markerColorEnemy;
	_markerEmplace setMarkerAlpha 0.6;
	enemyIntelMarkers pushBack _markerEmplace;		
	travelPosPOIMil pushBack _pos;
};