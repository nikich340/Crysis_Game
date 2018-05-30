--------------------------------------------------------------------------
--	Crytek Source File.
-- 	Copyright (C), Crytek Studios, 2001-2006.
--------------------------------------------------------------------------
--	$Id$
--	$DateTime$
--	Description: Spawn Group
--  
--------------------------------------------------------------------------
--  History:
--  - 19:10:2006   16:53 : Created by M�rcio Martins
--
--------------------------------------------------------------------------
Script.ReloadScript("scripts/gamerules/powerstruggle.lua");
----------------------------------------------------------------------------------------------------
SpawnGroup = {
	Client = {},
	Server = {},

	Editor={
		Model="Editor/Objects/Spawngroup.cgf",
	},
	
	Properties=
	{
		objModel 								= "",
		teamName								= "",
		bEnabled								= 1,
		bDefault								= 0,
		equip_AdditionalEquipmentPack	= "",
	},
}



SpawnGroup.NetSetup={
	Class = SpawnGroup,
	ClientMethods =	{
	},
	ServerMethods = {
	},
	ServerProperties = {
	}
};



----------------------------------------------------------------------------------------------------
function SpawnGroup:OnPreFreeze(freeze, vapor)
	if (freeze) then
		return false; -- don't allow freezing
	end
end


----------------------------------------------------------------------------------------------------
function SpawnGroup:CanShatter()
	return 0;
end


----------------------------------------------------------------------------------------------------
function SpawnGroup:OnSpawn()
	self:Activate(1);

	local model = self.Properties.objModel;
	if (string.len(model) > 0) then
		local ext = string.lower(string.sub(model, -4));

		if ((ext == ".chr") or (ext == ".cdf") or (ext == ".cga")) then
			self:LoadCharacter(0, model);
		else
			self:LoadObject(0, model);
		end
	end

	self:Physicalize(0, PE_STATIC, {mass=0});
end


----------------------------------------------------------------------------------------------------
function SpawnGroup.Server:OnInit()
	g_gameRules.game:SetTeam(g_gameRules.game:GetTeamId(self.Properties.teamName) or 0, self.id);
	self.default=(tonumber(self.Properties.bDefault)~=0);
end


----------------------------------------------------------------------------------------------------
function SpawnGroup.Server:OnStartGame()
	self:Enable(tonumber(self.Properties.bEnabled)~=0);	
end


----------------------------------------------------------------------------------------------------
function SpawnGroup.Server:OnShutDown()
	if (g_gameRules) then
		g_gameRules.game:RemoveSpawnGroup(self.id);
	end
end


----------------------------------------------------------------------------------------------------
function SpawnGroup:AddSpawnPoints(linkName)
	local i=0;
	local link=self:GetLinkTarget(linkName, i);
	while (link) do
		g_gameRules.game:AddSpawnLocationToSpawnGroup(self.id, link.id);
		i=i+1;
		link=self:GetLinkTarget(linkName, i);
	end
end


----------------------------------------------------------------------------------------------------
function SpawnGroup:GetAdditionalEquipmentPack()
	return self.Properties.equip_AdditionalEquipmentPack;
end


----------------------------------------------------------------------------------------------------
function SpawnGroup:Enable(enable)
	if (not g_gameRules) then
		return;
	end

	if (enable) then
		g_gameRules.game:AddSpawnGroup(self.id);
		
		local teamId=g_gameRules.game:GetTeam(self.id)
		if (self.default and (teamId~=0)) then
			g_gameRules.game:SetTeamDefaultSpawnGroup(teamId, self.id);
		end

		self:AddSpawnPoints("spawn");
		self:AddSpawnPoints("spawnpoint");		
	else
		g_gameRules.game:RemoveSpawnGroup(self.id);
	end
end


--------------------------------------------------------------------------
function SpawnGroup:IsEnabled()
	return self.enabled;
end


----------------------------------------------------------------------------------------------------
MakeCapturable(SpawnGroup);
MakeBuyZone(SpawnGroup, bor(bor(PowerStruggle.BUY_WEAPON,PowerStruggle.BUY_AMMO), PowerStruggle.BUY_EQUIPMENT));
Net.Expose(SpawnGroup.NetSetup);