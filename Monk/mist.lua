-- ProbablyEngine Rotation Packager
-- Created on Oct 21st 2014 1:22 am
ProbablyEngine.rotation.register_custom(270, "Misty", {
  --------------------
  -- Start Rotation --
  --------------------

  
  
  ------------------
  -- End Rotation --
  ------------------
  
  }, {

  ---------------
  -- OOC Begin --
  ---------------


			{ "124682", { "player.casting(115175)", "player.chi >= 3", "lowest.health <= 100" }, "lowest" }, -- Enveloping Mist
			--{ "115151", { "lowest.buff(119611).duration <= 2", "lowest.health < 100"}, "lowest"}, -- Renewing Mist
			{ "116694", { "player.casting(115175)", "lowest.health <= 100", "!lowest.buff(119611)"}, "lowest" }, -- Surging Mist 
			{ "115175", { "lowest.health <= 100", "!player.moving"}, "lowest" },
  
  -------------
  -- OOC End --
  -------------
  
})

