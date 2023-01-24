params ["_unit", ["_customClasses", civClasses], ["_allowGroup", false]];

if (!(hostileCivsEnabled)) exitWith {diag_log "Hostile Civilians are not enabled!"};

//detect gear-specific addons
_IFA3_partisan = ((configfile >> "CfgMods" >> "IF") call BIS_fnc_getCfgIsClass);
_IFA3weapons = ["LIB_K98","LIB_P38","LIB_M9130","LIB_TT33","LIB_LeeEnfield_No1","LIB_Colt_M1911","LIB_LeeEnfield_No4","LIB_Webley_mk6"];

//define hciv gear
diag_log DRO_C_HWearables;
diag_log DRO_C_VWearables;

_goggles = ["G_Balaclava_blk","G_Balaclava_oli","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_tan"];

_switchToHostile = {
	params ["_unit"];
	
	// Make hostile
	hostileCivilians pushBack _unit;
	{
		removeHeadgear _x;
		if (random 1 > 0.4) then {
			_x addHeadgear (selectRandom DRO_C_HWearables);
			_x addVest (selectRandom DRO_C_VWearables);
		};
		_x addMagazines ["10Rnd_9x21_Mag", 3];
		_x addItemToUniform "hgun_Pistol_01_F";
		_x removeAllMPEventHandlers "mpkilled"; 
	} forEach (units group _unit);	
	[_unit] spawn {
		_unit = (_this select 0);
		while {alive _unit && (side _unit == civilian)} do {
			sleep 10;
			// Check for nearby player units
			_radius = if (isNull (_unit getVariable ["attachedIED", objNull])) then {30} else {70};
			_entities = _unit nearEntities _radius;
			_targets = [];
			{
				if (side _x == playersSide) then {
					_targets pushBack _x;
				};
			} forEach _entities;
			if (count _targets > 0) then {
				while {(count (waypoints (group _unit))) > 0} do {
					deleteWaypoint ((waypoints (group _unit)) select 0);
				};	
				_unit doWatch (selectRandom _targets);
				// Activate any nearby hostile civilians
				{
					if (_x != _unit) then {
						if (_x distance _unit < 70) then {
							while {(count (waypoints (group _x))) > 0} do {
								deleteWaypoint ((waypoints (group _x)) select 0);
							};	
							_x doWatch (selectRandom _targets);
							sleep (random [10, 15, 20]);
							_group = createGroup enemySide;					
							(units group _x) joinSilent _group;							
							{
								_x remoteExec ["removeAllActions", 0, true];
								_x removeItemFromUniform "hgun_Pistol_01_F";
								if (random 1 > 0.65) then {
									if (random 1 > 0.65) then {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["30Rnd_545x39_Mag_F", 3]; 
										_x addWeapon "arifle_AKS_F";
									} else {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["30Rnd_762x39_Mag_F", 3]; 
										_x addWeapon "arifle_AKM_F";
									};
								} else {
									if (random 1 > 0.35) then {
										_x addWeapon "hgun_Pistol_01_F";
									} else {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["2Rnd_12Gauge_Pellets", 3];
										_x addWeapon (selectRandom ["sgun_HunterShotgun_01_sawedoff_F","sgun_HunterShotgun_01_F"]);
									};
								};
								if (_IFA3_partisan) then {
									removeAllWeapons _x;
									_sIFA3Weapon = (selectRandom _IFA3weapons);
									_mag = (getArray (configFile >> "CfgWeapons" >> _sIFA3Weapon >> "magazines")) select 0;
									for "_i" from 2 to (random 4) do {_this addMagazines _mag};
									_this addWeapon _sIFA3Weapon;
								};
								if (random 1 > 0.5) then {_x addGoggles (selectRandom _goggles)};
							} forEach (units group _x);
							[group _x, getPos (selectRandom _targets)] call BIS_fnc_taskAttack;
						};
					};
				} forEach hostileCivilians;	
				diag_log format ["DRO: attachedIED = %1", (_unit getVariable ["attachedIED", objNull])];
				//if (isNull (_unit getVariable ["attachedIED", objNull])) then {
					sleep (random [10, 15, 20]);
				//};
				_group = createGroup enemySide;					
				(units group _unit) joinSilent _group;				
				{
					_x remoteExec ["removeAllActions", 0, true];
					_x removeItemFromUniform "hgun_Pistol_01_F";
					if (random 1 > 0.65) then {
						if (random 1 > 0.65) then {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["30Rnd_545x39_Mag_F", 3]; 
							_x addWeapon "arifle_AKS_F";
						} else {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["30Rnd_762x39_Mag_F", 3]; 
							_x addWeapon "arifle_AKM_F";
						};
					} else {
						if (random 1 > 0.35) then {
							_x addWeapon "hgun_Pistol_01_F";
						} else {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["2Rnd_12Gauge_Pellets", 3];
							_x addWeapon (selectRandom ["sgun_HunterShotgun_01_sawedoff_F","sgun_HunterShotgun_01_F"]);
						};
					};
					if (_IFA3_partisan) then {
						removeAllWeapons _x;
						_sIFA3Weapon = (selectRandom _IFA3weapons);
						_mag = (getArray (configFile >> "CfgWeapons" >> _sIFA3Weapon >> "magazines")) select 0;
						for "_i" from 2 to (random 4) do {_this addMagazines _mag};
						_this addWeapon _sIFA3Weapon;
					};
					if ((count headgear _x) == 0 && (random 1 > 0.5)) then {
						_x addHeadgear (selectRandom DRO_C_HWearables);
					};
					if (random 1 > 0.5) then {_x addGoggles (selectRandom _goggles)};
				} forEach (units group _unit);
				if (!isNull (_unit getVariable ["attachedIED", objNull])) then {
					[_unit] spawn {
						params ["_unit"];
						sleep (random [8, 10, 12]);
						if (alive _unit) then {
							(_unit getVariable ["attachedIED", objNull]) setDamage 1;
						};
					};
				};
			};					
		};
	};	
};

_switchToAmbush = {
	params ["_unit"];
	
	hostileCivilians pushBack _unit;
	{
		removeHeadgear _x;
		if (random 1 > 0.3) then {
			_x addHeadgear (selectRandom DRO_C_HWearables);
			_x addVest (selectRandom DRO_C_VWearables);
		};
		_x addMagazines ["10Rnd_9x21_Mag", 3];
		_x addItemToUniform "hgun_Pistol_01_F";
		_x removeAllMPEventHandlers "mpkilled";		
	} forEach (units group _unit);
		
	[_unit] spawn {
		_unit = (_this select 0);
		while {alive _unit && (side _unit == civilian)} do {
			sleep 10;
			// Check for nearby player units
			_entities = _unit nearEntities 50;
			_targets = [];
			{
				if (side _x == playersSide) then {
					_targets pushBack _x;
				};
			} forEach _entities;
			if (count _targets > 0) then {				
				_unit doWatch (selectRandom _targets);						
				// Activate any nearby hostile civilians
				{
					if (_x != _unit) then {
						if (_x distance _unit < 70) then {
							while {(count (waypoints (group _x))) > 0} do {
								deleteWaypoint ((waypoints (group _x)) select 0);
							};
							
							{
								_pos = [[[(getPos (selectRandom _targets)), 10]], ["water"]] call BIS_fnc_randomPos;
								_x doMove _pos;
							} forEach (units group _x);
							
							sleep (random [10, 10, 20]);
							_group = createGroup enemySide;					
							(units group _x) joinSilent _group;
							{
								_x remoteExec ["removeAllActions", 0, true];
								_x removeItemFromUniform "hgun_Pistol_01_F";
								if (random 1 > 0.65) then {
									if (random 1 > 0.65) then {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["30Rnd_545x39_Mag_F", 3]; 
										_x addWeapon "arifle_AKS_F";
									} else {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["30Rnd_762x39_Mag_F", 3]; 
										_x addWeapon "arifle_AKM_F";
									};
								} else {
									if (random 1 > 0.35) then {
										_x addWeapon "hgun_Pistol_01_F";
									} else {
										_x removeMagazines "10Rnd_9x21_Mag";
										_x addMagazines ["2Rnd_12Gauge_Pellets", 3];
										_x addWeapon (selectRandom ["sgun_HunterShotgun_01_sawedoff_F","sgun_HunterShotgun_01_F"]);
									};
								};
								if (_IFA3_partisan) then {
									removeAllWeapons _x;
									_sIFA3Weapon = (selectRandom _IFA3weapons);
									_mag = (getArray (configFile >> "CfgWeapons" >> _sIFA3Weapon >> "magazines")) select 0;
									for "_i" from 2 to (random 4) do {_this addMagazines _mag};
									_this addWeapon _sIFA3Weapon;
								};
								if ((count headgear _x) == 0 && (random 1 > 0.5)) then {
									_x addHeadgear (selectRandom DRO_C_HWearables);
								};
								if (random 1 > 0.5) then {_x addGoggles (selectRandom _goggles)};
							} forEach (units group _x);
							[group _x, getPos (selectRandom _targets)] call BIS_fnc_taskAttack;							
						};
					};
				} forEach hostileCivilians;	
				
				{
					_pos = [[[(getPos (selectRandom _targets)), 10]], ["water"]] call BIS_fnc_randomPos;
					_x doMove _pos;
				} forEach (units group _unit);				
				sleep (random [10, 10, 20]);
				
				_group = createGroup enemySide;					
				(units group _unit) joinSilent _group;
				{
					_x remoteExec ["removeAllActions", 0, true];
					_x removeItemFromUniform "hgun_Pistol_01_F";
					if (random 1 > 0.65) then {
						if (random 1 > 0.65) then {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["30Rnd_545x39_Mag_F", 3]; 
							_x addWeapon "arifle_AKS_F";
						} else {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["30Rnd_762x39_Mag_F", 3]; 
							_x addWeapon "arifle_AKM_F";
						};
					} else {
						if (random 1 > 0.35) then {
							_x addWeapon "hgun_Pistol_01_F";
						} else {
							_x removeMagazines "10Rnd_9x21_Mag";
							_x addMagazines ["2Rnd_12Gauge_Pellets", 3];
							_x addWeapon (selectRandom ["sgun_HunterShotgun_01_sawedoff_F","sgun_HunterShotgun_01_F"]);
						};
					};
					if (_IFA3_partisan) then {
						removeAllWeapons _x;
						_sIFA3Weapon = (selectRandom _IFA3weapons);
						_mag = (getArray (configFile >> "CfgWeapons" >> _sIFA3Weapon >> "magazines")) select 0;
						for "_i" from 2 to (random 4) do {_this addMagazines _mag};
						_this addWeapon _sIFA3Weapon;
					};
					if ((count headgear _x) == 0 && (random 1 > 0.5)) then {
						_x addHeadgear (selectRandom DRO_C_HWearables);
					};
					if (random 1 > 0.5) then {_x addGoggles (selectRandom _goggles)};
				} forEach (units group _unit);				
			};					
		};
	};
};

if (!(_unit getVariable ["NOHOSTILE", false])) then {			
	if (count (_unit getVariable ['taskName', '']) == 0) then {
		[_unit] call _switchToHostile;
	};
	if (random 1 > 0.75 && _allowGroup) then {	
		_pos = [[[(getPos _unit), 30]], ["water"]] call BIS_fnc_randomPos;
		_civilians = [];
		for "_c" from 1 to ([2,3] call BIS_fnc_randomInt) step 1 do {
			_civilians pushBack (selectRandom _customClasses);
		};
		_group = [_pos, civilian, _civilians] call BIS_fnc_spawnGroup;
		{
			_dir = ([(getPos _x), _pos] call BIS_fnc_dirTo);
			_x setFormDir _dir;
			_x setDir _dir;
		} forEach units _group;
		[leader _group] call _switchToAmbush;
	};
};
