/*
ROS_HitReaction script - by RickOShay

FUNCTION
Adds more realistic hit or impact reaction and sfx to vehicles.

LEGAL STUFF
Credit must be given on both the Steam Workshop page and within the mission / derivative work if published to the Steam Workshop.

INSTALLATION
Place the following line into the init.sqf
[] execVM "ROS_hitreaction\scripts\ROS_HitReaction.sqf";

Place the following line in the onPlayerRespawn.sqf file :
player removeAllEventHandlers "HIT";

Copy the ROS_hitreaction folder to your mission folder
Add the CFGSounds sound classes from the sample description.ext to your mission file with the same name

Adjust supported vehicle types below :

ENABLE VEHICLE TYPES */
Tracked_Enabled = true;
Wheeled_APC_Enabled = true;
Wheeled_Enabled = true;
Air_Enabled = true;
Boat_Enabled = true;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// DONT CHANGE ANYTHING BELOW THIS LINE ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

if !(hasInterface) exitWith {};

/* Camshake Defaults
//[power, duration, frequency]
Tracked = [5,1,20];
WheeledAPC = [3,1,15];
Wheeled = [2,1,10];
Air = [3,1,5];
Boat = [10,1,50];
*/

// Sounds
ROS_sndsLight = ["hitlight1", "hitlight2", "hitlight3", "hitlight4"];
ROS_sndsMedium = ["hitmedium1", "hitmedium2", "hitmedium3", "hitmedium4"];
ROS_sndsHeavy = ["hitheavy1", "hitheavy2", "hitheavy3", "hitheavy4"];

// ON ALL CLIENT MACHINES - ADD HIT EH TO VEHICLES

if (isNil "ROS_HEHAdded") then {ROS_HEHAdded =[];};

[] spawn {

  while {true} do {

    // Add HIT EH to all vehicles (Note hit EH doesnt always fire if only minor damage caused)
    {if !(_x in ROS_HEHAdded) then {

      _x addEventHandler ["Hit", {
      params ["_veh", "_causedBy", "_damage", "_instigator"];

        _isNotSmallArms = !(currentWeapon _causedBy isKindOf ["Rifle",  configFile >> "CfgWeapons"]);
        _isNotGrenade = !(currentWeapon _causedBy isKindOf ["HandGrenade", configFile >> "CfgMagazines"]);

        //hint format ["CausedBy: %1\nNotSA: %2\nNoGren: %3", currentWeapon _causedBy, _isNotSmallArms, _isNotGrenade];
        copyToClipboard (currentWeapon _causedBy);

        switch (!isnull _veh) do {

          // Tracked
          case (Tracked_Enabled && _veh iskindof "Tank" && player in _veh && _isNotSmallArms && _isNotGrenade): {
            _selSnd = "";
            _selSnd = selectRandom ROS_sndsHeavy;
            playSound _selSnd;
            //[power, duration, frequency]
            addCamShake [(5 + random 5), 1, (20 + random 30)];
          };
          // Wheeled APC
          case (Wheeled_APC_Enabled && _veh iskindof "Wheeled_APC_F" && player in _veh && _isNotSmallArms): {
            _selSnd = "";
            _selSnd = selectRandom ROS_sndsMedium;
            playSound _selSnd;
            addCamShake [(3 + random 3), 1, (15 + random 10)];
          };
          // Wheeled
          case (Wheeled_Enabled && _veh iskindof "Car" && !(_veh iskindof "Wheeled_APC_F") && player in _veh && _isNotSmallArms): {
            _selSnd = "";
            _selSnd = selectRandom ROS_sndsLight;
            playSound _selSnd;
            addCamShake [(1.5 + random 1.5), 1, (5 + random 5)];
          };
          // Air
          case (Air_Enabled && _veh iskindof "Air" && player in _veh && _isNotSmallArms): {
            _selSnd = "";
            _selSnd = selectRandom ROS_sndsLight;
            playSound _selSnd;
            addCamShake [(2.5 + random 2.5), 1, (10 + random 10)];
          };
          // Boat
          case (Boat_Enabled && _veh iskindof "Ship" && player in _veh && _isNotSmallArms): {
            _selSnd = "";
            _selSnd = selectRandom ROS_sndsLight;
            playSound _selSnd;
            addCamShake [(2 + random 2), 1, (10 + random 10)];
          };
        };
      }];

      ROS_HEHAdded pushBackUnique _x;

    }} foreach (vehicles select {alive _x && (_x iskindof "car" or _x isKindOf "tank" or _x isKindOf "air" or _x isKindOf "ship")});

    sleep 3; // Adjust loop delay based average time new vehicles get spawned
  };
};
