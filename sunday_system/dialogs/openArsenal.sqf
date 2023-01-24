if (!isNull (_this select 0)) then {
	_unit = _this select 0;
	_unit setVariable ["startReady", false, true];
	closeDialog 1;
	
	//get identity of target unit
	_unitIdentity = _unit getVariable ["respawnIdentity", []];
	_unitIdentityPruned = [(_unitIdentity select 1), (_unitIdentity select 2), (_unitIdentity select 3), (_unitIdentity select 4)];
	_unitName = [(_unitIdentity select 1), (_unitIdentity select 2)] joinString " ";
	_unitIdentityPruned pushBack _unitName; 
	_unitSpeakerPitch = pitch _unit;
	_unitIdentityPruned pushBack _unitSpeakerPitch;
	_unitGoggles = goggles _unit;
	_unitIdentityPruned pushBack _unitGoggles;
	_unitIdentityFinal = _unitIdentityPruned;
	// ["John","Rollins","Male06ENG","GreekHead_A3_07","John Rollins",1.03,""]
	
	_oldUnit = player;
	
	if (player != _unit) then {
		selectPlayer _unit;
		_unit setNameSound (_unitIdentityFinal select 1);
		_unit setSpeaker (_unitIdentityFinal select 2);
		_unit setFace (_unitIdentityFinal select 3);
		_unit setName (_unitIdentityFinal select 4);
		_unit setPitch (_unitIdentityFinal select 5);
		removeGoggles _unit;
		_unit addGoggles (_unitIdentityFinal select 6);
	};
	
	// Open arsenal
	["Open", true] call BIS_fnc_arsenal;
	
	waitUntil {!isNull ( uiNamespace getVariable [ "BIS_fnc_arsenal_cam", objNull ] )};
	
	waitUntil {isNull ( uiNamespace getVariable [ "BIS_fnc_arsenal_cam", objNull ] )};
	
	if (player != _oldUnit) then {
		selectPlayer _oldUnit;
		_unit setNameSound (_unitIdentityFinal select 1);
		_unit setSpeaker (_unitIdentityFinal select 2);
		_unit setFace (_unitIdentityFinal select 3);
		_unit setName (_unitIdentityFinal select 4);
		_unit setPitch (_unitIdentityFinal select 5);
	};
	
	//player switchCamera "GROUP";
	_unit setVariable ["unitChoice", "CUSTOM", true];
	publicVariable "unitChoice";
	[_unit, "ALL"] remoteExec ["disableAI", _unit];
	
	_handle = CreateDialog "DRO_lobbyDialog";
	[] execVM "sunday_system\dialogs\populateLobby.sqf";
};
