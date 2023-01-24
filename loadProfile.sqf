timeOfDay = profileNamespace getVariable ["DRO_timeOfDay", 0];
publicVariable "timeOfDay";
month = profileNamespace getVariable ["DRO_month", 0];
publicVariable "month";
day = profileNamespace getVariable ["DRO_day", 0];
publicVariable "day";
weatherOvercast = profileNamespace getVariable ["DRO_weatherOvercast", "RANDOM"];
publicVariable "weatherOvercast";
animalsEnabled = profileNamespace getVariable ['DRO_animalsEnabled', 0];
publicVariable "animalsEnabled";
aiSkill = profileNamespace getVariable ["DRO_aiSkill", 0];
publicVariable "aiSkill";
aiMultiplier = profileNamespace getVariable ["DRO_aiMultiplier", 1];
publicVariable "aiMultiplier";
numObjectives = profileNamespace getVariable ["DRO_numObjectives", 0];
publicVariable "numObjectives";
preferredObjectives = profileNamespace getVariable ["DRO_objectivePrefs", []];
publicVariable "preferredObjectives";
aoOptionSelect = profileNamespace getVariable ["DRO_aoOptionSelect", 0];
publicVariable "aoOptionSelect";
minesEnabled = profileNamespace getVariable ["DRO_minesEnabled", 0];
publicVariable "minesEnabled";
civiliansEnabled = profileNamespace getVariable ["DRO_civiliansEnabled", 0];
publicVariable "civiliansEnabled";
stealthEnabled = profileNamespace getVariable ["DRO_stealthEnabled", 0];
publicVariable "stealthEnabled";

if ((configfile >> "CfgPatches" >> "ace_medical") call BIS_fnc_getCfgIsClass) then {
	reviveDisabled = profileNamespace getVariable ["DRO_reviveDisabled", 3];
	publicVariable "reviveDisabled";
} else {
	reviveDisabled = profileNamespace getVariable ["DRO_reviveDisabled", 0];
	publicVariable "reviveDisabled";
};

staminaDisabled = profileNamespace getVariable ["DRO_staminaDisabled", 0];
publicVariable "staminaDisabled";
missionPreset = profileNamespace getVariable ["DRO_missionPreset", 0];
publicVariable "missionPreset";
insertType = profileNamespace getVariable ["DRO_insertType", 0];
publicVariable "insertType";
randomSupports = profileNamespace getVariable ["DRO_randomSupports", 0];
publicVariable "randomSupports";
customSupports = profileNamespace getVariable ["DRO_supportPrefs", []];
publicVariable "customSupports";
dynamicSim = profileNamespace getVariable ["DRO_dynamicSim", 0];
publicVariable "dynamicSim";
diag_log "DRO: variables loaded from profile";
