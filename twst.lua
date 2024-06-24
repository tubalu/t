-- -- Define function to run after 7 minutes
-- local function runAfter7Minutes()
--     -- Wait for 7 minutes (seconds)
--     wait(420)
    
--     -- After waiting for 7 minutes, perform the following code
--     local args = {
--         [1] = 34
--     }

--     local replicatedStorage = game:GetService("ReplicatedStorage")
--     local teleportService = replicatedStorage:WaitForChild("Shared"):WaitForChild("Teleport")
--     local startRaidEvent = teleportService:WaitForChild("StartRaid")

--     if startRaidEvent then
--         startRaidEvent:FireServer(unpack(args))
--         print("StartRaid event fired after 7 minutes.")
--     else
--         warn("StartRaid event not found!")
--     end
-- end

-- Start a coroutine to avoid affecting other functions
-- task.spawn(runAfter7Minutes)

-- Configure item selling options


local function xx()
    local Hxx = game.Players.LocalPlayer
    local Ixx = Hxx.Character or Hxx.CharacterAdded:Wait()
    local Jxx = Ixx:WaitForChild('HumanoidRootPart', 180)
    while true do

        if game.PlaceId ==  13988110964 then
            Jxx.CFrame = game.Workspace.MissionObjects.Arena["1"].TeleporterLocation.CFrame
            wait(3)
            Jxx.CFrame = game.Workspace.MissionObjects.Arena["2"].TeleporterLocation.CFrame
            wait(3)
            Jxx.CFrame = game.Workspace.MissionObjects.Arena["BossArena"].TeleporterLocation.CFrame
            wait(3)
        end


        local bossGatexx = game.Workspace:FindFirstChild("Boss_Gate")
        if bossGatexx then
            local interactions = bossGatexx:FindFirstChild("Interactions")
            if interactions then
                local atp = interactions:GetChildren()[1]
                local btp = interactions:GetChildren()[2]
                local ctp = interactions:GetChildren()[3]
                if atp then
                    Jxx.CFrame = atp.CFrame
                    wait(3)
                end
                if btp then
                    Jxx.CFrame = btp.CFrame
                    wait(3)
                end
                if ctp then
                    Jxx.CFrame = ctp.CFrame
                    wait(3)
                end
            end
        end
    end
    wait()

end

-- task.spawn(xx)

getgenv().Common = true
getgenv().Uncommon = true
getgenv().Rare = true
getgenv().Epic = true
getgenv().Legendary = true

-- Define function to get item list
function getItemList()
    local itemList = {}
    local success, items = pcall(function()
        return require(game:GetService("ReplicatedStorage").Shared.Items)
    end)
    if not success then
        warn("Error loading item list: " .. tostring(items))
        return itemList
    end

    for a, b in pairs(items) do
        for i, v in pairs(b) do
            if (i == 'Type') and (v == 'Weapon' or v == 'Armor') then
                table.insert(itemList, b)
            end
        end
    end
    return itemList
end

-- Define function to get item name
function getItemName()
    local itemNameTable = {}
    local playerName = game.Players.LocalPlayer.Name
    local playerInventory = game:GetService("ReplicatedStorage").Profiles:FindFirstChild(playerName)

    if not playerInventory then
        warn("Player inventory not found!")
        return itemNameTable
    end

    for i, v in ipairs(playerInventory.Inventory.Items:GetChildren()) do
        if v:FindFirstChild('Level') or v:FindFirstChild('Upgrade') or v:FindFirstChild('UpgradeLimit') then
            if not string.find(v.Name:lower(), "pet") then
                table.insert(itemNameTable, v)
            end
        end
    end
    return itemNameTable
end

-- Define function to filter items to sell
function ToSell()
    local rarity
    local itemToSell = {}
    local itemTypeTable = getItemList()
    local itemNameTable = getItemName()
    for a, b in pairs(itemNameTable) do
        for c, d in pairs(itemTypeTable) do
            if d.Name == tostring(b) then
                rarity = d.Rarity
                if getgenv().Common and rarity == 1 then
                    table.insert(itemToSell, b)
                end
                if getgenv().Uncommon and rarity == 2 then
                    table.insert(itemToSell, b)
                end
                if getgenv().Rare and rarity == 3 then
                    table.insert(itemToSell, b)
                end
                if getgenv().Epic and rarity == 4 then
                    table.insert(itemToSell, b)
                end
                if getgenv().Legendary and rarity == 5 then
                    table.insert(itemToSell, b)
                end
            end
        end
    end
    return itemToSell
end

-- Define function to sell items
function SellItem()
    local itemToSell = ToSell()
    if #itemToSell > 0 then
        print("Selling items: " .. #itemToSell) -- Debug print
        for _, item in ipairs(itemToSell) do
            print("Selling item: " .. item.Name) -- Debug print
        end
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage").Shared.Drops.SellItems:InvokeServer(itemToSell)
        end)
        if not success then
            warn("Failed to sell items: " .. tostring(result))
        end
    else
        print("No items to sell") -- Debug print
    end
end

-- Define function to run sell item continuously
function ContinuousSellItem()
    while true do
        SellItem()
        wait(10) -- Adjust the wait time as needed
    end
end

-- Start a coroutine to run sell item continuously
task.spawn(ContinuousSellItem)

-- Path to PurchasePrompt
local purchasePrompt = game.CoreGui:WaitForChild("PurchasePrompt")

-- Function to check and destroy RobuxUpsellContainer if it becomes visible
local function checkAndDestroy(container)
    if container.Visible then
        container:Destroy()
    else
        container:GetPropertyChangedSignal("Visible"):Connect(function()
            if container.Visible then
                container:Destroy()
            end
        end)
    end
end

-- Connect to the event when a new child object is added to PurchasePrompt
purchasePrompt.ChildAdded:Connect(function(child)
    if child.Name == "RobuxUpsellContainer" then
        checkAndDestroy(child)
    end
end)

-- Check if RobuxUpsellContainer already exists
local existingContainer = purchasePrompt:FindFirstChild("RobuxUpsellContainer")
if existingContainer then
    checkAndDestroy(existingContainer)
end

-- dungon ids
local a0 = {
    [2978696440] = 1,
    [4310464656] = 3,
    [4310476380] = 2,
    [4310478830] = 4,
    [3383444582] = 6,
    [3885726701] = 11,
    [3994953548] = 12,
    [4050468028] = 13,
    [3165900886] = 7,
    [4465988196] = 14,
    [4465989351] = 15,
    [4465989998] = 16,
    [4646473427] = 20,
    [4646475342] = 19,
    [4646475570] = 18,
    [6386112652] = 24,
    [11466514043] = 35,
    [6510862058] = 25,
    [11533444995] = 36,
    [6847034886] = 26,
    [11644048314] = 37,
    [9944263348] = 30,
    [10014664329] = 31,
    [10651527284] = 32,
    [10727165164] = 33,
    [5703353651] = 21,
    [6075085184] = 23,
    [7071564842] = 27,
    [10089970465] = 29,
    [10795158121] = 34,
    [5862277651] = 22,
    [4526768588] = 17
}

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    -- Find DamagePartVisual and BillboardGui
    local Camera = game.Workspace.Camera
    local DamagePartVisual = Camera:FindFirstChild("DamagePartVisual")
    if DamagePartVisual then
        -- Delete DamagePartVisual completely if not necessary
        DamagePartVisual:Destroy()
    end
end)

local a = setmetatable({}, {
    __index = function(self, b)
        return game:GetService(b)
    end
})

local c = a.CoreGui
local d = a.Players
local wkspce = a.Workspace
local f = a.RunService
local g = a.StarterGui
local h = a.HttpService
local i = a.TweenService
local j = a.UserInputService
local k = a.ReplicatedStorage
local l = a.MarketplaceService
local m = a.VirtualInputManager
local n = {
    country = "twist",
    city = "v5.2"
}

-- define function to get ip address, country, city
a.NetworkClient.ConnectionAccepted:Connect(function(o, p)
    local q = o:sub(1, o:find("|") - 1)
    n = a.HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/" .. q))
end)
--
-- define function to create loading ui, and run it
--
local r = {
    ["createUi"] = function(s, t)
        local u = {"MAI HOÀNG PHI", "🍊🍊🍊🍊🍊🍊🍊", "twist\nWorld Zero"}
        local v = {{
            ["Image"] = "rbxassetid://3926305904",
            ["RectOffset"] = Vector2.new(204, 844),
            ["RectSize"] = Vector2.new(36, 36)
        }, {
            ["Image"] = "rbxassetid://3926305904",
            ["RectOffset"] = Vector2.new(644, 204),
            ["RectSize"] = Vector2.new(36, 36)
        }, {
            ["Image"] = "rbxassetid://3926305904",
            ["RectOffset"] = Vector2.new(324, 244),
            ["RectSize"] = Vector2.new(36, 36)
        }}

        -- Create ScreenGui and add to CoreGui
        local w = Instance.new("ScreenGui", game.CoreGui)
        local x = Instance.new("ImageLabel", w)
        local y = Instance.new("TextLabel", x)
        local z = Instance.new("ImageLabel", x)

        -- Set properties of ScreenGui and its elements
        w.Name = "ui" .. tostring(math.random(1, 1000))

        x.Size = UDim2.new(0, 0, 0, 0)
        x.Position = UDim2.new(0.5, 0, 0.75, 0)
        x.Image = "rbxassetid://3570695787"
        x.ImageColor3 = Color3.fromRGB(25, 25, 25)
        x.BackgroundTransparency = 1
        x.SliceCenter = Rect.new(100, 100, 100, 100)
        x.ScaleType = Enum.ScaleType.Slice
        x.SliceScale = 0.12

        y.Font = Enum.Font.LuckiestGuy
        y.TextColor3 = Color3.fromRGB(255, 255, 255)
        y.TextSize = 16 -- Smaller font size
        y.Text = ""
        y.TextWrapped = true
        y.Size = UDim2.new(1, -30, 1, 0) -- Smaller size
        y.Position = UDim2.new(0, 30, 0, 0)
        y.BackgroundTransparency = 1

        z.Size = UDim2.new(0, 30, 0, 30) -- Smaller size
        z.ImageColor3 = Color3.fromRGB(38, 255, 0)
        z.Position = UDim2.new(0, 10, 0.5, -15) -- Adjust position according to the new size
        z.BackgroundTransparency = 1
        z.Image = ""

        -- Perform Tween to create expansion and movement effects
        x:TweenSize(UDim2.new(0, 150, 0, 50))
        x:TweenPosition(UDim2.new(0.5, -75, 0.75, -25))

        wait(0.5)

        for A, B in pairs(u) do
            z.Image = v[A]["Image"]
            z.ImageRectOffset = v[A]["RectOffset"]
            z.ImageRectSize = v[A]["RectSize"]

            for C = 1, #u[A] do
                y.Text = string.sub(u[A], 0, C)
                wait(0.05)
            end

            wait(0.33)

            for C = 1, #u[A] do
                y.Text = string.sub(u[A], 0, #u[A] - C)
                wait(0.05)
            end

            if A ~= #u then
                wait(0.5)
            end
        end

        z.Visible = false

        -- Perform Tween to create a smaller effect and move back to the original position
        x:TweenSize(UDim2.new(0, 0, 0, 0))
        x:TweenPosition(UDim2.new(0.5, 0, 0.75, 0))

        wait(0.25)

        w:Destroy()
        pcall(t)
    end
}
pcall(r.createUi, "Twist", function()
end)
local D = d.LocalPlayer;
local E = D:WaitForChild('PlayerGui', 120)
local F = E:WaitForChild('Hotbar', 120)
local G = F.Hotbar.Vitals.Level.Visible;
while not G do
    wait()
end
local H = d.LocalPlayer;
local I = H.Character or H.CharacterAdded:Wait()
local J = I:WaitForChild('HumanoidRootPart', 180)
local K = I:WaitForChild("Humanoid") or I:FindFirstChildOfClass("Humanoid")
local L = require(k.Shared.Mobs)
local M = require(k.Shared.Items)
local N = require(k.Shared.Drops)
local O = require(k.Shared.Skills)
local P = require(k.Client.Camera)
local Q = require(k.Shared.Combat)
local R = require(k.Client.Actions)
local S = require(k.Shared.Missions)
local T = require(k.Shared.Gear.GearPerks)
local U = require(k.Client.Gui.GuiScripts.Hotbar)
local V = require(k.Shared.Teleport.WorldData)
local W = require(k.Shared.Combat.Skillsets.Warlord)
local X = require(k.Shared.Combat.Skillsets.Summoner)
repeat
    wait()
until k:WaitForChild('Profiles'):FindFirstChild(H.Name)
-- dungon ids
local dungeonIds = {
    [1.1] = 2978696440,
    [1.2] = 4310464656,
    [1.3] = 4310476380,
    [1.4] = 4310478830,
    [1] = 3383444582,
    [2.1] = 3885726701,
    [2.2] = 3994953548,
    [2.3] = 4050468028,
    [2] = 3165900886,
    [3.1] = 4465988196,
    [3.2] = 4465989351,
    [3] = 4465989998,
    [4.1] = 4646473427,
    [4.2] = 4646475342,
    [4] = 4646475570,
    [5.1] = 6386112652,
    [5.2] = 11466514043,
    [6.1] = 6510862058,
    [6.2] = 11533444995,
    [7.1] = 6847034886,
    [7.2] = 11644048314,
    [8.1] = 9944263348,
    [8.2] = 10014664329,
    [9.1] = 10651527284,
    [9.2] = 10727165164,
    [10.1] = 14914700740,
    [10.2] = 14914855930,
    ["HalloweenHub"] = 5862277651,
    ["HolidayEventDungeon"] = 4526768588
}
-- tower ids
local towerIds = {
    [1] = 5703353651,
    [2] = 6075085184,
    [3] = 7071564842,
    [4] = 10089970465,
    [5] = 10795158121,
    [6] = 15121292578,
    [50] = 14400549310,
    [51] = 13988110964
}
-- open world 
local worldIds = {
    [1] = 4310463616,
    [2] = 4310463940,
    [3] = 4465987684,
    [4] = 4646472003,
    [5] = 5703355191,
    [6] = 6075083204,
    [7] = 6847035264,
    [8] = 9944262922,
    [9] = 10651517727,
    [10] = 14914684761
}

-- quit in open world

for _, wId in pairs(worldIds) do
    if game.PlaceId == wId then
        print("quit in open world")
        return
    end
end

local eggs = {'MoltenEgg', 'OceanEgg', 'CatEgg', 'AlligatorEgg', 'FairyEgg'}
local a2 = {'SummonerSummonWeak', 'SummonerSummonStrong', 'CorruptedGreaterTree', 'DavyJones', 'BOSSHogRider',
            'BOSSAnubis', 'BOSSKrakenArm3-Arm#1', 'BOSSKrakenArm3-Arm#2', 'BOSSKrakenArm3-Arm#3',
            'BOSSKrakenArm3-Arm#4', 'BOSSKrakenArm3-Arm#5', 'BOSSKrakenArm3-Arm#6', 'BOSSKrakenArm3-Arm#7',
            'BOSSKrakenArm3-Arm#8'}
local a3 = 0;
local a4 = 9 / 64;
local a5 = 0;
local a6 = 0;
local a7 = 0;
local a8 = 360;
local a9 = 5;
local aa = 0;
local ab = 0;
local ac = 5 / 64;
local ad = I.Properties.Class.Value;
local ae = {
    ['DualWielder'] = {'DualWield1', 'DualWield2', 'DualWield3', 'DualWield4', 'DualWield5', 'DualWield6', 'DualWield7',
                       'DualWield8', 'DualWield9', 'DualWield10'},
    ['Guardian'] = {'Guardian1', 'Guardian2', 'Guardian3', 'Guardian4'},
    ['Dragoon'] = {'Dragoon1', 'Dragoon2', 'Dragoon3', 'Dragoon4', 'Dragoon5', 'Dragoon6'},
    ['Demon'] = {'Demon1', 'Demon2', 'Demon3', 'Demon4', 'Demon5', 'Demon6', 'Demon7', 'Demon8', 'Demon9', 'Demon10',
                 'Demon11', 'Demon12', 'Demon13', 'Demon14', 'Demon15', 'Demon16', 'Demon17', 'Demon18', 'Demon19',
                 'Demon20', 'Demon21', 'Demon22', 'Demon23', 'Demon24', 'Demon25'},
    ['Warlord'] = {'Warlord1', 'Warlord2', 'Warlord3', 'Warlord4'}
}
local af = ae[ad]
local isfile = isfile or is_file;
local isfolder = isfolder or is_folder;
local writefile = writefile or write_file;
local makefolder = makefolder or make_folder or createfolder or create_folder;
if makefolder then
    if not isfolder("WorldZero") then
        makefolder("WorldZero")
    end
end
local function ag(ah, ai)
    if isfile("WorldZero//" .. ah .. '.txt') then
        local aj = h:JSONDecode(readfile("WorldZero//" .. ah .. '.txt'))
        table.clear(ai)
        for A, B in pairs(aj) do
            ai[A] = B
        end
    else
        writefile("WorldZero//" .. ah .. '.txt', h:JSONEncode(ai))
    end
end
local function ak(ah, ai)
    writefile("WorldZero//" .. ah .. '.txt', h:JSONEncode(ai))
end
local al = {KillAura, PetSkill, AutoFarm, GetDrop, NoClip, InfJump, ReLoadOnHop, ReduceLag, RepeatRaid, NoCutScene,
            DelEgg, SellNonLegend, AutoSwitch, SellLegend, AiPing, MoLPass, MaxPerk, HPHalf, KlausDown}
ag('WZ_Toggles', al)
local am = {
    Webhook = 'https://discord.com/api/webhooks/1249664506448187443/2me_mJp4i155tl1fayEFVaYIS-yzp9FNqQAGRyI1v4xe56MYdc8KDYBaA9Yw4Vevl3jw'
}
ag('WZwebhook', am)
local an = syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport or queue_on_teleport;
local ao = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/maihoangphi2531/worldzero/main/test"))()'
local ap = {
    DungeonID = a0[game.PlaceId],
    DifficultyID = S.GetDifficulty(),
    ProfileGUID = k.Profiles[H.Name].GUID.Value
}
ak('WZ_Kick', ap)
local aq = {
    ['Swordmaster'] = {
        Swordmaster1 = {
            last = 0,
            cooldown = .26
        },
        Swordmaster2 = {
            last = 0,
            cooldown = .26
        },
        Swordmaster3 = {
            last = 0,
            cooldown = .26
        },
        Swordmaster4 = {
            last = 0,
            cooldown = .26
        },
        Swordmaster5 = {
            last = 0,
            cooldown = .26
        },
        Swordmaster6 = {
            last = 0,
            cooldown = .26
        }
    },
    ['Defender'] = {
        Defender1 = {
            last = 0,
            cooldown = .6
        },
        Defender2 = {
            last = 0,
            cooldown = .6
        },
        Defender3 = {
            last = 0,
            cooldown = .6
        },
        Defender4 = {
            last = 0,
            cooldown = .6
        },
        Defender5 = {
            last = 0,
            cooldown = .6
        }
    },
    ['DualWielder'] = {
        CrossSlash1 = {
            last = 0,
            cooldown = 6
        },
        CrossSlash2 = {
            last = 0,
            cooldown = 6
        },
        CrossSlash3 = {
            last = 0,
            cooldown = 6
        },
        CrossSlash4 = {
            last = 0,
            cooldown = 6
        },
        CrossSlash5 = {
            last = 0,
            cooldown = 6
        },
        CrossSlash6 = {
            last = 0,
            cooldown = 6
        },
        DashStrike = {
            last = 0,
            cooldown = 6
        },
        DualWieldUltimateHit1 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit2 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit3 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit4 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit5 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit6 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit7 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateHit8 = {
            last = 0,
            cooldown = 30
        }
    },
    ['Berserker'] = {
        Berserker1 = {
            last = 0,
            cooldown = 1 / 2
        },
        Berserker2 = {
            last = 0,
            cooldown = 1 / 2
        },
        Berserker3 = {
            last = 0,
            cooldown = 1 / 2
        },
        Berserker4 = {
            last = 0,
            cooldown = 1 / 2
        },
        Berserker5 = {
            last = 0,
            cooldown = 1 / 2
        },
        Berserker6 = {
            last = 0,
            cooldown = 1 / 2
        },
        Fissure1 = {
            last = 0,
            cooldown = 10
        },
        Fissure2 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt1 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt2 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt3 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt4 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt5 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt6 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt7 = {
            last = 0,
            cooldown = 10
        },
        FissureErupt8 = {
            last = 0,
            cooldown = 10
        }
    },
    ['Paladin'] = {
        Paladin1 = {
            last = 0,
            cooldown = 1 / 2
        },
        Paladin2 = {
            last = 0,
            cooldown = 1 / 2
        },
        Paladin3 = {
            last = 0,
            cooldown = 1 / 2
        },
        Paladin4 = {
            last = 0,
            cooldown = 1 / 2
        },
        LightPaladin1 = {
            last = 0,
            cooldown = 3 / 4
        },
        LightPaladin2 = {
            last = 0,
            cooldown = 3 / 4
        },
        LightPaladin3 = {
            last = 0,
            cooldown = 3 / 4
        },
        LightPaladin4 = {
            last = 0,
            cooldown = 3 / 4
        }
    },
    ['Demon'] = {
        DemonDPS1 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS2 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS3 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS4 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS5 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS6 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS7 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS8 = {
            last = 0,
            cooldown = 2.8
        },
        DemonDPS9 = {
            last = 0,
            cooldown = 2.8
        }
    }
}
local ar = {
    ['Mage'] = {
        Mage1 = {
            last = 0,
            cooldown = .3
        },
        Mage2 = {
            last = 0,
            cooldown = .3
        },
        Mage3 = {
            last = 0,
            cooldown = .3
        },
        ArcaneBlast = {
            last = 0,
            cooldown = 5
        },
        ArcaneWave1 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave2 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave3 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave4 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave5 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave6 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave7 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave8 = {
            last = 0,
            cooldown = 8
        },
        ArcaneWave9 = {
            last = 0,
            cooldown = 8
        },
        ArcaneBlastAOE = {
            last = 0,
            cooldown = 15
        }
    },
    ['IcefireMage'] = {
        IcefireMage1 = {
            last = 0,
            cooldown = .3
        },
        IcefireMage2 = {
            last = 0,
            cooldown = .3
        },
        IcefireMage3 = {
            last = 0,
            cooldown = .3
        },
        IcySpikes1 = {
            last = 0,
            cooldown = 6
        },
        IcySpikes2 = {
            last = 0,
            cooldown = 6
        },
        IcySpikes3 = {
            last = 0,
            cooldown = 6
        },
        IcySpikes4 = {
            last = 0,
            cooldown = 6
        },
        IcySpikes5 = {
            last = 0,
            cooldown = 6
        },
        IcefireMageFireball = {
            last = 0,
            cooldown = 10
        },
        IcefireMageFireballBlast = {
            last = 0,
            cooldown = 10
        },
        LightningStrike1 = {
            last = 0,
            cooldown = 15
        },
        LightningStrike2 = {
            last = 0,
            cooldown = 15
        },
        LightningStrike3 = {
            last = 0,
            cooldown = 15
        },
        LightningStrike4 = {
            last = 0,
            cooldown = 15
        },
        LightningStrike5 = {
            last = 0,
            cooldown = 15
        },
        IcefireMageUltimateFrost = {
            last = 0,
            cooldown = 20
        },
        IcefireMageUltimateMeteor1 = {
            last = 0,
            cooldown = 20
        },
        IcefireMageUltimateMeteor2 = {
            last = 0,
            cooldown = 20
        },
        IcefireMageUltimateMeteor3 = {
            last = 0,
            cooldown = 20
        },
        IcefireMageUltimateMeteor4 = {
            last = 0,
            cooldown = 20
        }
    },
    ['DualWielder'] = {
        DualWieldUltimateSlam = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSlam1 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSlam2 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSlam3 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword1 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword2 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword3 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword4 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword5 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword6 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword7 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword8 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword9 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword10 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword11 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword12 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword13 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword14 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword15 = {
            last = 0,
            cooldown = 30
        },
        DualWieldUltimateSword16 = {
            last = 0,
            cooldown = 30
        }
    },
    ['Guardian'] = {
        RockSpikes1 = {
            last = 0,
            cooldown = 6
        },
        RockSpikes2 = {
            last = 0,
            cooldown = 6
        },
        RockSpikes3 = {
            last = 0,
            cooldown = 6
        },
        RockSpikes4 = {
            last = 0,
            cooldown = 6
        },
        RockSpikes5 = {
            last = 0,
            cooldown = 6
        },
        SlashFury1 = {
            last = 0,
            cooldown = 8
        },
        SlashFury2 = {
            last = 0,
            cooldown = 8
        },
        SlashFury3 = {
            last = 0,
            cooldown = 8
        },
        SlashFury4 = {
            last = 0,
            cooldown = 8
        },
        SlashFury5 = {
            last = 0,
            cooldown = 8
        },
        SlashFury6 = {
            last = 0,
            cooldown = 8
        },
        SlashFury7 = {
            last = 0,
            cooldown = 8
        },
        SlashFury8 = {
            last = 0,
            cooldown = 8
        },
        SlashFury9 = {
            last = 0,
            cooldown = 8
        },
        SlashFury10 = {
            last = 0,
            cooldown = 8
        },
        SlashFury11 = {
            last = 0,
            cooldown = 8
        },
        SlashFury12 = {
            last = 0,
            cooldown = 8
        },
        SlashFury13 = {
            last = 0,
            cooldown = 8
        },
        SlashFury14 = {
            last = 0,
            cooldown = 8
        },
        SlashFury15 = {
            last = 0,
            cooldown = 8
        },
        SlashFury16 = {
            last = 0,
            cooldown = 8
        }
    },
    ['Berserker'] = {
        AggroSlam = {
            last = 0,
            cooldown = 5
        },
        GigaSpin1 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin2 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin3 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin4 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin5 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin6 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin7 = {
            last = 0,
            cooldown = 7
        },
        GigaSpin8 = {
            last = 0,
            cooldown = 7
        }
    },
    ['Paladin'] = {
        LightThrust1 = {
            last = 0,
            cooldown = 11
        },
        LightThrust2 = {
            last = 0,
            cooldown = 11
        }
    },
    ['MageOfLight'] = {
        MageOfLight = {
            last = 0,
            cooldown = 1 / 4
        },
        MageOfLightBlast = {
            last = 0,
            cooldown = .3
        },
        MageOfLightCharged = {
            last = 0,
            cooldown = .2
        },
        MageOfLightBlastCharged = {
            last = 0,
            cooldown = .1
        }
    },
    ['Demon'] = {
        ScytheThrowDPS1 = {
            last = 0,
            cooldown = 10
        },
        ScytheThrowDPS2 = {
            last = 0,
            cooldown = 10
        },
        ScytheThrowDPS3 = {
            last = 0,
            cooldown = 10
        },
        DemonSoulAOE1 = {
            last = 0,
            cooldown = 15
        },
        DemonSoulAOE2 = {
            last = 0,
            cooldown = 15
        },
        DemonSoulAOE3 = {
            last = 0,
            cooldown = 15
        },
        DemonSoulAOE4 = {
            last = 0,
            cooldown = 15
        },
        DemonLifeStealDPS = {
            last = 0,
            cooldown = 16
        },
        DemonLifeStealAOE = {
            last = 0,
            cooldown = 16
        }
    },
    ['Archer'] = {
        Archer = {
            last = 0,
            cooldown = 1 / 2
        },
        PiercingArrow1 = {
            last = 0,
            cooldown = 5
        },
        PiercingArrow2 = {
            last = 0,
            cooldown = 5
        },
        PiercingArrow3 = {
            last = 0,
            cooldown = 5
        },
        PiercingArrow4 = {
            last = 0,
            cooldown = 5
        },
        PiercingArrow5 = {
            last = 0,
            cooldown = 5
        },
        SpiritBomb = {
            last = 0,
            cooldown = 10
        },
        MortarStrike1 = {
            last = 0,
            cooldown = 12
        },
        MortarStrike2 = {
            last = 0,
            cooldown = 12
        },
        MortarStrike3 = {
            last = 0,
            cooldown = 12
        },
        MortarStrike4 = {
            last = 0,
            cooldown = 12
        },
        MortarStrike5 = {
            last = 0,
            cooldown = 12
        },
        HeavenlySword = {
            last = 0,
            cooldown = 20
        }
    },
    ['Dragoon'] = {
        DragoonCross1 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross2 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross3 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross4 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross5 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross6 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross7 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross8 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross9 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonCross10 = {
            last = 0,
            cooldown = 5.5
        },
        DragoonDash = {
            last = 0,
            cooldown = 10
        },
        MultiStrikeDragon1 = {
            last = 0,
            cooldown = 12
        },
        MultiStrikeDragon2 = {
            last = 0,
            cooldown = 12
        },
        MultiStrikeDragon3 = {
            last = 0,
            cooldown = 12
        },
        MultiStrikeDragon4 = {
            last = 0,
            cooldown = 12
        },
        MultiStrikeDragon5 = {
            last = 0,
            cooldown = 12
        },
        MultiStrikeDragon6 = {
            last = 0,
            cooldown = 13
        },
        DragoonFall = {
            last = 0,
            cooldown = 12
        },
        DragoonUltimate = {
            last = 0,
            cooldown = 30
        }
    },
    ['Summoner'] = {
        Summoner1 = {
            last = 0,
            cooldown = .01
        },
        Summoner2 = {
            last = 0,
            cooldown = .01
        },
        Summoner3 = {
            last = 0,
            cooldown = .01
        },
        Summoner4 = {
            last = 0,
            cooldown = .01
        }
    },
    ['Warlord'] = {
        Piledriver1 = {
            last = 0,
            cooldown = 3
        },
        Piledriver2 = {
            last = 0,
            cooldown = 3
        },
        Piledriver3 = {
            last = 0,
            cooldown = 3
        },
        Piledriver4 = {
            last = 0,
            cooldown = 3
        },
        ChainsOfWar = {
            last = 0,
            cooldown = 6
        },
        BlockingWarlord = {
            last = 0,
            cooldown = 10
        },
        WarlordUltimate1 = {
            last = 0,
            cooldown = 15
        },
        WarlordUltimate2 = {
            last = 0,
            cooldown = 15
        },
        WarlordUltimate3 = {
            last = 0,
            cooldown = 15
        },
        WarlordUltimate4 = {
            last = 0,
            cooldown = 15
        },
        WarlordUltimate5 = {
            last = 0,
            cooldown = 15
        }
    }
}
local function as(at)
    local au = {"", "K", "M", "B", "T"}
    for A, av in ipairs(au) do
        if at < 1000 then
            return string.format("%.1f%s", at, av)
        end
        at = at / 1000
    end
    return string.format("%.1f%s", at, "P")
end
local function aw(b)
    m:SendKeyEvent(true, b, false, game)
end
local function ax(b)
    m:SendKeyEvent(false, b, false, game)
end
local function ay()
    local az = {'Swordmaster', 'Defender', 'DualWielder', 'Berserker', 'Guardian', 'Paladin', 'Dragoon', 'Demon',
                'Warlord'}
    for aA, aB in ipairs(az) do
        if ad == aB then
            return true
        end
    end
    return false
end
local function aC()
    local aD = {'Mage', 'IcefireMage', 'MageOfLight', 'Archer', 'Summoner'}
    for aA, aB in ipairs(aD) do
        if ad == aB then
            return true
        end
    end
    return false
end
local function aE(aa)
    return os.clock() - aa > ac
end
local function aF()
    local aG = k.Profiles[H.Name].Equip.Offhand;
    return not aG:IsEmpty()
end
function IsAlive()
    local aH = game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    return aH ~= nil
end
local function aI(aJ)
    if IsAlive() then
        J.CanCollide = aJ
    end
end
local function aK()
    if not J:FindFirstChild('BodyVelocity') then
        local aL = Instance.new 'BodyVelocity'
        aL.Velocity = Vector3.new(0, 0, 0)
        aL.MaxForce = Vector3.new(900000, 900000, 900000)
        aL.P = 9000;
        aL.Parent = J
    end
end
local function aM()
    for aA, B in pairs(J:GetChildren()) do
        if B:IsA('BodyVelocity') then
            B:Destroy()
        end
    end
end

local function aP()
    if IsAlive() then
        for aA, B in pairs(I:GetChildren()) do
            if B:IsA('BasePart') and B.Name == 'Collider' then
                B.Touched:Connect(function(aQ)
                    if aQ:IsA('BasePart') and aQ.Transparency ~= 1 then
                        if aQ.Parent ~= I then
                            local aR = .3;
                            aQ.Transparency = aR;
                            local aS = Color3.fromRGB(140, 140, 140)
                            aQ.Color = aS
                        end
                    end
                end)
            end
        end
    end
end
local function aT(aU)
    m:SendMouseButtonEvent(aU.AbsolutePosition.X + aU.AbsoluteSize.X / 2, aU.AbsolutePosition.Y + 50, 0, true, aU, 1)
    m:SendMouseButtonEvent(aU.AbsolutePosition.X + aU.AbsoluteSize.X / 2, aU.AbsolutePosition.Y + 50, 0, false, aU, 1)
end
local function aV(aW)
    local aX = k.Profiles[H.Name].Equip.Offhand:FindFirstChildOfClass("Folder")
    local aY = aW.HealthProperties;
    local aZ = aY.MaxHealth;
    local a_ = require(k.Shared.Mobs).IsElite;
    local b0 = require(k.Shared.Mobs.Mobs[aW.Name])
    local b1 = ''
    if b0.BossTag ~= false then
        b1 = 'TestTier5'
    elseif b0.BossTag == false then
        if a_(aW) then
            b1 = 'EliteBoss'
        else
            b1 = 'MobBoss'
        end
    end
    if math.floor(aY.Health.Value / aZ.Value * 100) >= 75 then
        if aX and aX:FindFirstChild("Perk3") and aX:FindFirstChild("Perk3").Value == 'OpeningStrike' then
            k.Shared.Settings.OffhandPerksActive:FireServer(true)
            repeat
                wait()
            until math.floor(aY.Health / aZ * 100) < 75
        else
            k.Shared.Settings.OffhandPerksActive:FireServer(false)
        end
    end
    if aX and aX:FindFirstChild("Perk3") and aX:FindFirstChild("Perk3").Value == b1 then
        k.Shared.Settings.OffhandPerksActive:FireServer(true)
    else
        k.Shared.Settings.OffhandPerksActive:FireServer(false)
    end
end
local b2 = 100;
local b3 = f.Heartbeat;
local function b4(aW)
    if typeof(aW) == "Instance" and aW:IsA("BasePart") then
        aW = aW.Position
    end
    if typeof(aW) == "CFrame" then
        aW = aW.p
    end
    if not J then
        return
    end
    local b5 = J.Position;
    local b6 = aW - b5;
    local b7 = tick()
    local b8 = (b5 - aW).magnitude / b2;
    repeat
        b3:Wait()
        local b9 = tick() - b7;
        local ba = math.min(b9 / b8, 1)
        local bb = b5 + b6 * ba;
        J.Velocity = Vector3.new()
        J.CFrame = CFrame.new(bb)
    until (J.Position - aW).magnitude <= b2 / 2;
    J.Anchored = false;
    local bc, bd, be = 0, 0, 12;
    J.CFrame = CFrame.new(aW) + Vector3.new(bc, bd, be)
end
local function bf(bg)
    bg = 0;
    task.spawn(function()
        while al.KillAura do
            local bh = math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
            if bh > 150 and al.AiPing then
                bg = bh / 1200
            else
                bg = 0
            end
            task.wait()
        end
    end)
    return bg
end
local function bi(aW)
    local bj = math.huge;
    for aA, B in pairs(wkspce.Mobs:GetChildren()) do
        if not table.find(a2, B.Name) then
            if B:FindFirstChild('Collider') and B:FindFirstChild('HealthProperties') and
                not B:FindFirstChild('NoHealthbar') then
                local b9 = math.floor((J.Position - B.WorldPivot.Position).Magnitude)
                if b9 <= bj and B.HealthProperties.Health.Value > 0 then
                    bj = b9;
                    aW = B.Collider
                end
            end
        end
    end
    if game.PlaceId == dungeonIds[1] then
        if wkspce.Mobs:FindFirstChild('BOSSTreeEnt') and wkspce.Mobs.BOSSTreeEnt.HealthProperties.Health.Value /
            wkspce.Mobs.BOSSTreeEnt.HealthProperties.MaxHealth.Value * 100 <= 50 then
            for A = 1, 3 do
                local bk = wkspce:WaitForChild('Pillar' .. A)
                if bk:FindFirstChild('HealthProperties') and bk.HealthProperties.Health.Value ~= 0 then
                    aW = bk.Base
                end
            end
        end
    end
    if game.PlaceId == dungeonIds[3.2] then
        if H.PlayerGui.MissionObjective.MissionObjective.Label.Text == 'Destroy the Ice Barricade!' then
            if wkspce.MissionObjects.IceBarricade:FindFirstChild('HealthProperties') and
                wkspce.MissionObjects.IceBarricade.HealthProperties.Health.Value ~= 0 then
                aW = wkspce.MissionObjects.IceBarricade.Part
            end
        end
    end
    if game.PlaceId == dungeonIds[3] then
        if game.PlaceId == dungeonIds[3] then
            for A = 1, 3 do
                local bl = wkspce.MissionObjects.SpikeCheckpoints:WaitForChild('Blocker' .. A)
                if bl:FindFirstChild('HealthProperties') and bl.HealthProperties.Health.Value ~= 0 then
                    aW = bl.Part
                end
            end
        end
        if wkspce.Mobs:FindFirstChild('BOSSWinterfallIceDragon') and wkspce.Mobs.BOSSWinterfallIceDragon.Collider.Position.y > 300 then
            aW = nil
        end
    end
    if game.PlaceId == dungeonIds[4.1] then
        if wkspce.MissionObjects.TowerLegs:FindFirstChild('Model') and
            wkspce.MissionObjects.TowerLegs.Model:FindFirstChild('HealthProperties') then
            aW = wkspce.MissionObjects.TowerLegs.Model.hitbox
        end
        if wkspce.Mobs:FindFirstChild('BOSSHogRider') and wkspce.Mobs.BOSSHogRider.Collider.Position.y < 380 then
            aW = wkspce.Mobs.BOSSHogRider.Collider
        end
    end
    if game.PlaceId == dungeonIds[4] then
        if wkspce.Mobs:FindFirstChild('BOSSAnubis') then
            if not wkspce.Mobs.BOSSAnubis.MobProperties.Busy:FindFirstChild('Shield') then
                aW = wkspce.Mobs.BOSSAnubis.Collider
            end
        end
    end
    if game.PlaceId == dungeonIds[5.1] and wkspce.Mobs:FindFirstChild('CorruptedGreaterTree') then
        if not wkspce:FindFirstChild('GreaterTreeShield') then
            aW = wkspce.Mobs.CorruptedGreaterTree.Collider
        end
    end
    if game.PlaceId == dungeonIds[6.1] then
        if wkspce.Mobs:FindFirstChild('DavyJones') and not aW then
            aW = wkspce.Mobs.DavyJones.Collider
        end
        if wkspce:FindFirstChild('TriggerBarrel') then
            aW = wkspce.TriggerBarrel.Collision
        end
    end
    if game.PlaceId == towerIds[2] then
        if wkspce.Mobs:FindFirstChild('BOSSKrakenMain') then
            for A = 1, 8 do
                local bm = workspace.Mobs:FindFirstChild('BOSSKrakenArm3-Arm#' .. A)
                if bm and bm.HealthProperties.Health.Value ~= 0 then
                    aW = bm.Subcollider.SubPrimaryPart
                end
            end
        end
    end
    return aW
end
local function bn(bo)
    local bj = math.huge;
    for aA, B in pairs(wkspce.Mobs:GetChildren()) do
        if not table.find(a2, B.Name) then
            if B:FindFirstChild('Collider') and B:FindFirstChild('HealthProperties') and
                not B:FindFirstChild('NoHealthbar') then
                local b9 = math.floor((J.Position - B.WorldPivot.Position).Magnitude)
                if b9 <= bj and B.HealthProperties.Health.Value > 0 then
                    bj = b9;
                    bo = B
                end
            end
        end
    end
    return bo
end
local function bp(bq)
    local bj = math.huge;
    if wkspce.Mobs:FindFirstChild('SummonerSummonWeak') then
        for aA, B in pairs(wkspce.Mobs:GetChildren()) do
            if not table.find(a2, B.Name) then
                if B:FindFirstChild('Collider') and B:FindFirstChild('HealthProperties') then
                    local b9 = (wkspce.Mobs.SummonerSummonWeak.WorldPivot.Position - B.WorldPivot.Position).Magnitude;
                    if b9 <= bj and B.HealthProperties.Health.Value > 8000 then
                        bj = b9;
                        bq = B.Collider
                    end
                end
            end
        end
    end
    return bq
end
if ad == 'Mage' then
    ab = 60;
    ac = ac + bf()
elseif ad == 'Swordmaster' then
    ab = 15;
    ac = ac + bf()
elseif ad == 'Defender' then
    ab = 15;
    ac = ac + bf()
elseif ad == 'DualWielder' then
    ab = 15;
    a5 = 9 / 64 + bf()
elseif ad == 'Berserker' then
    ab = 15;
    ac = ac + bf()
elseif ad == 'Guardian' then
    ab = 15;
    a5 = 1 / 3 + bf()
elseif ad == 'Paladin' then
    ab = 20;
    ac = ac + bf()
elseif ad == 'IcefireMage' then
    ab = 95;
    ac = ac + bf()
elseif ad == 'MageOfLight' then
    ab = 95;
    ac = ac + bf()
elseif ad == 'Dragoon' then
    ab = 15;
    a5 = 9 / 64 + bf()
elseif ad == 'Demon' then
    ab = 15;
    a5 = .5 + bf()
elseif ad == 'Archer' then
    ab = 80;
    ac = ac + bf()
elseif ad == 'Summoner' then
    ab = 80;
    ac = 1 / 2 + bf()
elseif ad == 'Warlord' then
    ab = 15;
    a5 = 5 / 64 + bf()
end
local function br()
    task.spawn(function()
        while al.KillAura and IsAlive() do
            local aW = bi()
            if aW and aW.Parent:FindFirstChild("HealthProperties") and aW.Parent.HealthProperties.Health.Value < 1 then
                break
            end
            if aW and (J.Position - aW.Position).Magnitude < ab then
                for bs, B in pairs(ar[ad]) do
                    if os.clock() - B.last > B.cooldown and aE(aa) then
                        Q:AttackWithSkill(bs, aW.Position)
                        B.last = os.clock()
                        aa = os.clock()
                    end
                end
            end
            task.wait()
        end
    end)
end
local function bt()
    task.spawn(function()
        while al.KillAura and IsAlive() do
            local aW = bi()
            if aW and aW.Parent:FindFirstChild("HealthProperties") and aW.Parent.HealthProperties.Health.Value < 1 then
                break
            end
            if aW and (J.Position - aW.Position).Magnitude < ab then
                for bs, B in pairs(aq[ad]) do
                    if os.clock() - B.last > B.cooldown and aE(aa) then
                        Q:AttackWithSkill(bs, J.Position, J.CFrame.lookVector)
                        B.last = os.clock()
                        aa = os.clock()
                        break
                    end
                end
            end
            task.wait()
        end
    end)
end
local function bu()
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bi()
            if aW and aW.Parent:FindFirstChild("HealthProperties") and aW.Parent.HealthProperties.Health.Value < 1 / 6 then
                break
            end
            if aW and (J.Position - aW.Position).Magnitude < ab and os.clock() - DeBounce >= a5 then
                DeBounce = os.clock()
                a3 = a3 + 1;
                Q:AttackWithSkill(af[a3], J.Position, J.CFrame.lookVector)
                f.RenderStepped:Wait()
                if a3 >= #af then
                    a3 = 0
                end
            end
            f.RenderStepped:Wait()
        end
    end)
end
local function bv()
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bi()
            if aW and aW.Parent:FindFirstChild 'HealthProperties' and aW.Parent.HealthProperties.Health.Value < 1 then
                break
            end
            if aW and (J.Position - aW.Position).Magnitude < 500 and os.clock() - DeBounce >= 12 then
                DeBounce = os.clock()
                k.Shared.Combat.Skillsets.DualWielder.AttackBuff:FireServer()
                k.Shared.Combat.Skillsets.DualWielder.UpdateSpeed:FireServer(0)
            end
            task.wait(12)
        end
    end)
end
local function bw()
    task.spawn(function()
        local bx = U.GetHotbarSkillTile('', 'Ultimate')
        while al.KillAura and IsAlive() do
            if bx.cooling and not al.KillAura then
                break
            end
            local aW = bn()
            if aW and IsAlive() then
                if aW and aW:FindFirstChild 'HealthProperties' and aW.HealthProperties.Health.Value < 1 then
                    break
                end
                m:SendKeyEvent(true, 'X', false, game)
                wait(1 / 2)
                m:SendKeyEvent(false, 'X', false, game)
            end
            task.wait(30)
        end
    end)
end
local function by()
    task.spawn(function()
        DeBounce = os.clock()
        local bx = U.GetHotbarSkillTile('', 'Ultimate')
        while al.KillAura and IsAlive() do
            if bx.cooldownTimer > 20 and not al.KillAura then
                break
            end
            if os.clock() - DeBounce >= 2 then
                DeBounce = os.clock()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                k.Shared.Combat.Skillsets.Demon.Demonic:FireServer()
                wait()
                if bx.cooldownTimer > 1 and not al.KillAura then
                    break
                end
                k.Shared.Combat.Skillsets.Demon.Ultimate:FireServer()
            end
            task.wait(30)
        end
    end)
end
local function bz()
    a6, a7, a9 = 30, 26, 6;
    task.spawn(function()
        while al.KillAura and IsAlive() do
            local aW = bn()
            local bA = R:IsOnCooldown('Ultimate')
            if aW and (J.Position - aW.Collider.Position).Magnitude < 80 and
                wkspce.Characters[H.Name].Properties.BackSwordCount.Value == 6 then
                if aW and aW.HealthProperties.Health.Value < 1 / 6 or bA then
                    break
                end
                DeBounce = os.clock()
                a6, a7, a9 = 3 / 64, 16, 66;
                task.wait(1)
                k.Shared.Combat.Skillsets.Archer.Ultimate:FireServer(aW.Collider.Position)
                task.wait(1)
                a6, a7, a9 = 26, 26, 6
            end
            task.wait(30)
        end
    end)
end
local function bB()
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bn()
            if aW and aW:FindFirstChild 'HealthProperties' and aW.HealthProperties.Health.Value < 1 / 6 then
                break
            end
            if aW and wkspce.Characters[H.Name].Properties.SummonCount.Value == 5 and os.clock() - DeBounce >= 8 then
                DeBounce = os.clock()
                X:Summon(aW.Collider.Position)
            end
            task.wait(8)
        end
    end)
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bi()
            if aW and aW.Parent:FindFirstChild 'HealthProperties' and aW.Parent.HealthProperties.Health.Value < 1 / 6 then
                break
            end
            if aW and (J.Position - aW.Position).Magnitude < 50 and os.clock() - DeBounce >= 10 then
                DeBounce = os.clock()
                k.Shared.Combat.Skillsets.Summoner.SoulHarvest:FireServer(aW.Position)
            end
            task.wait(10)
        end
    end)
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bn()
            if aW and os.clock() - DeBounce >= 30 then
                if aW and aW:FindFirstChild 'HealthProperties' and aW.HealthProperties.Health.Value < 1 / 6 then
                    break
                end
                DeBounce = os.clock()
                X:Ultimate(aW.Collider.Position)
            end
            task.wait(30)
        end
    end)
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            local aW = bp()
            if aW and wkspce.Mobs:FindFirstChild('SummonerSummonWeak') then
                if not IsAlive() then
                    break
                end
                local b9 = (wkspce.Mobs.SummonerSummonWeak.Collider.Position - aW.Position).Magnitude;
                if b9 < 8 and J and os.clock() - DeBounce >= 2 then
                    DeBounce = os.clock()
                    X:ExplodeSummons()
                end
            end
            task.wait(2)
        end
    end)
end
local function bC()
    task.spawn(function()
        local DeBounce = os.clock()
        while al.KillAura and IsAlive() do
            if not IsAlive() then
                break
            end
            if os.clock() - DeBounce >= 1 / 3 then
                DeBounce = os.clock()
                k.Shared.Combat.Skillsets.Warlord.Block:FireServer()
            end
            task.wait(1 / 3)
        end
    end)
end
local bD;
bD = wkspce.ChildAdded:Connect(function(bE)
    if bE.Name == 'RadialIndicator' then
        local bo = bn()
        if bo and not L:GetBossTag(bo) and wkspce.RadialIndicator.Inner.Size.y > 20 then
            a8 = 1
        end
    end
end)
wkspce.ChildRemoved:Connect(function(bE)
    if bE.Name == 'RadialIndicator' then
        if bD then
            bD:Disconnect()
        end
        a8 = 360
    end
end)
Library = loadstring(game:HttpGet("https://bitbucket.org/cat__/turtle-ui/raw/main/Module%20v2"), "Turtle UI")()
local bF = Library:Window({
    Title = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name,
    TextSize = 18,
    Font = Enum.Font.LuckiestGuy,
    TextColor = Color3.fromRGB(222, 248, 107),
    FrameColor = Color3.fromRGB(63, 72, 80),
    BackgroundColor = Color3.fromRGB(35, 35, 35)
})
local bG = Library:Window({
    Title = "Start: " .. os.date("%I:%M %p"),
    TextSize = 18,
    Font = Enum.Font.LuckiestGuy,
    TextColor = Color3.fromRGB(222, 248, 107),
    FrameColor = Color3.fromRGB(63, 72, 80),
    BackgroundColor = Color3.fromRGB(35, 35, 35)
})
local bH = Library:Window({
    Title = n.country .. " | " .. n.city,
    TextSize = 20,
    Font = Enum.Font.LuckiestGuy,
    TextColor = Color3.fromRGB(222, 248, 107),
    FrameColor = Color3.fromRGB(63, 72, 80),
    BackgroundColor = Color3.fromRGB(35, 35, 35)
})
local bI = Library:Window({
    Title = "Gold: " .. as(game.ReplicatedStorage.Profiles[H.Name].Currency.Gold.Value),
    TextSize = 18,
    Font = Enum.Font.LuckiestGuy,
    TextColor = Color3.fromRGB(222, 248, 107),
    FrameColor = Color3.fromRGB(63, 72, 80),
    BackgroundColor = Color3.fromRGB(35, 35, 35)
})
local KillAura = bF:Toggle({
    Text = "KillAura",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Disable = false,
    Enabled = al.KillAura,
    Callback = function(aJ)
        task.spawn(function()
            al.KillAura = aJ;
            if al.KillAura then
                ak('WZ_Toggles', al)
                if ad == 'Guardian' then
                    bw()
                elseif ad == 'Demon' then
                    by()
                elseif ad == 'Archer' then
                    bz()
                elseif ad == 'Summoner' then
                    bB()
                elseif ad == 'Warlord' then
                    bC()
                end
                for bM in pairs(ar) do
                    if bM == ad then
                        br()
                        bv()
                    end
                end
                for bM in pairs(aq) do
                    if bM == ad then
                        bt()
                        bv()
                    end
                end
                for bM in pairs(ae) do
                    if bM == ad then
                        bu()
                    end
                end
            end
        end)
    end
})
local PetSkill = bF:Toggle({
    Text = "PetSkill",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Disable = false,
    Enabled = al.PetSkill,
    Callback = function(aJ)
        task.spawn(function()
            al.PetSkill = aJ;
            ak('WZ_Toggles', al)
            while al.PetSkill do
                aw(Enum.KeyCode.One)
                wait()
                ax(Enum.KeyCode.One)
                wait(15)
            end
        end)
    end
})

local AutoFarm = bF:Toggle({
    Text = "AutoFarm",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Disable = false,
    Enabled = al.AutoFarm,
    Callback = function(aJ)
        al.AutoFarm = aJ;
        task.spawn(function()
            ak('WZ_Toggles', al)
            aK()
            aP()
            aI(false)
            if aC() then
                a6, a7, a9 = 36, 30, 6
            elseif ay() then
                a6, a7, a9 = .1, 14, 5
            end
            if not al.AutoFarm then
                aI(true)
                aM()
            end
        end)
        task.spawn(function()
            local bN;
            local bO = TweenInfo.new(a4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            while al.AutoFarm do
                local aW = bi()
                if aW and aW.Parent:FindFirstChild('HealthProperties') and aW.Parent.HealthProperties.Health.Value < 1 /
                    6 then
                    break
                end
                if aW then
                    local bP = a8 * (tick() % a9) / a9;
                    bN = i:Create(J, bO, {
                        CFrame = CFrame.new(aW.Position) * CFrame.Angles(0, math.rad(bP), 0) * CFrame.new(0, a6, a7)
                    })
                    bN:Play()
                end
                f.Heartbeat:Wait()
            end
            if bN and bN.PlaybackState == Enum.PlaybackState.Playing then
                bN:Cancel()
            end
            if not al.AutoFarm then
                aM()
            end
        end)
    end
})
al.GetDrop = true
local bQ = bF:Toggle({
    Text = "GetDrops",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Enabled = al.GetDrop,
    Callback = function(aJ)
        al.GetDrop = aJ;
        task.spawn(function()
            ak('WZ_Toggles', al)
            local bR = getupvalue(N.Start, 4)
            while al.GetDrop do
                if not al.GetDrop then
                    break
                end
                for A, B in pairs(bR) do
                    B.model:Destroy()
                    B.followPart:Destroy()
                    k.Shared.Drops.CoinEvent:FireServer(B.id)
                    table.remove(bR, A)
                end
                task.wait(1 / 3)
            end
        end)
    end
})
al.DelEgg=true
local c9 = bG:Toggle({
    Text = "DeleteEggs",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Enabled = al.DelEgg,
    Callback = function(aJ)
        al.DelEgg = aJ;
        task.spawn(function()
            ak('WZ_Toggles', al)
            local ca = k.Profiles[H.Name].Inventory.Items;
            ca.DescendantAdded:Connect(function()
                for aA, B in pairs(ca:GetChildren()) do
                    if string.find(B.Name, "Egg") then
                        k.Shared.Inventory.DeleteItem:FireServer(B)
                    end
                end
            end)
            H.CharacterAdded:Connect(function()
                for aA, B in pairs(ca:GetChildren()) do
                    if table.find(eggs, B.Name) then
                        task.delay(2, function()
                            k.Shared.Inventory.DeleteItem:FireServer(B)
                        end)
                    end
                end
            end)
        end)
    end
})

bH:Button({
    Text = "Bank",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        if wkspce:FindFirstChild("MenuRings") and wkspce.MenuRings:FindFirstChild("Bank") then
            wkspce.MenuRings.Bank.Ring.CFrame = I:WaitForChild('LeftFoot').CFrame * CFrame.new(0, 0, -12)
            wkspce.MenuRings.Bank.Floor.CFrame = I:WaitForChild('LeftFoot').CFrame * CFrame.new(0, 0, -12)
        end
    end
})
bH:Button({
    Text = "Upgrade",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        require(k.Client.Gui.GuiScripts.ItemUpgrade):Toggle()
    end
})
bH:Button({
    Text = "Zero Altar",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        require(k.Client.Gui.GuiScripts.Fusion):Open()
    end
})
bH:Button({
    Text = "Way Stones",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        require(k.Client.Gui.GuiScripts.Waystones):Open()
    end
})
bH:Button({
    Text = "World Menu",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        require(k.Client.Gui.GuiScripts.WorldTeleport):Toggle()
    end
})
bH:Button({
    Text = "Dungeon Menu",
    TextSize = 22,
    Font = Enum.Font.FredokaOne,
    TextColor = Color3.fromRGB(255, 187, 109),
    Callback = function()
        require(k.Client.Gui.GuiScripts.MissionSelect):Toggle()
    end
})

al.MolPass=true
local MoLPass = bI:Toggle({
    Text = "MoLPassive",
    TextSize = 22,
    TextColor = Color3.fromRGB(255, 187, 109),
    Font = Enum.Font.FredokaOne,
    Enabled = al.MoLPass,
    Callback = function(aJ)
        al.MoLPass = aJ;
        task.spawn(function()
            while al.MoLPass do
                local character = wkspce.Characters[H.Name]
                local cg = require(k.Shared.Party):GetPartyByUsername(H.Name)
                if character and character.HealthProperties.Health.Value / character.HealthProperties.MaxHealth.Value *
                    100 < 99 then
                    for aA, ch in pairs(d:GetPlayers()) do
                        if cg and cg.Members:FindFirstChild(ch.Name) then
                            k.Shared.Combat.Skillsets.MageOfLight.HealCircle:FireServer(ch)
                        end
                    end
                end
                task.wait(14)
            end
        end)
        task.spawn(function()
            ak('WZ_Toggles', al)
            while al.MoLPass do
                local character = wkspce.Characters[H.Name]
                local cg = require(k.Shared.Party):GetPartyByUsername(H.Name)
                if character and character.HealthProperties.BarrierHealth.Value <= 0 then
                    for aA, ch in pairs(d:GetPlayers()) do
                        if cg and cg.Members:FindFirstChild(ch.Name) then
                            k.Shared.Combat.Skillsets.MageOfLight.Barrier:FireServer(ch)
                        end
                    end
                end
                task.wait(15)
            end
        end)
    end
})

wkspce.ChildAdded:Connect(function(ci)
    if ci.Name == 'BarrierPart' then
        task.defer(ci.Destroy, ci)
    end
end)
local hasRun = false  -- Set this variable outside the Connect function to maintain the correct value

k.Shared.Missions.MissionFinished.OnClientEvent:Connect(function()
    bG.Text = "EndTime: " .. os.date("%I:%M %p")
    -- WEBHOOK
    local OSTime = os.time()
    local Time = os.date('!*t', OSTime)
    local Avatar = 'https://cdn.discordapp.com/embed/avatars/4.png'
    local Content = 'Treo Acc World//Zero UGPHONE'

    -- Get the current Roblox player's name
    local player = game.Players.LocalPlayer
    local playerName = player.Name

    -- Check if there is information in ReplicatedStorage
    local playerProfile = game.ReplicatedStorage:FindFirstChild("Profiles"):FindFirstChild(playerName)
    local goldValue = 0
    if playerProfile and playerProfile:FindFirstChild("Currency") and playerProfile.Currency:FindFirstChild("Gold") then
        goldValue = playerProfile.Currency.Gold.Value
    end

    local Embed = {
        title = 'World//Zero',
        color = 99999, -- Change the color to an integer
        footer = {
            text = game.JobId
        },
        author = {
            name = 'MAI HOÀNG PHI',
            url = 'https://www.roblox.com/'
        },
        fields = {{
            name = playerName,
            value = tostring(goldValue) -- Convert gold value to a string
        }, {
            name = 'NGY V GIỜ',
            value = os.date('%Y-%m-%d %H:%M:%S', OSTime) -- Current date and time
        }},
        timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min,
            Time.sec)
    }

    local function sendEmbed(embedContent)
        (syn and syn.request or http_request) {
            Url = 'https://discord.com/api/webhooks/1249664506448187443/2me_mJp4i155tl1fayEFVaYIS-yzp9FNqQAGRyI1v4xe56MYdc8KDYBaA9Yw4Vevl3jw',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json'
            },
            Body = game:GetService('HttpService'):JSONEncode({
                content = Content,
                embeds = {embedContent}
            })
        }
    end

    sendEmbed(Embed)
end)

for aA, B in pairs(dungeonIds) do
    if game.PlaceId == B then
        local cj = H.PlayerGui.MissionRewards.MissionRewards;
        local cs = k.Shared.VIP.IsExtraDrop:InvokeServer()
        cj.Countdown:GetPropertyChangedSignal('Text'):Connect(function()
            if cj.Countdown.Text == 'Pick up your gold! (1)' then
                repeat
                    wait()
                until cj.Chests.Visible and cj.Chests.Box1.Visible and cj.Chests.Box2.Visible and
                    cj.Chests.Box1.ChestImage.Select.Visible;
                repeat
                    aT(cj.Chests.Box1.ChestImage.Select)
                    aT(cj.Chests.Box1.ChestImage.Select)
                    wait()
                until cj.OpenChest.Countdown.text == '0'
                repeat
                    wait()
                until H.PlayerGui.LootReceived.LootReceived.Info.Skip.Close.ClassName == "ImageButton" and
                    H.PlayerGui.LootReceived.LootReceived.Info.Skip.Close.Visible
                repeat
                    aT(H.PlayerGui.LootReceived.LootReceived.Info.Skip.Sell)
                    wait()
                until H.PlayerGui.MissionRewards.MissionRewards.Chests.Next.Visible
                aT(H.PlayerGui.MissionRewards.MissionRewards.Chests.Next)
            end
        end)
        cj.OpenChest.Countdown:GetPropertyChangedSignal('Text'):Connect(function()
            if cj.OpenChest.Countdown.Text == '0' then
                repeat
                    wait()
                until cj.OpenChest:WaitForChild("Next") and cj.OpenChest:FindFirstChild("Next").Visible;
                aT(cj.OpenChest.Next.TextLabel)
            end
        end)
        cj.Chests.Box1.ChestImage.ChildAdded:Connect(function(ct)
            if ct.Name == 'ViewportFrame' and not cs then
                aT(cj.OpenChest.Next.TextLabel)
            else
                aT(cj.Chests.Box2.ChestImage.VIP.TextLabel)
                repeat
                    wait()
                until cj.OpenChest.Chest:FindFirstChild("RaidChest")
                wait(1)
                repeat
                    aT(cj.Chests.Box2.ChestImage.Select)
                    wait()
                until cj.OpenChest.Countdown.text == '0'
            end
        end)
        cj.Chests.Box2.ChestImage.ChildAdded:Connect(function(ct)
            if ct.Name == 'ViewportFrame' and cs then
                wait()
                aT(cj.OpenChest.Next.TextLabel)
            end
        end)
    end
end
if game.PlaceId == dungeonIds[2.1] then
    wkspce.MissionObjects.ChildRemoved:Connect(function(cu)
        if cu.Name == 'MissionStart' then
            wait(1)
            wkspce.MissionObjects.Room1Trigger.CFrame = J.CFrame
        end
    end)
    wkspce.MissionObjects.Room1Trigger.ChildRemoved:Connect(function()
        wait(2)
        wkspce.MissionObjects.Room2Trigger.CFrame = J.CFrame
    end)
    wkspce.MissionObjects.Room2Trigger.ChildRemoved:Connect(function()
        wait(2)
        wkspce.MissionObjects.Room3Trigger.CFrame = J.CFrame
    end)
    wkspce.MissionObjects.Room3Trigger.ChildRemoved:Connect(function()
        wait(2)
        wkspce.MissionObjects.Room4Trigger.CFrame = J.CFrame
    end)
    wkspce.MissionObjects.Room4Trigger.ChildRemoved:Connect(function()
        wait(6)
        J.CFrame = wkspce.MissionObjects.WallsTrigger.CFrame;
        wait(3)
        J.CFrame = wkspce.MissionObjects.WallsFinalTrigger.CFrame
    end)
    H.PlayerGui.MissionObjective.MissionObjective.Label:GetPropertyChangedSignal('Text'):Connect(function()
        if H.PlayerGui.MissionObjective.MissionObjective.Label.Text == 'Take the royal crystal! (0 / 1)' then
            J.CFrame = CFrame.new(1192.15894, -226.738449, 110.141144)
        end
    end)
end
if game.PlaceId == dungeonIds[1.4] then
    wkspce.ChildAdded:Connect(function(cv)
        if cv.Name == 'Cage1Marker' then
            wait(2)
            wkspce.Cage1Marker.Collider.CFrame = J.CFrame
        end
    end)
    wkspce.ChildAdded:Connect(function(cv)
        if cv.Name == 'Cage2Marker' then
            wait(2.2)
            wkspce.Cage2Marker.Collider.CFrame = J.CFrame
        end
    end)
end
if game.PlaceId == dungeonIds[3.1] then
    wkspce.MissionObjects.ChildRemoved:Connect(function(cw)
        if cw.Name == 'ProgressionBlocker1' then
            wkspce.MissionObjects.CaveTrigger.CFrame = J.CFrame
        end
    end)
end
if game.PlaceId == dungeonIds[3] or game.PlaceId == towerIds[51] then
    wkspce.ChildAdded:Connect(function(cx)
        if cx.Name == 'IceWall' then
            wait(5)
            AutoFarm.State = false;
            J.CFrame = wkspce.IceWall:FindFirstChild('Ring').CFrame
        end
    end)
    wkspce.ChildRemoved:Connect(function(cx)
        if cx.Name == 'IceWall' then
            aK()
            AutoFarm.State = true
        end
    end)
end
local function cy()
    pcall(function()
        for aA, B in pairs(wkspce.MissionObjects.TowerLegs:GetDescendants()) do
            if B.Name == 'hitbox' and not B.CanCollide then
                B.Parent:Destroy()
            end
        end
    end)
end
if game.PlaceId == dungeonIds[4.1] then
    wkspce.MissionObjects.TowerLegs.DescendantRemoving:Connect(cy)
end
if game.PlaceId == dungeonIds[6.1] then
    wkspce.MissionObjects.ChildRemoved:Connect(function(cu)
        if cu.Name == 'MissionStart' then
            wait(1)
            wkspce.MissionObjects.Area1Trigger.CFrame = J.CFrame
        end
    end)
    wkspce.MissionObjects.Area2Trigger.ChildAdded:Connect(function(cz)
        if cz:IsA('TouchTransmitter') then
            wait(1)
            wkspce.MissionObjects.Area2Trigger.CFrame = J.CFrame
        end
    end)
end
if game.PlaceId == dungeonIds[7.1] then
    wkspce.MissionObjects.ChildRemoved:Connect(function(cu)
        if cu.Name == 'MissionStart' then
            wait(1)
            wkspce.MissionObjects.FakeBoss.CFrame = J.CFrame
        end
    end)
end
if game.PlaceId == towerIds[1] or game.PlaceId == towerIds[51] then
    H.PlayerGui.MissionObjective.MissionObjective.Label:GetPropertyChangedSignal('Text'):Connect(function()
        if H.PlayerGui.MissionObjective.MissionObjective.Label.Text == 'Get behind the active shield! (2)' then
            AutoFarm.State = false;
            J.CFrame = wkspce.MissionObjects.IgnisShield.Ring.CFrame;
            wait(3)
            aK()
            AutoFarm.State = true
        end
    end)
end

-- exit of tower floor
task.spawn(function()
    while IsAlive() do
        local cA = wkspce.MissionObjects:WaitForChild('WaveStarter', math.huge)
        if #cA:GetChildren() > 0 then
            AutoFarm.State = false;
            J.CFrame = cA.CFrame
            wait(3)
            AutoFarm.State = true
        end
        -- inf tower gate
        if game.PlaceId == towerIds[50] or game.PlaceId == towerIds[51] then


            AutoFarm.State = false;

            local bossGate = game.Workspace:FindFirstChild("Boss_Gate")
            if bossGate then
                local interactions = bossGate:FindFirstChild("Interactions")
                if interactions then
                    local atp = interactions:GetChildren()[1]
                    local btp = interactions:GetChildren()[2]
                    local ctp = interactions:GetChildren()[3]
                    if atp then
                        J.CFrame = atp.CFrame
                        wait(3)
                    end
                    if btp then
                        J.CFrame = btp.CFrame
                        wait(3)
                    end
                    if ctp then
                        J.CFrame = ctp.CFrame
                        wait(3)
                    end
                end
            end

            AutoFarm.State = true

            -- local mobs = wkspce.Mobs:GetChildren()
            -- print("mobs qty")
            -- print(#mobs)

            -- if #mobs == 0 then
                -- print("no mobs")
                -- find next floor
            local mbs = wkspce:FindFirstChild("MissionObjects")
            if mbs then 
                print("mbs")
                local arena = mbs:FindFirstChild("Arena")
                if arena then 
                    print("arena")
                    local tps = bossGate:GetChildren()
                    AutoFarm.State = false;
                    for _, child in pairs(tps) do
                        local teleporter  = child:FindFirstChild("TeleporterLocation")
                        print(teleporter)
                        J.CFrame = teleporter.CFrame
                        wait(3)
                    end
                    AutoFarm.State = true
                end
            end
            -- end

        end
        wait()
    end
end)
wkspce.MissionObjects.ChildAdded:Connect(function(cB)
    if cB.Name == 'MinibossExitModel' then
        wait(2)
        AutoFarm.State = false;
        J.CFrame = wkspce.MissionObjects.MinibossExitModel.CFrame;
        wait(2)
        AutoFarm.State = true;
    end
end)
wkspce.MissionObjects.ChildAdded:Connect(function(cC)
    if cC.Name == 'MinibossExit' then
        wait(3)
        AutoFarm.State = false;
        J.CFrame = wkspce.MissionObjects.MinibossExit.CFrame;
        wait()
        aK()
        AutoFarm.State = true
    end
end)

for aA, B in ipairs(game:GetService("ReplicatedStorage").Shared.Effects.EffectScripts:GetChildren()) do
    if hookfunction and B:IsA("ModuleScript") and
        (string.find(B.Name, "Klaus") or string.find(B.Name, "Hades") or string.find(B.Name, "Prism") or
            string.find(B.Name, "Taurha") or string.find(B.Name, "Kraken") or string.find(B.Name, "Anubis") or
            string.find(B.Name, "Cerberus") or string.find(B.Name, "FallenKing")) then
        local cD = require(B)
        hookfunction(cD, function()
            return nil
        end)
    end
end
for A, B in pairs(dungeonIds) do
    if type(A) ~= "string" and game.PlaceId == B then
        if wkspce:FindFirstChild('MissionObjects') then
            local cE = wkspce.MissionObjects;
            cE.DescendantAdded:Connect(function(cz)
                if cz:IsA 'TouchTransmitter' and not string.match(cz.Parent.Parent.Name, 'Damage') and
                    not string.match(cz.Parent.Name, 'Killpart') and not string.match(cz.Parent.Name, '0') and
                    not string.match(cz.Parent.Parent.Name, 'Darts') and
                    not string.match(cz.Parent.Parent.Name, 'Spikes') and cz.Parent ~= 'MinibossExit' and
                    cz.Parent.Parent ~= 'MinibossExitModel' then
                    wait(2)
                    pcall(function()
                        cz.Parent.CFrame = J.CFrame
                    end)
                end
            end)
            cE.DescendantAdded:Connect(function(cF)
                if cF:IsA 'TouchTransmitter' and string.match(cF.Parent.Name, 'Trigger') then
                    wait(3 / 2)
                    pcall(function()
                        cF.Parent.CFrame = J.CFrame
                    end)
                end
            end)
        end
    end
end

-- open world, turn off KillAura and AutoFarm
for _, B in pairs(worldIds) do
    if game.PlaceId == B then
        KillAura.State = false;
        AutoFarm.State = false
    end
end

local function cM(cN)
    character = cN;
    K = cN:WaitForChild('Humanoid')
    J = cN:WaitForChild('HumanoidRootPart')
    aK()
end
H.CharacterAdded:Connect(cM)
if getconnections then
    for aA, B in next, getconnections(H.Idled) do
        B:Disable()
    end
end
if not getconnections then
    H.Idled:connect(function()
        a.VirtualUser:ClickButton2(Vector2.new())
    end)
end
H.CameraMaxZoomDistance = 60;
local cO = H.CameraMinZoomDistance;
H.CameraMinZoomDistance = 60;
H.CameraMinZoomDistance = cO;
game.NetworkClient.ChildRemoved:Connect(function(cP)
    al.KillAura = false;
    a.GuiService:ClearError()
    bJ.Text = "Disconnected"
end)
coroutine.wrap(function()
    local cQ = c:WaitForChild("RobloxPromptGui")
    local cR = cQ:WaitForChild("promptOverlay")
    local cS = cR:WaitForChild("ErrorPrompt")
    local cT = cS:WaitForChild("MessageArea")
    local cU = cT:WaitForChild("ErrorFrame")
    local cV = cU:WaitForChild("ErrorMessage")
    repeat
        wait()
    until string.find(cV.Text, "exploit")
    if ap.DifficultyID <= 1 then
        k.Shared.Teleport.StartRaid:FireServer(ap.DungeonID)
    else
        k.Shared.Teleport.StartRaid:FireServer(ap.DungeonID, ap.DifficultyID)
    end
end)()
coroutine.wrap(function()
    local cQ = c:WaitForChild("RobloxPromptGui")
    local cR = cQ:WaitForChild("promptOverlay")
    local cS = cR:WaitForChild("ErrorPrompt")
    local cT = cS:WaitForChild("MessageArea")
    local cU = cT:WaitForChild("ErrorFrame")
    local cV = cU:WaitForChild("ErrorMessage")
    repeat
        wait()
    until string.find(cV.Text, "reconnect")
    if ap.DifficultyID <= 1 then
        k.Shared.Teleport.StartRaid:FireServer(ap.DungeonID)
    else
        k.Shared.Teleport.StartRaid:FireServer(ap.DungeonID, ap.DifficultyID)
    end
end)()
local cW = {
    DungeonID = a0[game.PlaceId],
    DifficultyID = S.GetDifficulty(),
    Phase = 0,
    ProfileGUID = k.Profiles[H.Name].GUID.Value
}
if getgenv().RJOnCrash and not a0[game.PlaceId] or cW.Phase == 1 then
    ag('WZ_CrashRJ', cW)
    wait(1)
    if cW.Phase == 0 then
        cW.Phase = 1;
        ak('WZ_CrashRJ', cW)
        an(ao)
        while wait(10) do
            k.Shared.Teleport.JoinGame:FireServer(cW.ProfileGUID)
        end
    end
    if cW.Phase == 1 then
        cW.Phase = 0;
        ak('WZ_CrashRJ', cW)
        an(ao)
        if ap.DifficultyID <= 1 then
            k.Shared.Teleport.StartRaid:FireServer(cW.DungeonID)
        else
            k.Shared.Teleport.StartRaid:FireServer(cW.DungeonID, cW.DifficultyID)
        end
    end
end
ak('WZ_CrashRJ', cW)
local cX = function(cY, cZ)
    local c_ = {
        enabled = true,
        fake = cY[cZ],
        fake_type = typeof(fake)
    }
    local d0;
    local d1;
    function c_:SetFake(d2, d3)
        if d3 then
            c_.fake = d2
        elseif typeof(d2) == c_.fake_type then
            c_.fake = d2
        else
            c_.fake = nil
        end
    end
    function c_:Destroy()
        cY[cZ] = c_.fake;
        c_.enabled = false
    end
    if hookmetamethod then
        d0 = hookmetamethod(cY, '__index', function(self, d4)
            if self == cY and d4 == cZ and not checkcaller() and c_.enabled then
                return c_.fake
            end
            return d0(self, d4)
        end)
        d1 = hookmetamethod(cY, '__newindex', function(self, d4, d5)
            if self == cY and d4 == cZ and not checkcaller() and c_.enabled then
                if typeof(d5) == c_.fake_type then
                    c_.fake = d5;
                    return
                else
                    c_.fake = nil;
                    return
                end
            end
            return d1(self, d4, d5)
        end)
    else
        return
    end
    return c_
end;
cX(K, 'WalkSpeed')
cX(H, 'CameraMaxZoomDistance')
if ad ~= 'MageOfLight' then
    MoLPass.State = false
end
local d6 = {}
local d7 = ''
local d8 = true;
if am.PerkNames ~= nil and type(am.PerkNames) == 'table' then
    for A, B in pairs(am.PerkNames) do
        d8 = false
    end
end
if d8 then
    am.PerkNames = {}
    for A, B in pairs(T) do
        if type(B) == 'table' then
            for C, d9 in pairs(B) do
                if type(d9) == 'table' then
                    for da, db in pairs(d9) do
                        if da == 2 then
                            table.insert(am.PerkNames, A)
                            d6[A] = db
                        end
                    end
                end
            end
        end
    end
else
    ag('WZwebhook', am)
end
local dc = {}
-- perks
local dd = {
    ['ResistFrost'] = 'Resist Frost',
    ['ResistBurn'] = 'Resist Burn',
    ['Glass'] = 'Glass',
    ['RoughSkin'] = 'Rough Skin',
    ['ResistKnockdown'] = 'Resist Knockdown',
    ['BonusWalkspeed'] = 'Agility',
    ['PetFoodDrop'] = 'Lucky Looter',
    ['BonusAttack'] = 'Attack UP',
    ['BonusHP'] = 'HP UP',
    ['ResistPoison'] = 'Resist Poison',
    ['LifeDrain'] = 'Life Drain',
    ['CritStack'] = 'Crit Stack',
    ['BurnChance'] = 'Burn Chance',
    ['OpeningStrike'] = 'Opening Strike',
    ['MobBoss'] = 'Mob Boss',
    ['TestTier5'] = 'Boss of the Boss',
    ['GoldDrop'] = 'Gold Hoarder',
    ['BonusRegen'] = 'Bonus Health Regen',
    ['DamageReduction'] = 'Damage Reduction',
    ['Aggro'] = 'Shifted Aggro',
    ['UltCharge'] = 'Energized',
    ['Fortress'] = 'Fortress',
    ['MasterThief'] = 'Master Thief',
    ['EliteBoss'] = 'Elite Boss',
    ['DodgeChance'] = 'Untouchable'
}
H.CharacterRemoving:Connect(function()
    dg:Disconnect()
end)
local ds = H:WaitForChild("PlayerGui")
local cj = ds:WaitForChild("MissionRewards"):WaitForChild("MissionRewards")
local dt = ds:WaitForChild("TowerFinish"):WaitForChild("TowerFinish")
local du = cj:WaitForChild("Time")
local dv = dt:WaitForChild("Description"):WaitForChild("Overlay")
repeat
    wait()
until du.Visible or dv.text == "Collect your rewards! (20)"
wait(1)
local dw = k.Profiles[H.Name].Currency.Gold.Value - de;
local dx = ""
local dy = ""
if not du.Visible then
    dx = "Tower Finished"
    dy = dt:WaitForChild("Time").Text
else
    dx = cj:WaitForChild("RaidClear").Text;
    dy = cj:WaitForChild("Time").Text
end
local dz = ''
local dA = ''
for A, B in pairs(V) do
    if B.LiveID == game.PlaceId then
        dz = B.Name;
        dA = B.NameTag
    end
end
