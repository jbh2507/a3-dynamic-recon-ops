waitUntil {!isNull player};
["DRO: Player %1 respawned: %2", player, _this] call BIS_fnc_logFormatServer;

if (!isNil "loadoutSavingStarted") then {
	if (loadoutSavingStarted) then {
		playerRespawning = true;
		_loadout = player getVariable "respawnLoadout";	
		if (!isNil "_loadout") then {
			diag_log format ["DRO: Respawning with loadout = %1", _loadout];
			player setUnitLoadout _loadout;
		};
		if (!isNil "respawnTime") then {
			setPlayerRespawnTime respawnTime;	
		};
		deleteVehicle (_this select 1);
		playerRespawning = false;
	};
};

if (!isNil "droGroupIconsVisible") then {
	if (droGroupIconsVisible) then {
		setGroupIconsVisible [true, false];
	};
};

player setUnitTrait ["Medic", true];
player setUnitTrait ["engineer", true];
player setUnitTrait ["explosiveSpecialist", true];
player setUnitTrait ["UAVHacker", true];

player setUnitTrait ["ACE_medical_medicClass", true, true];
player setUnitTrait ["ACE_IsEngineer", true, true];
player setUnitTrait ["ACE_isEOD", true, true];

if ((["SOGPFRadioSupportTrait", 0] call BIS_fnc_getParamValue) == 1) then {
	player setUnitTrait ["vn_artillery", true, true];
};

if (!isNil "staminaDisabled") then {
	if ((staminaDisabled) > 0) then {
		player setAnimSpeedCoef 1;
		player enableFatigue false;
		player enableStamina false;
		if (!isNil "ace_advanced_fatigue_enabled") then {
			[missionNamespace, ["ace_advanced_fatigue_enabled", false]] remoteExec ["setVariable", player];
		};
	};
};

//fix for sometimes strange respawn circumstances
if ((configfile >> "CfgPatches" >> "ace_medical") call BIS_fnc_getCfgIsClass) then {	
	[player] call ACE_medical_treatment_fnc_fullHealLocal;
};
player setdamage 0;
player allowDamage true;
player setCaptive false;

// Initialize group management for player
if (isServer) then {["Initialize"] call BIS_fnc_dynamicGroups;}; 
if (hasInterface) then {["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;};