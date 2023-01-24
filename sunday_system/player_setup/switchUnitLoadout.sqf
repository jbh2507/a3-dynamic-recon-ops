// Apply player unit loadouts and identities
disableSerialization;
_thisUnit = _this select 0;
_return = _this select 1;
_playerGroupCBA = ([] call CBA_fnc_players);

if ((player == _thisUnit) OR (!isPlayer _thisUnit)) then {
	
	_infCopy = nil;
	
	if (typeName (_return select 0) == "CONTROL") then {
		_infCopy = (_return select 0) lbData (_return select 1);
	} else {
		_infCopy = (_return select 0);
	};
	
	if ((_thisUnit getVariable ["unitChoice", ""]) == _infCopy) then {
		//diag_log format ["DRO: %1 kept current loadout without change", _thisUnit];
	} else {
		_thisUnit setVariable ["unitChoice", _infCopy, true];
		if (_infCopy == "CUSTOM") then {
			//diag_log format ["DRO: %1 is using custom loadout", _thisUnit];
		} else {			
			if (typeName (_return select 0) == "CONTROL") then {
				_lbSize = (lbSize (_return select 0));
				for "_i" from 1 to _lbSize do {
					if (((_return select 0) lbData _i) == "CUSTOM") then {
						(_return select 0) lbDelete _i;
						(_return select 0) lbSetCurSel (_return select 1);
					};
				};	
			};			
			_thisUnit setVariable ["unitClass", _infCopy, true];
			_thisUnit setUnitLoadout (getUnitLoadout _infCopy);
			
			//detect ALiVE ORBAT loadout
			if (isNil {((configFile >> "CfgVehicles" >> (_thisUnit getVariable ["unitClass",""]) >> "ALiVE_orbatCreator_owned") call BIS_fnc_getCfgData)}) then {
				diag_log format ["DRO: %1 is not ORBAT configured", _thisUnit];
			} else {
				_ALiVE_orbatCreator_loadout = ((configFile >> "CfgVehicles" >> (_thisUnit getVariable ["unitClass",""]) >> "ALiVE_orbatCreator_loadout") call BIS_fnc_getCfgData);
				_thisUnit setUnitLoadout _ALiVE_orbatCreator_loadout;
				diag_log format ["DRO: %1 has an ORBAT configuration copied to loadout", _thisUnit];
			};
		};
	};
};

{
	_class = if (typeName (_return select 0) == "CONTROL") then {
		(_return select 0) lbText (_return select 1)
	} else {
		(_return select 1)
	};	
	[626262, (_thisUnit getVariable "unitLoadoutIDC"), _class] remoteExec ["sun_lobbyChangeLabel", _x];	
	
} forEach _playerGroupCBA;
