--------------------------------------------------------------------------
--	Crytek Source File.
-- 	Copyright (C), Crytek Studios, 2001-2007.
--------------------------------------------------------------------------
--	$Id$
--	$DateTime$
--	Description: GameRules implementation for Team Action
--  
--------------------------------------------------------------------------
--  History:
--  - 07/10/2007   16:02 : Modified by Marcio Martins
--
----------------------------------------------------------------------------------------------------
Script.LoadScript("scripts/gamerules/instantaction.lua", 1, 1);
--------------------------------------------------------------------------
TeamAction = new(InstantAction);
TeamAction.States = { "Reset", "PreGame", "PreRound", "InGame", "PostRound", "PostGame", };


TeamAction.MIN_TEAM_LIMIT_WARN_TIMER	= 15; -- team limit warning timer
TeamAction.START_TIMER								= 15; -- starting countdown timer


TeamAction.PREROUND_TIMERID						= 1060;
TeamAction.POSTROUND_TIMERID					= 1070;
TeamAction.POSTROUND_TIME							= 3000;


TeamAction.TEAM_SPAWN_LOCATIONS				= true; -- spawn in teamed spawn points
TeamAction.USE_SPAWN_GROUPS						= true;
TeamAction.NEUTRAL_SPAWN_LOCATIONS		= false;

TeamAction.TEAMSCORE_TEAM0_KEY 				= 10;
TeamAction.TEAMSCORE_TEAM1_KEY 				= 11;
TeamAction.TEAMSCORE_TEAM2_KEY 				= 12;

TeamAction.PP_AMOUNT_KEY 							= 200;

TeamAction.BUY_WEAPON 		= 1;
TeamAction.BUY_VEHICLE		= 2;
TeamAction.BUY_EQUIPMENT	= 4;
TeamAction.BUY_AMMO				= 8;
TeamAction.BUY_PROTOTYPE	= 16;

TeamAction.BUY_ALL				= 32-1;


TeamAction.weaponList=
{
	{ id="flashbang",				name="@mp_eFlashbang",					price=10, 			amount=1, ammo=true, weapon=false },
	{ id="smokegrenade",		name="@mp_eSmokeGrenade",				price=10, 			amount=1, ammo=true, weapon=false },
	{ id="explosivegrenade",name="@mp_eFragGrenade",				price=25, 			amount=1, ammo=true, weapon=false },
	
	{ id="pistol",			name="@mp_ePistol", 								price=50, 			class="SOCOM",						},
	{ id="claymore",		name="@mp_eClaymore",								price=25,				class="Claymore",					buyammo="claymoreexplosive"	},
	{ id="c4",					name="@mp_eExplosive", 							price=100, 			class="C4", 							buyammo="c4explosive" 			},
	
	{ id="shotgun",			name="@mp_eShotgun", 								price=50, 			class="Shotgun", 					uniqueId=4 },
	{ id="smg",					name="@mp_eSMG", 										price=75, 			class="SMG", 							uniqueId=3 },
	{ id="fy71",				name="@mp_eFY71", 									price=125, 			class="FY71", 						uniqueId=2 },
	{ id="macs",				name="@mp_eSCAR", 									price=150, 			class="SCAR", 						uniqueId=5 },
	{ id="rpg",					name="@mp_eML", 										price=300, 			class="LAW", 							uniqueId=8 },
	{ id="dsg1",				name="@mp_eSniper", 								price=200, 			class="DSG1", 						uniqueId=9 },
	{ id="gauss",				name="@mp_eGauss", 									price=300, 			class="GaussRifle",				uniqueId=6 },
};


TeamAction.equipList=
{
	{ id="binocs",			name="@mp_eBinoculars",							price=50,				class="Binoculars", 			uniqueId=101 },
	{ id="nsivion",			name="@mp_eNightvision", 						price=25, 			class="NightVision", 			uniqueId=102 },
	--{ id="pchute",			name="@mp_eParachute",							price=25,				class="Parachute",				uniqueId=103},
	{ id="radarkit",		name="@mp_eRadar",									price=25, 			class="RadarKit", 				uniqueId=104},
}


TeamAction.protoList=
{
	{ id="moac",						name="@mp_eAlienWeapon", 				price=500, 		class="AlienMount", 			uniqueId=12 },
	{ id="moar",						name="@mp_eAlienMOAR", 					price=250, 		class="MOARAttach", 			uniqueId=11 },

	{ id="minigun",					name="@mp_eMinigun",						price=400, 		class="Hurricane", 				uniqueId=7 	},

	--{ id="acloak",					name="@mp_eAlienCloak",					price=600,		class="AlienCloak",				uniqueId=14 },
}


TeamAction.ammoList=
{
	{ id="",										name="@mp_eAutoBuy",				price=0,									},
	{ id="bullet",							name="@mp_eBullet", 				price=5,			amount=30,	},
	{ id="shotgunshell",				name="@mp_eShotgunShell",		price=5,			amount=8,		},
	{ id="lightbullet",					name="@mp_eLightbullet",		price=5,			amount=40,	},
	{ id="incendiarybullet",		name="@mp_eIncendiaryBullet",price=50,		amount=30,	},
		
	{ id="sniperbullet",				name="@mp_eSniperBullet",		price=10,			amount=10, 	},
	{ id="scargrenade",					name="@mp_eRifleGrenade",		price=25,			amount=1,		},
	{ id="gaussbullet",					name="@mp_eGaussSlug",			price=50,			amount=5, 	},
	
	{ id="claymoreexplosive",		price=25,										amount=1,			invisible=true },
	{ id="avexplosive",					price=25,										amount=1,			invisible=true },
	{ id="c4explosive",					price=100,									amount=1,			invisible=true },

	
	{ id="hurricanebullet",			name="@mp_eMinigunBullet",	price=50,			amount=500,	},
	
	{ id="psilent",							name="@mp_ePSilencer",			price=10, 			class="SOCOMSilencer",		uniqueId=104, ammo=false, equip=true, },
	{ id="plam",								name="@mp_ePLAM",						price=25, 			class="LAM",							uniqueId=113, ammo=false, equip=true, },
	{ id="silent",							name="@mp_eRSilencer",			price=10, 			class="Silencer", 				uniqueId=103, ammo=false, equip=true, },	
	{ id="lam",									name="@mp_eRLAM",						price=25, 			class="LAMRifle",					uniqueId=114, ammo=false, equip=true, },
	{ id="reflex",							name="@mp_eReflex",					price=25,				class="Reflex", 					uniqueId=109, ammo=false, equip=true, },
	{ id="ascope",							name="@mp_eAScope",					price=50, 			class="AssaultScope", 		uniqueId=110, ammo=false, equip=true, },
	{ id="scope",								name="@mp_eSScope",					price=100, 			class="SniperScope", 			uniqueId=105, ammo=false, equip=true, },
	{ id="gl",									name="@mp_eGL",							price=100, 			class="GrenadeLauncher",	uniqueId=106, ammo=false, equip=true, },
	
	{ id="iamag",								name="@mp_eSCARIncendiary",	price=50, 			class="SCARIncendiaryAmmo", uniqueId=107, ammo=false, equip=true, },
};



TeamAction.buyList={};


for i,v in ipairs(TeamAction.weaponList) do TeamAction.buyList[v.id]=v; if (type(v.weapon)=="nil") then v.weapon=true; end;	end;
for i,v in ipairs(TeamAction.equipList) do TeamAction.buyList[v.id]=v; if (type(v.equip)=="nil") then	v.equip=true; end; end;
for i,v in ipairs(TeamAction.protoList) do TeamAction.buyList[v.id]=v; if (type(v.proto)=="nil") then	v.proto=true; end; end;
for i,v in ipairs(TeamAction.ammoList) do TeamAction.buyList[v.id]=v; if (type(v.ammo)=="nil") then v.ammo=true; end; end;


TeamAction.ppList=
{
	START				= 50,
	WON_ROUND		= 100,
	LOST_ROUND	= 50,
	
	KILL				= 25,
	KILL_ASSIST	= 25,
	TEAMKILL		= -100,
	SUICIDE			= -50,
}


----------------------------------------------------------------------------------------------------
TeamAction.teamName={ "tan", "black" };
TeamAction.teamModel=
{
	black	={
						{
							"objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
							"objects/weapons/arms_global/arms_nanosuit_us.chr",
							"objects/characters/human/us/nanosuit/nanoSuit_us_frozen_scatter.cgf",
							"objects/characters/human/us/nanosuit/nanosuit_us_fp3p.cdf",
						},
					},
					
	tan		={
						{
							"objects/characters/human/asian/nanosuit/nanosuit_asian_multiplayer.cdf",
							"objects/weapons/arms_global/arms_nanosuit_asian.chr",
							"objects/characters/human/asian/nanosuit/nanosuit_asian_frozen_scatter.cgf",
							"objects/characters/human/asian/nanosuit/nanosuit_asian_fp3p.cdf",
						},
					},
}


----------------------------------------------------------------------------------------------------
--maximum 4 groups, 5 messages in each (F5-F8, then 1-5). Change Radio.cpp if more needed.
TeamAction.teamRadio=
{
	black = 
	{
		[1]=
		{
			{"mp_american/us_F5_1_10-4","Ten Four",3},
			{"mp_american/us_F5_2_negative","Negative",3},
			{"mp_american/us_F5_3_wait","Wait Here",3},
			{"mp_american/us_F5_4_follow_me","Follow Me",3},
			{"mp_american/us_F5_5_thank_you","Thanks",3},
		},
		[2]=
		{
			{"mp_american/us_F6_1_attack_enemy_base","Attack Enemy Base"},
			{"mp_american/us_F6_2_gather_power_cores","Gather Power Cores"},
			{"mp_american/us_F6_3_take_prototype_factory","Take Prototype Factory"},
			{"mp_american/us_F6_4_take_war_factory","Take War Factory"},
			{"mp_american/us_F6_5_take_airfield","Take Airfield"},
		},
		[3]=
		{
			{"mp_american/us_F7_1_armor_spotted","Armor Spotted"},
			{"mp_american/us_F7_2_aircraft_spotted","Aircraft Spotted"},
			{"mp_american/us_F7_3_boat_spotted","Boat Spotted"},
			{"mp_american/us_F7_4_vehicle_spotted","Light Vehicle Spotted"},
			{"mp_american/us_F7_5_infantry_spotted","Infantry Spotted"},
		},
		[4]=
		{
			{"mp_american/us_F8_1_request_assistance","Request Assistance"},
			{"mp_american/us_F8_2_get_into_vehicle","Get Into Vehicle"},
			{"mp_american/us_F8_3_get_out_vehicle","Get Out Of Vehicle"},
			{"mp_american/us_F8_4_mechanical_assistance_needed","Requesting MechA ssistance"},
			{"mp_american/us_F8_5_radar_scan","Requesting Radar Scan"},
		},
	},
	tan = 
	{
		[1]=
		{
			{"mp_korean/nk_F5_1_10-4","Ten Four",3},
			{"mp_korean/nk_F5_2_negative","Negative",3},
			{"mp_korean/nk_F5_3_wait","Wait Here",3},
			{"mp_korean/nk_F5_4_follow_me","Follow Me",3},
			{"mp_korean/nk_F5_5_thank_you","Thanks",3},
		},
		[2]=
		{
			{"mp_korean/nk_F6_1_attack_enemy_base","Attack Enemy Base"},
			{"mp_korean/nk_F6_2_gather_power_cores","Gather Power Cores"},
			{"mp_korean/nk_F6_3_take_prototype_factory","Take Prototype Factory"},
			{"mp_korean/nk_F6_4_take_war_factory","Take War Factory"},
			{"mp_korean/nk_F6_5_take_airfield","Take Airfield"},
		},
		[3]=
		{
			{"mp_korean/nk_F7_1_armor_spotted","Armor Spotted"},
			{"mp_korean/nk_F7_2_aircraft_spotted","Aircraft Spotted"},
			{"mp_korean/nk_F7_3_boat_spotted","Boat Spotted"},
			{"mp_korean/nk_F7_4_vehicle_spotted","Light Vehicle Spotted"},
			{"mp_korean/nk_F7_5_infantry_spotted","Infantry Spotted"},
		},
		[4]=
		{
			{"mp_korean/nk_F8_1_request_assistance","Request Assistance"},
			{"mp_korean/nk_F8_2_get_into_vehicle","Get Into Vehicle"},
			{"mp_korean/nk_F8_3_get_out_vehicle","Get Out Of Vehicle"},
			{"mp_korean/nk_F8_4_mechanical_assistance_needed","Requesting Mech Assistance"},
			{"mp_korean/nk_F8_5_radar_scan","Requesting Radar Scan"},
		},
	}
}


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
Net.Expose {
	Class = TeamAction,
	ClientMethods = {
		ClSetupPlayer					= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, },
		ClVictory							= { RELIABLE_ORDERED, POST_ATTACH, INT8, INT8 },
		ClSpawnGroupInvalid		= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, },
		ClRoundVictory				= { RELIABLE_ORDERED, POST_ATTACH, INT8, },
		
		ClSuddenDeath					= { RELIABLE_ORDERED, POST_ATTACH, BOOL, },
		
		ClClientConnect				= { RELIABLE_UNORDERED, POST_ATTACH, STRING, BOOL },
		ClClientDisconnect		= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },
		ClClientEnteredGame		= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },
		
		ClEnterBuyZone				= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID, BOOL };
		
		ClBuyError						= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },
		ClBuyOk								= { RELIABLE_UNORDERED, POST_ATTACH, },

		ClPP									= { RELIABLE_UNORDERED, POST_ATTACH, FLOAT },		
		
		ClRestartGame					= { RELIABLE_UNORDERED, POST_ATTACH, },
	},
	ServerMethods = {
		SvBuy							 		= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, STRING },
		SvBuyAmmo					 		= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, STRING },
		
		SvRequestPP						= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, INT32 },
		RequestSpectatorTarget= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, INT8 },
	},
	ServerProperties = {
	},
};


----------------------------------------------------------------------------------------------------
function TeamAction:ResetPlayers()
	InstantAction.ResetPlayers(self);

	local players=self.game:GetPlayers();
	if (players) then
		for i,player in pairs(players) do
			if (player.actor:GetSpectatorMode()==0) then
				self:ResetPP(player.id);
				self:AwardPPCount(player.id, self.ppList.START);
			end
			if(player.actor:GetSpectatorMode() == 3) then
				self.game:ChangeSpectatorMode(player.id, 0, NULL_ENTITY);
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction:ReviveAllPlayers(keepEquip)
	for i,id in pairs(self.teamId) do	
		local players=self.game:GetTeamPlayers(id);
		if (players) then
			local groupId=self:GetRandomSpawnGroup(id);
			if (groupId and groupId~=NULL_ENTITY) then
				for k,player in ipairs(players) do
					self:SetPlayerSpawnGroup(player.id, groupId);
				end
			else
				LogWarning("Missing spawn groups for team %d!", id);
			end
		end
	end
	
	local allPlayers=self.game:GetPlayers();
	if(allPlayers) then
		for i,eachPlayer in ipairs(allPlayers) do
			if(eachPlayer and eachPlayer.actor:GetSpectatorMode() == 3) then
				self.game:ChangeSpectatorMode(eachPlayer.id, 0, NULL_ENTITY);
			end
		end
	end

	InstantAction.ReviveAllPlayers(self, keepEquip);
	
	for playerId,teamId in pairs(self.enterGameList) do
		self.enterGameList[playerId]=nil;

		local player=System.GetEntity(playerId);
		if(player) then
			self.game:ChangeSpectatorMode(playerId, 0, NULL_ENTITY);
		
			self.game:SetTeam(teamId, playerId);
		
			self:RevivePlayer(player.actor:GetChannel(), player);
		
			self:ResetPP(player.id);
			self:AwardPPCount(player.id, self.ppList.START);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetRandomSpawnGroup(teamId)
	local groupId;
	local groups=self.game:GetSpawnGroups(teamId);
	if (groups) then
		local n=table.getn(groups);
		if (n>0) then
			groupId=groups[math.random(0, n)];
		end
	end
	
	return groupId;
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:OnActorAction(player, action, activation, value)
	if (action == "scores" and (not self.force_scores)) then
		if (activation == "press") then
			self:ShowScores(true);
		else
			self:ShowScores(false);
		end
	elseif ((action == "attack1") and (activation == "press")) then
		if (player:IsDead() and player.actor:GetSpectatorMode()==0) then
			-- trigger spectator mode here
			self.server:RequestSpectatorTarget(player.id, 1);
		end
	elseif((action == "next_spectator_target") and (activation == "press")) then
		if(player.actor:GetSpectatorMode() == 3) then
			self.server:RequestSpectatorTarget(player.id, 1);
		end
	elseif((action == "prev_spectator_target") and (activation == "press")) then
		if(player.actor:GetSpectatorMode() == 3) then
			self.server:RequestSpectatorTarget(player.id, -1);
		end
	elseif((action == "cycle_spectator_mode") and (activation == "press")) then
	end

	return true;
end


----------------------------------------------------------------------------------------------------
function TeamAction:Reset(forcePregame)
	self:ResetTime();
	self:ResetTeamScores();
	self:ResetPlayers();
	self.losingTeamId=nil;

	self.roundCount=0;

	if ((self:PlayerCountOk() and (not forcePregame)) or (self.forceInGame)) then		
		self:GotoState("PreRound");
	else
		self:GotoState("PreGame");
	end

	self.forceInGame=nil;
end


----------------------------------------------------------------------------------------------------
function TeamAction:StartRound()
	self:GotoState("PreRound");
end


----------------------------------------------------------------------------------------------------
function TeamAction:CheckSuddenDeath()
	if (not self.suddenDeath) then
		if (self.game:IsRoundTimeLimited() and self.game:GetRemainingRoundTime()<=self.game:GetSuddenDeathTime()) then
			self:SuddenDeath(true);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:SuddenDeath(enable)
	if (enable) then	
		local players=self.game:GetPlayers(true);
		if (players) then
			for i,player in pairs(players) do
				if ((not player:IsDead()) and (player.actor:GetSpectatorMode()==0)) then
					--player.actor:SetHealth(1);
				end
			end
		end

		self.allClients:ClSuddenDeath(true);
	else
		self.allClients:ClSuddenDeath(false);
	end
	
	self.suddenDeath=enable;
end


----------------------------------------------------------------------------------------------------
function TeamAction:ResetRoundTime()
	self.game:ResetRoundTime();
end


----------------------------------------------------------------------------------------------------
function TeamAction:CheckPlayerScoreLimit(playerId, score)
end


----------------------------------------------------------------------------------------------------
function TeamAction:ResetTeamScores()
	for i,teamId in pairs(self.teamId) do
		self.game:SetSynchedGlobalValue(self.TEAMSCORE_TEAM0_KEY+teamId, 0);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:SetTeamScore(teamId, score)
	self.game:SetSynchedGlobalValue(self.TEAMSCORE_TEAM0_KEY+teamId, score);

	if (self:GetState() and self:GetState()=="InGame") then
		self:CheckScoreLimit(teamId, score);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetTeamScore(teamId)
	return self.game:GetSynchedGlobalValue(self.TEAMSCORE_TEAM0_KEY+teamId) or 0;
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetLeadingTeam()
	local maxScore=0;
	local maxId=0;
	local draw=false;

	for i,id in pairs(self.teamId) do
		local score=self:GetTeamScore(id);
		if (score>=maxScore) then
			if ((maxId~=0) and (maxScore==score)) then
				draw=true;
			else
				draw=false;
				maxId=id;
				maxScore=score;
			end
		end
	end
	
	if (not draw) then
		return maxId;
	else
		return nil;
	end
end




----------------------------------------------------------------------------------------------------
function TeamAction:CheckScoreLimit(teamId, score)
	if (self:GetState() and self:GetState()~="InGame") then
		return;
	end

	local fraglimit=self.game:GetFragLimit();
	local fraglead=self.game:GetFragLead();
	
	if ((fraglimit > 0) and (score >= fraglimit)) then
		if ((fraglead > 1) and self.teamId) then
			for i,id in pairs(self.teamId) do
				if (self:GetTeamScore(id)+fraglead > score) then
					return;
				end
			end
		end
		
		self:OnGameEnd(teamId, 3);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:CheckRoundLimit()
	local roundlimit=self.game:GetRoundLimit();
	if (roundlimit > 0) then
		if (self.roundCount>=roundlimit) then
			self:OnGameEnd(self:GetLeadingTeam(), 4);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:CheckTimeLimit()
	if (self.game:IsTimeLimited() and self.game:GetRemainingGameTime()<=0) then	
		self:OnGameEnd(self:GetLeadingTeam(), 2);
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction:CheckRoundTime()
	if (self.game:IsRoundTimeLimited() and self.game:GetRemainingRoundTime()<=0) then
		local minAlive=999999;
		local minId=0;
		local draw=false;

		for i,id in pairs(self.teamId) do
			local alive=self:GetTeamAliveCount(id);
			if (alive<=minAlive) then
				if ((minId~=0) and (minAlive==alive)) then
					draw=true;
				else
					draw=false;
					minId=id;
					minAlive=alive;
				end
			end
		end

		if (not draw) then
			for i,id in pairs(self.teamId) do
				if (id~=minId) then
					self:SetTeamScore(id, self:GetTeamScore(id)+1);
				end
			end
			
			self.losingTeamId=mindId;
		else
			self.losingTeamId=0;
		end

		self:GotoState("PostRound");
	else
		self:CheckSuddenDeath();
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction:PlayerCountOk()
	for i,teamName in ipairs(self.teamName) do
		local teamId = self.game:GetTeamId(teamName);
		if (self.game:GetTeamChannelCount(teamId, true) < self.game:GetMinTeamLimit()) then
			return false;
		end
	end
	
	return true;
end


----------------------------------------------------------------------------------------------------
function TeamAction:OnGameEnd(winningTeamId, type)
	if (winningTeamId and winningTeamId~=0) then
		local teamName=self.game:GetTeamName(winningTeamId);
		self.game:SendTextMessage(TextMessageCenter, "@mp_GameOverWinner", TextMessageToAll, nil, "@mp_team_"..teamName);
	else
		self.game:SendTextMessage(TextMessageCenter, "@mp_GameOverNoWinner", TextMessageToAll);
	end

	self.allClients:ClVictory(winningTeamId or 0, type or 0);
	
	self.game:EndGame();

	self:GotoState("PostGame");	
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnInit()
	self.teamId={};
	for i,v in ipairs(self.teamName) do
		table.insert(self.teamId, self.game:CreateTeam(v));
	end
	
	self.enterGameList={};
	self.inBuyZone={};
	self.assists={};
	self.dropped={};
	
	InstantAction.Server.OnInit(self);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnItemPickedUp(itemId, actorId)
	self.dropped[itemId]=nil;
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnItemDropped(itemId, actorId)
	self.dropped[itemId]=_time;
end


----------------------------------------------------------------------------------------------------
function TeamAction:CollectDroppedItems()
	for itemId,time in pairs(self.dropped) do
		System.RemoveEntity(itemId);
		self.dropped[itemId]=nil;
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:OnInit()
	InstantAction.Client.OnInit(self);

	-- if we are a server, it will be done by the server-side
	if (not self.isServer) then
		self.teamId={};
		for i,v in ipairs(self.teamName) do
			table.insert(self.teamId, self.game:CreateTeam(v));
		end
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnClientConnect(channelId, reset, name)
	local player = InstantAction.Server.OnClientConnect(self, channelId, name);

	if (player) then
		if (not CryAction.IsChannelOnHold(channelId)) then
			self:ResetPP(player.id);
		end

		self.assists[player.id]={};
	end

	return player;
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnClientEnteredGame(channelId, player, reset)
	InstantAction.Server.OnClientEnteredGame(self, channelId, player, reset);
end


----------------------------------------------------------------------------------------------------
-- only players get this
function TeamAction.Server:OnChangeSpectatorMode(playerId, mode, targetId, resetAll) 
	local player=System.GetEntity(playerId);
	if (not player) then
		return;
	end
	
	if(resetAll) then
		self:ResetPP(playerId);
		self:ResetScore(playerId);
	end
	
	if (mode>0) then
	
		if(resetAll) then
			player.death_time=nil;
			player.inventory:Destroy();
			if(mode == 1 or mode == 2) then
				self.game:SetTeam(0, playerId);
			end
		end

		if(mode == 1 or mode == 2) then
			--self.game:SetTeam(0, playerId);		
			local pos=g_Vectors.temp_v1;
			local angles=g_Vectors.temp_v2;
		
			player.actor:SetSpectatorMode(mode, NULL_ENTITY);
			local locationId=self.game:GetInterestingSpectatorLocation();
			if (locationId) then
				local location=System.GetEntity(locationId);
				if (location) then
					pos=location:GetWorldPos(pos);
					angles=location:GetWorldAngles(angles);
					
					self.game:MovePlayer(playerId, pos, angles);
				end
			end
		elseif(mode == 3) then
			if(targetId and targetId~=0) then
				local player = System.GetEntity(playerId);
				player.actor:SetSpectatorMode(3, targetId);
			else
				local newTargetId = self.game:GetNextSpectatorTarget(playerId, 1);
				if(newTargetId and newTargetId~=0) then
					local player = System.GetEntity(playerId);
					player.actor:SetSpectatorMode(3, newTargetId);
				end	
			end
		end
	elseif(mode == 0) then
		player.actor:SetSpectatorMode(0,NULL_ENTITY);	
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnClientDisconnect(channelId)
	InstantAction.Server.OnClientDisconnect(self, channelId);
	
	local player=self.game:GetPlayerByChannelId(channelId);

	if (player) then
		self.inBuyZone[player.id]=nil;
		self.assists[player.id]=nil;
	end

	self:CheckRoundEnd();
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnPlayerKilled(hit)
	hit.target.death_time=_time;
	
	self.game:KillPlayer(hit.targetId, true, true, hit.shooterId, hit.weaponId, hit.damage, hit.materialId, hit.typeId, hit.dir);
	self:ProcessScores(hit);
	
	self:CheckRoundEnd();
end


----------------------------------------------------------------------------------------------------
function TeamAction:ProcessScores(hit)
	local target=hit.target;
	local shooter=hit.shooter;
	local headshot=self:IsHeadShot(hit);

	local h=0;
	if (headshot) then
		h=1;
	end

	if (target.actor and target.actor:IsPlayer()) then
		self:Award(target, 1, 0, 0);
	end
	
	if (shooter and shooter.actor and shooter.actor:IsPlayer()) then
		self:AwardKillPP(hit);
		if (target ~= shooter) then
			local team1=self.game:GetTeam(shooter.id);
			local team2=self.game:GetTeam(target.id);
	
			if (team1~=team2) then
				self:Award(shooter, 0, 1, h);
			else
				self:Award(shooter, 0, -1, 0);
			end
		else
			self:Award(shooter, 0, -1, 0);
		end
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction:PrecacheLevel()
	TeamInstantAction.PrecacheLevel(self);
	
	for i,v in pairs(self.buyList) do
		if (v.weapon or v.equip) then
			if (v.class and v.class~="") then
				CryAction.CacheItemGeometry(v.class);
				CryAction.CacheItemSound(v.class);
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClEnterBuyZone(zoneId, enable)
	if (g_localActor and HUD) then
		HUD.EnteredBuyZone(zoneId, enable);
		HUD.UpdateBuyList();
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:OnSetTeam(entityId, teamId)
	if (entityId == g_localActorId) then
		HUD.UpdateBuyList();
	else
		local entity=System.GetEntity(entityId);
		if (entity.Properties and entity.Properties.buyAreaId) then -- TODO: more robust way to check if the are is a buy area
			HUD.UpdateBuyList();
		end
	end
	
	local entity=System.GetEntity(entityId);
	if (entity) then
		if (entity.OnSetTeam) then
			entity:OnSetTeam(teamId);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetTeamAliveCount(teamId)
	local count=0;
	local players=self.game:GetTeamPlayers(teamId);
	if (players) then
		for i,player in pairs(players) do
			if (not player:IsDead()) then
				count=count+1;
			end
		end
	end
	
	return count;
end


----------------------------------------------------------------------------------------------------
function TeamAction:CheckRoundEnd()
	local losing=0;
	for i,teamId in ipairs(self.teamId) do
		if (self:GetTeamAliveCount(teamId)<1) then
			losing=teamId;
			break;
		end
	end

	if (losing~=0) then
		for i,teamId in ipairs(self.teamId) do
			if (teamId ~= losing) then
				self:SetTeamScore(teamId, self:GetTeamScore(teamId)+1);
			end
		end
		
		self.losingTeamId=losing;

		self:GotoState("PostRound");
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnChangeTeam(playerId, teamId)
	if (teamId ~= self.game:GetTeam(playerId)) then
		local player=System.GetEntity(playerId);
		if (player) then
			if (player.actor:GetHealth()>0 and player.actor:GetSpectatorMode()==0) then
				self:KillPlayer(player);
			end

			if (self:GetState()=="InGame" or self:GetState()=="PreRound") then
				self.enterGameList[playerId]=teamId;
			else
				self.game:ChangeSpectatorMode(playerId, 0, NULL_ENTITY);
				
				self.game:SetTeam(teamId, playerId);
						
				self:RevivePlayer(player.actor:GetChannel(), player);
	
				self:ResetPP(player.id);
				self:AwardPPCount(player.id, self.ppList.START);		
			end
		end
	end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function TeamAction.Server:OnTimer(timerId, msec)	
	InstantAction.Server.OnTimer(self, timerId, msec);
	
	if (timerId == self.PREROUND_TIMERID) then
		self:GotoState("InGame");
	elseif (timerId == self.POSTROUND_TIMERID) then
		self:CheckRoundLimit();
		
		if (self:GetState()~="PostGame") then	-- CheckRoundLimit might have ended the game, in which case we don't want to start a new round
			self:GotoState("PreRound");
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:OnHit(hit)
	local target=hit.target;
	local shooter=hit.shooter;
	local isPlayer=target and target.actor and target.actor:IsPlayer();
	local shooterPlayer=shooter and shooter.actor and shooter.actor:IsPlayer();

	local wasDead=isPlayer and target:IsDead();
	local prevHealth=isPlayer and target.actor:GetHealth();
	
	if shooter and target then
		local team1=self.game:GetTeam(shooter.id);
		local team2=self.game:GetTeam(target.id);
		if(shooter.actor:IsPlayer() and team1 == team2 and team1~=0 and shooter.id~=target.id and (hit.type~="repair")) then
			hit.damage = hit.damage*self.game:GetFriendlyFireRatio();
		end
	end
	
	local result=InstantAction.Server.OnHit(self, hit);
	
	local isDead=isPlayer and target:IsDead();
	local currHealth=isPlayer and target.actor:GetHealth();
	

	if (isPlayer and (not wasDead) and shooterPlayer) then
		if (not isDead) then
			if (prevHealth-currHealth>=5) then
				if (self.game:GetTeam(shooter.id)~=self.game:GetTeam(target.id)) then
					local assists=self.assists[target.id];
					assists[shooter.id]=_time;
				end
			end
		else
			local assists=self.assists[target.id];
			for shooterId,time in pairs(assists) do
				if (shooterId~=shooter.id and _time-time<3) then
					if (self.game:GetTeam(shooterId)~=self.game:GetTeam(target.id)) then
						self:AwardPPCount(shooterId, self.ppList.KILL_ASSIST);
					end
				end

				assists[shooterId]=nil;
			end
		end
	end
		
	return result;
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:OnRevive(playerId, pos, rot, teamId)
	local teamId = teamId;
	local player = System.GetEntity(playerId);
	
	if (player and teamId and teamId~=0) then
		local teamName=self.game:GetTeamName(teamId);
		local models=self.teamModel[teamName];
		if (models and table.getn(models)>0) then
			local model=models[1];
			player:SetModel(model[1], model[2], model[3], model[4]);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:OnReviveInVehicle(playerId, vehicleId, seatId, teamId)
	local teamId = teamId;
	local player = System.GetEntity(playerId);
	
	if (player and teamId and teamId~=0) then
		local teamName=self.game:GetTeamName(teamId);
		local models=self.teamModel[teamName];
		if (models and table.getn(models)>0) then
			local model=models[1];
			player:SetModel(model[1], model[2], model[3], model[4]);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:AutoAssignTeam(player, forceTeamId)
	if (forcedTeamId and forcedTeamId~=0) then
		self.game:SetTeam(forcedTeamId, player.id);
	else
		teamId=self.teamId[1];
		local teamIdCount=self.game:GetTeamChannelCount(teamId);
		for i,v in pairs(self.teamId) do
			if (teamId ~= v) then
				local c1=self.game:GetTeamChannelCount(v);
				if (c1<teamIdCount) then
					teamId=v;
					teamIdCount=c1;
				end
			end
		end
		
		if (teamId and teamId~=0) then
			self.game:SetTeam(teamId, player.id);
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:DefaultState(cs, state)
	local default=self[cs];
	self[cs][state]={
		OnClientConnect = default.OnClientConnect,
		OnClientDisconnect = default.OnClientDisconnect,
		OnClientEnteredGame = default.OnClientEnteredGame,
		OnDisconnect = default.OnDisconnect, -- client only
		OnActorAction = default.OnActorAction, -- client only
		OnStartLevel = default.OnStartLevel,
		OnStartGame = default.OnStartGame,

		OnKill = default.OnKill,
		OnHit = default.OnHit,
		OnExplosion = default.OnExplosion,
		OnChangeTeam = default.OnChangeTeam,
		OnChangeSpectatorMode = default.OnChangeSpectatorMode,
		OnSetTeam = default.OnSetTeam,
		OnItemPickedUp = default.OnItemPickedUp,
		OnItemDropped = default.OnItemDropped,

		OnTimer = default.OnTimer,
		OnUpdate = default.OnUpdate,	
	}
end

----------------------------------------------------------------------------------------------------
TeamAction:DefaultState("Server", "Reset");
TeamAction:DefaultState("Client", "Reset");

----------------------------------------------------------------------------------------------------
TeamAction:DefaultState("Server", "PreGame");
TeamAction:DefaultState("Client", "PreGame");

TeamAction:DefaultState("Server", "PreRound");
TeamAction:DefaultState("Client", "PreRound");

----------------------------------------------------------------------------------------------------
TeamAction:DefaultState("Server", "InGame");
TeamAction:DefaultState("Client", "InGame");

----------------------------------------------------------------------------------------------------
TeamAction:DefaultState("Server", "PostRound");
TeamAction:DefaultState("Client", "PostRound");

----------------------------------------------------------------------------------------------------
TeamAction:DefaultState("Server", "PostGame");
TeamAction:DefaultState("Client", "PostGame");

----------------------------------------------------------------------------------------------------
TeamAction.Server.PostGame.OnChangeTeam = nil;
TeamAction.Server.PostGame.OnSpectatorMode = nil;


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PreGame:OnBeginState()
	self:EndGame(false);
end

----------------------------------------------------------------------------------------------------
function TeamAction.Server.PreGame:OnBeginState()
	self:ResetTime();	
	self:ResetRoundTime();
	self:StartTicking();
		
	self.starting=false;
	self.warningTimer=0;
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PreGame:OnUpdate(frameTime)
	TeamAction.Server.InGame.OnUpdate(self, frameTime);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PreGame:OnTick()
	if (self:PlayerCountOk()) then
		if (not self.starting) then
			self.starting=true;
			self.startTimer=self.START_TIMER+1;
			
			self.game:SendTextMessage(TextMessageCenter, "@mp_GameStartingCountdown", TextMessageToAll, nil, self.START_TIMER);
		end
	elseif (self.starting) then
		self.starting=false;
		self.warningTimer=0;
	end
	
	if (self.starting) then
		self.startTimer = self.startTimer-1;
		
		if (self.startTimer <= 5 and self.startTimer>0) then
			self.game:SendTextMessage(TextMessageCenter, "@mp_GameStartingCountdown", TextMessageToAll, nil, self.startTimer);
		end
		
		if (self.startTimer<=0) then
			self.game:SendTextMessage(TextMessageCenter, "@mp_GameStarted", TextMessageToAll);		

			self.startTimer=nil;
			self.starting=false;
			
			self:RestartGame(true);
		end
	else
		self.warningTimer = self.warningTimer-1;
		if (self.warningTimer<=0) then
			self.game:SendTextMessage(TextMessageCenter, "@mp_MinTeamWarning", TextMessageToAll, nil, self.game:GetMinTeamLimit());
			self.warningTimer=self.MIN_TEAM_LIMIT_WARN_TIMER;
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.InGame:OnBeginState()
	self:ResetRoundTime();
	self:StartTicking();
	
	CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameStarted);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.InGame:OnUpdate(frameTime)
	TeamAction.Server.OnUpdate(self, frameTime);

	self:CheckTimeLimit();
	self:CheckRoundTime();
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PostGame:OnBeginState()
	CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameEnd);
	
	self:StartTicking();
	self:SetTimer(self.NEXTLEVEL_TIMERID, self.NEXTLEVEL_TIME);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PostGame:OnBeginState()
	InstantAction.Client.PostGame.OnBeginState(self);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PostGame:OnEndState()
	InstantAction.Client.PostGame.OnEndState(self);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PreRound:OnBeginState()
	self:CollectDroppedItems();
	
	if (self.suddenDeath) then
		self:SuddenDeath(false)
	end

	
	self.roundCount=self.roundCount+1;
	self:StartTicking();
	
	if (self.roundCount>1) then
		self:ReviveAllPlayers(true);
	end
	
	self:SetTimer(self.PREROUND_TIMERID, math.max(0, self.game:GetPreRoundTime())*1000);
	self.game:ResetPreRoundTime();

	if (self.losingTeamId and self.losingTeamId~=0) then	
		for i,id in pairs(self.teamId) do
			if (id ~= self.losingTeamId) then
				local players=self.game:GetTeamPlayers(id);
				if (players) then
					for k,player in ipairs(players) do
						self:AwardPPCount(player.id, self.ppList.WON_ROUND);
					end
				end
			else
				local players=self.game:GetTeamPlayers(id);
				if (players) then
					for k,player in ipairs(players) do
						self:AwardPPCount(player.id, self.ppList.LOST_ROUND);
					end
				end
			end
		end

		self.losingTeamId=nil;
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PreRound:OnEndState()
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PreRound:OnBeginState()
	self.game:FreezeInput(true);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PreRound:OnEndState()
	self.game:FreezeInput(false);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PostRound:OnBeginState()
	self:StartTicking();
	self:SetTimer(self.POSTROUND_TIMERID, self.POSTROUND_TIME);
	
	if (self.suddenDeath) then
		self:SuddenDeath(false)
	end

	if (self.losingTeamId) then
		for i,id in pairs(self.teamId) do
			if (id~=self.losingTeamId) then
				self.allClients:ClRoundVictory(id);
			end
		end
	end	
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server.PostRound:OnEndState()
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PostRound:OnBeginState()
	--self.game:FreezeInput(true);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client.PostRound:OnEndState()
	self.game:FreezeInput(false);
end

----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClVictory(teamId, type)
	if (teamId and teamId~=0) then
		local ownTeamId=self.game:GetTeam(g_localActorId);
		if(ownTeamId == teamId) then
			--self:PlaySoundAlert("win", ownTeamId);
			--self:PlayRadioAlert("win", ownTeamId);
			self.game:GameOver(1);
		else
			--self:PlaySoundAlert("lose", ownTeamId);
			--self:PlayRadioAlert("lose", ownTeamId);
			self.game:GameOver(-1);
		end
	else
		self.game:GameOver(0);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClRoundVictory(teamId)
	if (teamId and teamId~=0) then
		local ownTeamId=self.game:GetTeam(g_localActorId);
		if(ownTeamId == teamId) then
			--self:PlaySoundAlert("win", ownTeamId);
			--self:PlayRadioAlert("win", ownTeamId);
			self.game:GameOver(1);
		else
			--self:PlaySoundAlert("lose", ownTeamId);
			--self:PlayRadioAlert("lose", ownTeamId);
			self.game:GameOver(-1);
		end
	else
		self.game:GameOver(0);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClSuddenDeath(enable)
	if (enable) then
		local ownTeamId=self.game:GetTeam(g_localActorId);
		for i,teamId in pairs(self.teamId) do
			if (teamId~=ownTeamId) then
				local players=self.game:GetTeamPlayers(teamId);
				if (players) then
					for k,player in pairs(players) do
						HUD.AddEntityToRadar(player.id);
					end
				end
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClBuyError(itemName)
	HUD.OnItemBought(false);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClBuyOk()
	HUD.OnItemBought(true);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClPP(amount)
	if (amount>0) then
		HUD.BattleLogEvent(eBLE_Currency, "@mp_BLAwardedPP", amount);
	elseif (amount<0) then
		HUD.BattleLogEvent(eBLE_Currency, "@mp_BLLostPP", -amount);
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction.Client:ClRestartGame()
	self.game:EnteredGame();
end

----------------------------------------------------------------------------------------------------
function TeamAction:ResetPP(playerId)
	self:SetPlayerPP(playerId, 0);
end


----------------------------------------------------------------------------------------------------
function TeamAction:SetPlayerPP(playerId, pp)
	self.game:SetSynchedEntityValue(playerId, self.PP_AMOUNT_KEY, pp);
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetPlayerPP(playerId)
	return self.game:GetSynchedEntityValue(playerId, self.PP_AMOUNT_KEY) or 0;
end


----------------------------------------------------------------------------------------------------
function TeamAction:AwardPPCount(playerId, c, why)
	local total=self:GetPlayerPP(playerId)+c;
	self:SetPlayerPP(playerId, math.max(0, total));

	local player=System.GetEntity(playerId);
	if (player) then
		self.onClient:ClPP(player.actor:GetChannel(), c);
	end

	CryAction.SendGameplayEvent(playerId, eGE_Currency, nil, total);
	CryAction.SendGameplayEvent(playerId, eGE_Currency, why, c);
end


----------------------------------------------------------------------------------------------------
function TeamAction:AwardKillPP(hit)
	local pp=self:CalcKillPP(hit);
	local playerId=hit.shooter.id;
	
	self:AwardPPCount(playerId, pp);
end




----------------------------------------------------------------------------------------------------
function TeamAction:CalcKillPP(hit)
	local target=hit.target;
	local shooter=hit.shooter;

	if(target ~= shooter) then
		local team1=self.game:GetTeam(shooter.id);
		local team2=self.game:GetTeam(target.id);
		
		if(team1 ~= team2) then
			return self.ppList.KILL;
		else
			return self.ppList.TEAMKILL;
		end
	else
		return self.ppList.SUICIDE;
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetPrice(itemName)
	if (not itemName) then
		return 0;
	end
	
	local entry=self.buyList[itemName];
	local price=0;
	if (entry) then
		price=entry.price;
	end
	
	if (price>0) then
		g_pp_scale_price=System.GetCVar("g_pp_scale_price");
		if (g_pp_scale_price) then
			price=math.floor(price*math.max(0, g_pp_scale_price));
		end
	end
	
	return price;
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetItemName(itemName)
	if (not itemName) then
		return "";
	end
	
	local entry=self.buyList[itemName];
	if (entry) then
		return entry.name;
	end
	
	return itemName;
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetItemFlag(itemName)
	local item=self.buyList[itemName];
	local flag=0;
	if (item.ammo) then flag=bor(flag, self.BUY_AMMO); end;
	if (item.equip) then flag=bor(flag, self.BUY_EQUIPMENT); end;
	if (item.proto) then flag=bor(flag, self.BUY_PROTOTYPE); end;
	if (item.vehicle) then flag=bor(flag, self.BUY_VEHICLE); end;
	if (item.weapon) then flag=bor(flag, self.BUY_WEAPON); end;
	
	return flag;
end


----------------------------------------------------------------------------------------------------
function TeamAction:GetItemDef(itemName)
	local entry=self.buyList[itemName];
	if (entry) then
		return entry;
	end
	return nil;
end


----------------------------------------------------------------------------------------------------
function TeamAction:ItemExists(playerId, itemName)
	return self.buyList[itemName]~=nil;
end


----------------------------------------------------------------------------------------------------
function TeamAction:EnoughPP(playerId, itemName, price)
	if (itemName and not price) then
		price=self:GetPrice(itemName);
	end
	
	if (not price) then
		price=0;
	end
	
	if (price and (price>self:GetPlayerPP(playerId))) then
		return false;
	end
	return true;
end


----------------------------------------------------------------------------------------------------
function TeamAction:Buy(itemName)
	self.server:SvBuy(g_localActorId, itemName);
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:SvBuy(playerId, itemName)
	local player=System.GetEntity(playerId);
	if (not player) then
		return;
	end
	
	local channelId=player.actor:GetChannel();
	local ok=false;
	
	if (self:ItemExists(playerId, itemName)) then
		if (self:IsInBuyZone(playerId)) then
			if (self:EnoughPP(playerId, itemName)) then
				ok=self:BuyItem(playerId, itemName);
			end
		end
	end
	
	if (ok) then
		self.onClient:ClBuyOk(channelId);
	else
		self.onClient:ClBuyError(channelId, itemName);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:BuyAmmo(ammo)
	if (not ammo or ammo=="") then
		local vehicleId=g_localActor.actor:GetLinkedVehicleId();
		local weapon;
		if (vehicleId) then
			local vehicle=System.GetEntity(vehicleId);
			if (vehicle) then
				local seat=vehicle:GetSeat(g_localActorId);
				if (seat and seat.seat:GetWeaponCount()>0) then
					local weaponId = seat.seat:GetWeaponId(1);
					if (weaponId) then
						weapon=System.GetEntity(weaponId);
					end				
				end
			end
		else
			weapon=g_localActor.inventory:GetCurrentItem();
		end
		
		if (weapon and weapon.weapon) then
			ammo=weapon.weapon:GetAmmoType();
		end
	end

	if (ammo and ammo~="") then
		self.server:SvBuyAmmo(g_localActorId, ammo);
	end
end	


----------------------------------------------------------------------------------------------------
function TeamAction.Server:SvBuyAmmo(playerId, name)
	--Log("TeamAction.Server:SvBuyAmmo(%s, %s)", EntityName(playerId), tostring(name));
	
	local player=System.GetEntity(playerId);
	if (not player) then
		return;
	end
	
	if (player.actor:GetHealth()<=0) then
		return;
	end

	local channelId;
	local ammo=self.buyList[name];
	if (ammo and ammo.ammo) then
		local price=self:GetPrice(name);
		
		channelId = player.actor:GetChannel();
		
		local vehicleId = player and player.actor:GetLinkedVehicleId();
		if (vehicleId) then
			local vehicle=System.GetEntity(vehicleId);
			 --is in vehiclebuyzone 
			if (self:IsInBuyZone(playerId) and (price==0 or self:EnoughPP(playerId, nil, price))) then
				local c=vehicle.inventory:GetAmmoCount(name) or 0;
				local m=vehicle.inventory:GetAmmoCapacity(name) or 0;

				if (c<m or m==0) then
					local need=ammo.amount;
					if (m>0) then
						need=math.min(m-c, ammo.amount);
					end

					-- this function takes care of synchronizing it to clients
					vehicle.vehicle:SetAmmoCount(name, c+need);
				
					if (price>0) then
						if (need<ammo.amount) then
							price=math.ceil((need*price)/ammo.amount);
						end
						self:AwardPPCount(playerId, -price);
					end
				
					self.onClient:ClBuyOk(channelId);
					return;
				end
			end
		elseif (self:IsInBuyZone(playerId) and (price==0 or self:EnoughPP(playerId, nil, price))) then
			local c=player.inventory:GetAmmoCount(name) or 0;
			local m=player.inventory:GetAmmoCapacity(name) or 0;

			if (c<m or m==0) then
				local need=ammo.amount;
				if (m>0) then
					need=math.min(m-c, ammo.amount);
				end

				-- this function takes care of synchronizing it to clients
				player.actor:SetInventoryAmmo(name, c+need);

				if (price>0) then
					if (need<ammo.amount) then
						price=math.ceil((need*price)/ammo.amount);
					end
					self:AwardPPCount(playerId, -price);
				end
			
				self.onClient:ClBuyOk(channelId);
				return;
			end
		end
	end
	
	if (channelId) then
		self.onClient:ClBuyError(channelId, name);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:BuyItem(playerId, itemName)
	local price=self:GetPrice(itemName);
	local def=self:GetItemDef(itemName);
	
	if (not def) then
		return false;
	end
	
	if (def.buyammo and self:HasItem(playerId, def.class)) then
		return self:DoBuyAmmo(playerId, def.buyammo);
	end
	
	if (def.uniqueId and self:HasUniqueItem(playerId, def.uniqueId)) then
		self.game:SendTextMessage(TextMessageError, "@mp_CannotCarryMoreKit", TextMessageToClient, playerId);
		return false;
	end
	
	local player=System.GetEntity(playerId);
	if (not player) then
		return;
	end
	
	if (player.actor:GetHealth()<=0) then
		return;
	end

	-- check inventory
	local itemId;
	if (player.actor:CheckInventoryRestrictions(def.class)) then
		self:AwardPPCount(playerId, -price);
		itemId=ItemSystem.GiveItem(def.class, playerId);
	else
		self.game:SendTextMessage(TextMessageError, "@mp_CannotCarryMore", TextMessageToClient, playerId);
		return false;
	end
	
	return true;
end


----------------------------------------------------------------------------------------------------
function TeamAction:HasItem(playerId, itemName)
	local player=System.GetEntity(playerId);
	local inventory=player and player.inventory;
	if (inventory) then
		if (inventory:GetItemByClass(itemName)) then
			return true;
		end
	end
	
	return false;
end


----------------------------------------------------------------------------------------------------
function TeamAction:HasUniqueItem(playerId, uniqueId)
	local player=System.GetEntity(playerId);
	local inventory=player and player.inventory;
	if (inventory) then
		for item,def in pairs(self.buyList) do
			if (def.uniqueId and def.uniqueId==uniqueId) then
				if (inventory:GetItemByClass(def.class)) then
					return true;
				end
			end
		end	
	end
	
	return false;
end


----------------------------------------------------------------------------------------------------
function TeamAction:OnEnterBuyZone(zone, player)	
	if (not self.inBuyZone[player.id]) then
		self.inBuyZone[player.id]={};
	end
	
	local was=self.inBuyZone[player.id][zone.id];
	if (not was) then
		self.inBuyZone[player.id][zone.id]=true;
		self.onClient:ClEnterBuyZone(player.actor:GetChannel(), zone.id, true);
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction:OnLeaveBuyZone(zone, player)
	if (self.inBuyZone[player.id] and self.inBuyZone[player.id][zone.id]) then
		self.inBuyZone[player.id][zone.id]=nil;
		self.onClient:ClEnterBuyZone(player.actor:GetChannel(), zone.id, false);
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction:IsInBuyZone(playerId, zoneId)
	local zones=self.inBuyZone[playerId];
	if (not zones) then
		return false;
	end
	
	local playerTeamId = self.game:GetTeam(playerId);
	
	if (zoneId) then
		local zoneTeamId = self.game:GetTeam(zoneId);
		return zoneTeamId and zones[zoneId] and zoneTeamId==playerTeamId;
	else
		for zoneId,inside in pairs(zones) do
			local zoneTeamId = self.game:GetTeam(zoneId);
			if (zoneTeamId and inside and zoneTeamId==playerTeamId) then
				return true;
			end
		end
		
		return false;	
	end
end


----------------------------------------------------------------------------------------------------
function TeamAction.Server:SvRequestPP(playerId, amount)
	if (g_gameRules.game:CanCheat()) then
		self:AwardPPCount(playerId, amount);
	end
end

----------------------------------------------------------------------------------------------------
function TeamAction.Server:RequestSpectatorTarget(playerId, change)
	local targetId = self.game:GetNextSpectatorTarget(playerId, change);
	if(targetId and targetId~=0) then
		local player = System.GetEntity(playerId);
		self.game:ChangeSpectatorMode(player.id, 3, targetId);
	end
end

----------------------------------------------------------------------------------------------------
function GivePP(amt)
	if (g_gameRules.isServer) then
		if (g_gameRules.game:CanCheat()) then
			g_gameRules:SetPlayerPP(g_localActorId, amt);
		end
	else
		g_gameRules.server:SvRequestPP(g_localActorId, amt);
	end
end
