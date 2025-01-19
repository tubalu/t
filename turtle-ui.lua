-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Tables
local Library = {}
local WindowCount = 0
local Sizes = {}
local ListOffset = {}
local PastSliders = {}
local Dropdowns = {}
local ColorPickers = {}

-- Variables
local Mouse = Players.LocalPlayer:GetMouse()

-- Data Settings
local Default = {
    Key = "LeftControl",
    Minimized = false
}

local Success, Setting = pcall(function()
    if readfile then
        return HttpService:JSONDecode(readfile("TurtleSettings.json"))
    else
        return Default
    end
end)

if writefile then
    if not Success then
        Setting = Default

        writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
    else
        for i,v in pairs(Setting) do
            if not Default[i] then
                Setting[i] = nil
            end
        end

        for i,v in pairs(Default) do
            if not Setting[i] then
                Setting[i] = v
            end
        end

        writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
    end
end

-- Instance
pcall(function()
    getgenv().OldInstance:Destroy()
end)

local NewInstance = Instance.new("ScreenGui")
NewInstance.Name = HttpService:GenerateGUID(false)

if gethui then
	NewInstance.Parent = gethui()
elseif not is_sirhurt_closure and (syn and syn.protect_gui) then
	syn.protect_gui(NewInstance)
	NewInstance.Parent = CoreGui
else
	NewInstance.Parent = CoreGui
end

getgenv().OldInstance = NewInstance

local XOffset = 20

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

function Dragify(Obj)
    task.spawn(function()
        local Initial
        local MinInitial
        local IsDragging

        Obj.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                IsDragging = true
                MinInitial = Input.Position
                Initial = Obj.Position

                local Connection
                Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local Delta = Vector3.new(Mouse.X, Mouse.Y, 0) - MinInitial
                        Obj.Position = UDim2.new(Initial.X.Scale, Initial.X.Offset + Delta.X, Initial.Y.Scale, Initial.Y.Offset + Delta.Y)
                    else
                        Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end)
    end)
end

function CheckEnum(Enum, Item)
    for _,v in ipairs(Enum:GetEnumItems()) do
        if v.Name == (typeof(Item) == "string" and Item or Item.Name) then
            return true and v
        end
    end

    return false
end

-- Elements
function Library:Window(_Window, ...)
    local Arg = _Window

    if typeof(_Window) ~= "table" then
        Arg = table.pack(Arg, ...)
    end

    Arg.Title = (Arg.Title or Arg[1]) or "Turtle UI"
    Arg.FrameColor = (Arg.FrameColor or Arg[2]) or Color3.fromRGB(0, 151, 230)
    Arg.BackgroundColor = (Arg.BackgroundColor or Arg[3]) or Color3.fromRGB(47, 54, 64)
    Arg.TextColor = (Arg.TextColor or Arg[4]) or Color3.fromRGB(100, 100, 100)

    Arg.Font = (Arg.Font and CheckEnum(Enum.Font, Arg.Font)) or Enum.Font.SourceSans
    Arg.TextSize = Arg.TextSize or 17

    WindowCount = WindowCount + 1

    local WinCount = WindowCount
    local ZIndex = WindowCount * 7

    local UIWindow = Instance.new("Frame")
    UIWindow.Name = "UIWindow"
    UIWindow.BackgroundColor3 = Arg.FrameColor
    UIWindow.BorderSizePixel = 0
    UIWindow.Position = UDim2.new(0, XOffset, 0, 20)
    UIWindow.Size = UDim2.new(0, 207, 0, 33)
    UIWindow.ZIndex = 4 + ZIndex
    UIWindow.Active = true
    UIWindow.Parent = NewInstance
    Dragify(UIWindow)

    XOffset = XOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = Arg.FrameColor
    Header.BorderSizePixel = 0
    Header.Position = UDim2.new(0, 0, -0.0202544238, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + ZIndex
    Header.Parent = UIWindow

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.BackgroundColor3 = Arg.FrameColor
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Position = UDim2.new(0, 0, -0.0020698905, 0)
    HeaderText.Size = UDim2.new(0, 206, 0, 33)
    HeaderText.ZIndex = 6 + ZIndex
    HeaderText.Font = Arg.Font
    HeaderText.Text = Arg.Title
    HeaderText.TextColor3 = Arg.TextColor
    HeaderText.TextSize = Arg.TextSize
    HeaderText.Parent = Header

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.BackgroundColor3 = Arg.BackgroundColor
    Window.BorderColor3 = Arg.BackgroundColor
    Window.Position = UDim2.new(0, 0, 0, 0)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + ZIndex
    Window.Parent = Header

    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0, 185, 0, 2)
    Minimize.Size = UDim2.new(0, 22, 0, 22)
    Minimize.ZIndex = 7 + ZIndex
    Minimize.Font = Enum.Font.SourceSansLight
    Minimize.Text = "-"
    Minimize.TextColor3 = Arg.TextColor
    Minimize.TextSize = 22
    Minimize.Parent = Header
    Minimize.MouseButton1Down:Connect(function()
        Window.Visible = not Window.Visible
        Minimize.Text = Window.Visible and "-" or "+"
    end)

    local Functions = {}

    Sizes[WinCount] = 33
    ListOffset[WinCount] = 10

    function Functions:Label(_Label, ...)
        local Args = _Label

        if typeof(_Label) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Label"
        Args.TextColor = (Args.TextColor or Args[2]) or Color3.fromRGB(220, 221, 225)

        Args.Font = (Args.Font and CheckEnum(Enum.Font, Args.Font)) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.MouseEnter = Args.MouseEnter or function() end
        Args.MouseLeave = Args.MouseLeave or function() end

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.BackgroundColor3 = Color3.fromRGB(220, 221, 225)
        Label.BackgroundTransparency = 1
        Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
        Label.Position = UDim2.new(0, 0, 0, ListOffset[WinCount])
        Label.Size = UDim2.new(0, 206, 0, 29)
        Label.Font = Args.Font
        Label.Text = Args.Text
        Label.TextSize = Args.TextSize
        Label.ZIndex = 2 + ZIndex
        Label.Parent = Window

        local MouseEnter
        MouseEnter = Label.MouseEnter:Connect(function()
            Args.MouseEnter(Func, MouseEnter)
        end)

        local MouseLeave
        MouseLeave = Label.MouseLeave:Connect(function()
            Args.MouseLeave(Func, MouseLeave)
        end)

        if typeof(Args.TextColor) == "boolean" and Args.TextColor then
            task.spawn(function()
                while NewInstance.Parent do
                    local Hue = tick() % 5 / 5
                    Label.TextColor3 = Color3.fromHSV(Hue, 1, 1)
                    task.wait()
                end
            end)
        else
            Label.TextColor3 = Args.TextColor
        end

        PastSliders[WinCount] = false

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    Label.Text = v
                elseif k == "TextColor" then
                    Label.TextColor3 = v
                elseif k == "Font" then
                    Label.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    Label.TextSize = v
                elseif k == "Visible" then
                    Label.Visible = v
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return Label.Text
                elseif k == "TextColor" then
                    return Label.TextColor3
                elseif k == "Font" then
                    return Label.Font
                elseif k == "TextSize" then
                    return Label.TextSize
                elseif k == "Visible" then
                    return Label.Visible
                end
            end
        })
    end

    function Functions:Button(_Button, ...)
        local Args = _Button

        if typeof(_Button) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Button"
        Args.Callback = (Args.Callback or Args[2]) or function() end

        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)
        Args.TextSize = Args.TextSize or 16
        Args.Font = (Args.Font and CheckEnum(Enum.Font, Args.Font)) or Enum.Font.SourceSans

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.BackgroundColor3 = Arg.FrameColor
        Button.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Button.Position = UDim2.new(0, 12, 0, ListOffset[WinCount])
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + ZIndex
        Button.Selected = true
        Button.Font = Args.Font
        Button.TextColor3 = Args.TextColor
        Button.TextSize = Args.TextSize
        Button.TextStrokeTransparency = 123.000
        Button.TextWrapped = true
        Button.Text = Args.Text
        Button.Parent = Window
        Button.MouseButton1Down:Connect(function()
            Args.Callback(Func)
        end)

        PastSliders[WinCount] = false

        function Func:Click()
            Args.Callback(Func)
        end

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    Button.Text = v
                elseif k == "TextColor" then
                    Button.TextColor3 = v
                elseif k == "Font" then
                    Button.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    Button.TextSize = v
                elseif k == "Visible" then
                    Button.Visible = v
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return Button.Text
                elseif k == "TextColor" then
                    return Button.TextColor3
                elseif k == "Font" then
                    return Button.Font
                elseif k == "TextSize" then
                    return Button.TextSize
                elseif k == "Visible" then
                    return Button.Visible
                end
            end
        })
    end

    function Functions:Toggle(_Toggle, ...)
        local Args = _Toggle

        if typeof(_Toggle) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Toggle"
        Args.Enabled = (Args.Enabled or Args[2]) or false
        Args.Callback = (Args.Callback or Args[3]) or function() end
        Args.Disable = (Args.Disable or Args[4]) or true

        Args.Font = Args.Font and CheckEnum(Enum.Font, Args.Font) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local ToggleDescription = Instance.new("TextLabel")
        ToggleDescription.Name = "ToggleDescription"
        ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDescription.BackgroundTransparency = 1.000
        ToggleDescription.Position = UDim2.new(0, 14, 0, ListOffset[WinCount])
        ToggleDescription.Size = UDim2.new(0, 131, 0, 26)
        ToggleDescription.Font = Args.Font
        ToggleDescription.Text = Args.Text
        ToggleDescription.TextColor3 = Args.TextColor
        ToggleDescription.TextSize = Args.TextSize
        ToggleDescription.TextWrapped = true
        ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDescription.ZIndex = 2 + ZIndex
        ToggleDescription.Parent = Window

        local ToggleFiller = Instance.new("Frame")
        ToggleFiller.Name = "ToggleFiller"
        ToggleFiller.BackgroundColor3 = Color3.fromRGB(88, 214, 141)
        ToggleFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ToggleFiller.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller.Visible = Args.Enabled
        ToggleFiller.ZIndex = 2 + ZIndex

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.BackgroundColor3 = Arg.FrameColor
        ToggleButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        ToggleButton.Position = UDim2.new(1.2061069, 0, 0.0769230798, 0)
        ToggleButton.Size = UDim2.new(0, 22, 0, 22)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleButton.TextSize = 14.000
        ToggleButton.ZIndex = 2 + ZIndex
        ToggleButton.Parent = ToggleDescription
        ToggleFiller.Parent = ToggleButton
        ToggleButton.MouseButton1Down:Connect(function()
            Args.Enabled = not Args.Enabled

            ToggleFiller.Visible = Args.Enabled

            Args.Callback(Args.Enabled, Func)
        end)

        if Args.Disable then
            local Connection
            Connection = NewInstance:GetPropertyChangedSignal("Parent"):Connect(function()
                if not NewInstance.Parent then
                    if Args.Enabled then
                        Args.Enabled = false
                        Args.Callback(Args.Enabled, Func)

                        Connection:Disconnect()
                    else
                        Connection:Disconnect()
                    end
                end
            end)
        end

        if Args.Enabled then
            Args.Callback(Args.Enabled, Func)
        end

        if Args.Text == "Minimize Windows" then
            Window:SetAttribute("MinimizeButton", true)
        end

        PastSliders[WinCount] = false

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    ToggleDescription.Text = v
                elseif k == "TextColor" then
                    ToggleDescription.TextColor3 = v
                elseif k == "Font" then
                    ToggleDescription.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    ToggleDescription.TextSize = v
                elseif k == "Visible" then
                    ToggleDescription.Visible = v
                elseif k == "State" then
                    Args.Enabled = v
                    ToggleFiller.Visible = Args.Enabled

                    Args.Callback(Args.Enabled, Func)
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return ToggleDescription.Text
                elseif k == "TextColor" then
                    return ToggleDescription.TextColor3
                elseif k == "Font" then
                    return ToggleDescription.Font
                elseif k == "TextSize" then
                    return ToggleDescription.TextSize
                elseif k == "Visible" then
                    return ToggleDescription.Visible
                elseif k == "State" then
                    return Args.Enabled
                end
            end
        })
    end

    function Functions:Bind(_Bind, ...)
        local Args = _Bind

        if typeof(_Bind) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Bind"
        Args.Bind = (Args.Bind or Args[2]) and CheckEnum(Enum.KeyCode, (Args.Bind or Args[2])) or Enum.KeyCode.A
        Args.Enabled = (Args.Enabled or Args[3]) or false
        Args.Callback = (Args.Callback or Args[4]) or function() end
        Args.ExCallback = (Args.ExCallback or Args[5]) or false

        Args.Font = Args.Font and CheckEnum(Enum.Font, Args.Font) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}
        local KeyCode = Args.Bind.Name

        local BindDescription = Instance.new("TextLabel")
        BindDescription.Name = "BindDescription"
        BindDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BindDescription.BackgroundTransparency = 1
        BindDescription.Position = UDim2.new(0, 14, 0, ListOffset[WinCount])
        BindDescription.Size = UDim2.new(0, 131, 0, 26)
        BindDescription.Font = Args.Font
        BindDescription.Text = Args.Text
        BindDescription.TextColor3 = Args.TextColor
        BindDescription.TextSize = Args.TextSize
        BindDescription.TextWrapped = true
        BindDescription.TextXAlignment = Enum.TextXAlignment.Left
        BindDescription.ZIndex = 2 + ZIndex
        BindDescription.Parent = Window

        local BindButton = Instance.new("TextButton")
        BindButton.Name = "BindButton"
        BindButton.BackgroundColor3 = Arg.BackgroundColor
        BindButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        BindButton.Position = UDim2.new(0, 115, 0, 0)
        BindButton.Size = UDim2.new(0, 70, 0, 22)
        BindButton.Font = Args.Font
        BindButton.Text = KeyCode
        BindButton.TextColor3 = Args.TextColor
        BindButton.TextSize = 14.000
        BindButton.ZIndex = 2 + ZIndex
        BindButton.Parent = BindDescription
        BindButton.MouseButton1Click:Connect(function()
            BindButton.Text = "Â·Â·Â·"

            local Input = UserInputService.InputBegan:Wait()

            if Input.KeyCode.Name == "Unknown" then
                KeyCode = nil
                BindButton.Text = "None"
            else
                KeyCode = Input.KeyCode.Name
                BindButton.Text = Input.KeyCode.Name
            end
        end)

        local Connection
        Connection = UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
            if Input.KeyCode.Name == KeyCode and not GameProcessedEvent then
                if NewInstance.Parent then
                    Args.Enabled = not Args.Enabled

                    Args.Callback(Args.Enabled, KeyCode, Func)
                else
                    Connection:Disconnect()
                end
            end
        end)

        if Args.ExCallback then
            Args.Callback(Args.Enabled, KeyCode, Func)
        end

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    BindDescription.Text = v
                elseif k == "TextColor" then
                    BindDescription.TextColor3 = v
                elseif k == "Font" then
                    BindDescription.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    BindDescription.TextSize = v
                elseif k == "Visible" then
                    BindDescription.Visible = v
                elseif k == "State" then
                    Args.Enabled = v
                    Args.Callback(Args.Enabled, Func)
                elseif k == "Bind" then
                    KeyCode = CheckEnum(Enum.KeyCode, v) or KeyCode
                    BindButton.Text = KeyCode
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return BindDescription.Text
                elseif k == "TextColor" then
                    return BindDescription.TextColor3
                elseif k == "Font" then
                    return BindDescription.Font
                elseif k == "TextSize" then
                    return BindDescription.TextSize
                elseif k == "Visible" then
                    return BindDescription.Visible
                elseif k == "State" then
                    return Args.Enabled
                elseif k == "Bind" then
                    return KeyCode
                end
            end
        })
    end

    function Functions:Box(_Box, ...)
        local Args = _Box

        if typeof(_Box) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Box"
        Args.Callback = (Args.Callback or Args[2]) or function() end

        Args.Default = Args.Default or ""
        Args.PlaceHolder = Args.PlaceHolder or "Â·Â·Â·"
        Args.TextSize = Args.TextSize or 16
        Args.Type = (Args.Type and CheckEnum(Enum.TextInputType, Args.Type)) or "Default"
        Args.Font = (Args.Font and CheckEnum(Enum.Font, Args.Font)) or Enum.Font.SourceSans
        Args.ClearText = Args.ClearText or false
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}
        local Backup

        local TextBox = Instance.new("TextBox")
        TextBox.BackgroundColor3 = Arg.FrameColor
        TextBox.BorderColor3 = Color3.fromRGB(113, 128, 147)
        TextBox.Position = UDim2.new(0, 99, 0, ListOffset[WinCount])
        TextBox.Size = UDim2.new(0, 95, 0, 26)
        TextBox.Font = Args.Font
        TextBox.PlaceholderColor3 = Color3.fromRGB(220, 221, 225)
        TextBox.PlaceholderText = Args.PlaceHolder
        TextBox.Text = Args.Default
        TextBox.TextInputType = Args.Type
        TextBox.TextColor3 = Args.TextColor
        TextBox.TextSize = 14
        TextBox.TextTruncate = Enum.TextTruncate.AtEnd
        TextBox.TextStrokeColor3 = Color3.fromRGB(245, 246, 250)
        TextBox.ZIndex = 2 + ZIndex
        TextBox.Parent = Window
        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            if Args.Type == Enum.TextInputType.Number or Args.Type == Enum.TextInputType.Phone then
                if not tonumber(TextBox.Text) and TextBox.Text:sub(1, #TextBox.Text) ~= "-" then
                    TextBox.Text = ""
                end
            end
        end)

        TextBox.FocusLost:Connect(function()
            if TextBox.Text ~= "" then
                if Args.Type == Enum.TextInputType.Number or Args.Type == Enum.TextInputType.Phone then
                    Args.Callback(tonumber(TextBox.Text), Func)
                else
                    Args.Callback(TextBox.Text, Func)
                end

                if Args.ClearText then
                    Backup = TextBox.Text
                    TextBox.Text = ""
                end
            end
        end)

        local BoxDescription = Instance.new("TextLabel")
        BoxDescription.Name = "BoxDescription"
        BoxDescription.Parent = TextBox
        BoxDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BoxDescription.BackgroundTransparency = 1.000
        BoxDescription.Position = UDim2.new(-0.894736826, 0, 0, 0)
        BoxDescription.Size = UDim2.new(0, 75, 0, 26)
        BoxDescription.Font = Args.Font
        BoxDescription.Text = Args.Text
        BoxDescription.TextColor3 = Args.TextColor
        BoxDescription.TextSize = Args.TextSize
        BoxDescription.TextXAlignment = Enum.TextXAlignment.Left
        BoxDescription.ZIndex = 2 + ZIndex

        PastSliders[WinCount] = false

        function Func:GetPlayer(Input)
            if typeof(Input) == "string" then
				local Found = {}
				local Method = Input:lower()

				if Method == "me" then
					table.insert(Found, Players.LocalPlayer.Name)
				elseif Method == "random" then
					table.insert(Found, Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
				end

				for _,v in pairs(Players:GetPlayers()) do
					if Method == "others" then
						if v ~= Players.LocalPlayer then
							table.insert(Found, v)
						end
					elseif Method == "all" then
						table.insert(Found, v)
					elseif Method == "nonfriends" then
						if not v:GetFriendStatus(Players.LocalPlayer) == Enum.FriendStatus.NotFriend and v ~= Players.LocalPlayer then
							table.insert(Found, v)
						end
					elseif Method == "friends" then
						if v:GetFriendStatus(Players.LocalPlayer) == Enum.FriendStatus.NotFriend then
							table.insert(Found, v)
						end
					elseif Method == "enemies" then
						if v.Team ~= Players.LocalPlayer.Team then
							table.insert(Found, v)
						end
					elseif Method == "allies" then
						if v.Team == Players.LocalPlayer.Team then
							table.insert(Found, v)
						end
					else
						if v.Name:lower():sub(1, #Input) == Input:lower() or v.DisplayName:lower():sub(1, #Input) == Input:lower() then
							table.insert(Found, v)
						end
					end
				end

				if table.maxn(Found) > 0 then
					return Found
				end

				return nil
			end
        end

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Title" then
                    BoxDescription.Text = v
                elseif k == "Text" then
                    TextBox.Text = v
                elseif k == "PlaceHolder" then
                    TextBox.PlaceholderText = v
                elseif k == "TextColor" then
                    TextBox.TextColor3 = v
                    BoxDescription.TextColor3 = v
                elseif k == "Font" then
                    TextBox.Font = CheckEnum(Enum.Font, v)
                    BoxDescription.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    TextBox.TextSize = v
                    BoxDescription.Size = v
                elseif k == "Visible" then
                    TextBox.Visible = v
                elseif k == "Type" then
                    TextBox.TextInputType = CheckEnum(Enum.TextInputType, v) or TextBox.TextInputType
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return {
                        Title = BoxDescription.Text,
                        Input = not Args.ClearText and TextBox.Text or Backup
                    }
                elseif k == "TextColor" then
                    return TextBox.TextColor3
                elseif k == "Font" then
                    return TextBox.Font
                elseif k == "TextSize" then
                    return TextBox.TextSize
                elseif k == "Visible" then
                    return TextBox.Visible
                elseif k == "Type" then
                    return TextBox.TextInputType
                end
            end
        })
    end

    function Functions:Slider(_Box, ...)
        local Args = _Box

        if typeof(_Box) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Slider"
        Args.Min = (Args.Min or Args[2]) or 1
        Args.Max = (Args.Max or Args[3]) or 100
        Args.Default = (Args.Default or Args[4]) or Args.Max / 2
        Args.Callback = (Args.Callback or Args[5]) or function() end

        Args.Font = Args.Font and CheckEnum(Enum.Font, Args.Font) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        local Offset = 70

        local Initial
        local IsDragging

        if Args.Default > Args.Max then
            Args.Default = Args.Max
        elseif Args.Default < Args.Min then
            Args.Default = Args.Min
        end

        if PastSliders[WinCount] then
            Offset = 60
        end

        Sizes[WinCount] = Sizes[WinCount] + Offset
        ListOffset[WinCount] = ListOffset[WinCount] + Offset
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Slider = Instance.new("Frame")
        local SliderButton = Instance.new("Frame")
        local Description = Instance.new("TextLabel")
        local SilderFiller = Instance.new("Frame")
        local Current = Instance.new("TextLabel")
        local Min_ = Instance.new("TextLabel")
        local Max_ = Instance.new("TextLabel")

        local function SliderMovement(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                IsDragging = true
                Initial = SliderButton.Position.X.Offset

                local Delta = SliderButton.AbsolutePosition.X - Initial

                local Connection
                Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local xOffset = Mouse.X - Delta - 3

                        if xOffset > 175 then
                            xOffset = 175
                        elseif xOffset < 0 then
                            xOffset = 0
                        end

                        SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0)
                        SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
                        local Value = Lerp(Args.Min, Args.Max, SliderButton.Position.X.Offset / (Slider.Size.X.Offset - 5))
                        Current.Text = tostring(math.round(Value))
                    else
                        Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end

        local function SliderEnd(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local Value = Lerp(Args.Min, Args.Max, SliderButton.Position.X.Offset / (Slider.Size.X.Offset - 5))
                Args.Callback(math.round(Value), Func)
            end
        end

        Slider.Name = "Slider"
        Slider.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        Slider.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Slider.Position = UDim2.new(0, 13, 0, ListOffset[WinCount])
        Slider.Size = UDim2.new(0, 180, 0, 6)
        Slider.ZIndex = 2 + ZIndex
        Slider.Parent = Window
        Slider.InputBegan:Connect(SliderMovement)
        Slider.InputEnded:Connect(SliderEnd)

        SliderButton.Position = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((Args.Default - Args.Min) / (Args.Max - Args.Min)), -1.333337, 0)
        SliderButton.Name = "SliderButton"
        SliderButton.BackgroundColor3 = Arg.FrameColor
        SliderButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        SliderButton.Size = UDim2.new(0, 6, 0, 22)
        SliderButton.ZIndex = 3 + ZIndex
        SliderButton.Parent = Slider
        SliderButton.InputBegan:Connect(SliderMovement)
        SliderButton.InputEnded:Connect(SliderEnd)

        Current.Name = "Current"
        Current.BackgroundTransparency = 1.000
        Current.Position = UDim2.new(0, 3, 0, 22)
        Current.Size = UDim2.new(0, 0, 0, 18)
        Current.Font = Args.Font
        Current.Text = tostring(Args.Default)
        Current.TextColor3 = Color3.fromRGB(220, 221, 225)
        Current.TextSize = 14.000
        Current.ZIndex = 2 + ZIndex
        Current.Parent = SliderButton

        Description.Name = "Description"
        Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Description.BackgroundTransparency = 1.000
        Description.Position = UDim2.new(0, -10, 0, -35)
        Description.Size = UDim2.new(0, 200, 0, 21)
        Description.Font = Args.Font
        Description.Text = Args.Text
        Description.TextColor3 = Args.TextColor
        Description.TextSize = Args.TextSize
        Description.ZIndex = 2 + ZIndex
        Description.Parent = Slider

        SilderFiller.Name = "SilderFiller"
        SilderFiller.BackgroundColor3 = Color3.fromRGB(76, 209, 55)
        SilderFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        SilderFiller.Size = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((Args.Default - Args.Min) / (Args.Max - Args.Min)), 0, 6)
        SilderFiller.ZIndex = 2 + ZIndex
        SilderFiller.BorderMode = Enum.BorderMode.Inset
        SilderFiller.Parent = Slider

        Min_.Name = "Min"
        Min_.Parent = Slider
        Min_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Min_.BackgroundTransparency = 1.000
        Min_.Position = UDim2.new(-0.00555555569, 0, -7.33333397, 0)
        Min_.Size = UDim2.new(0, 77, 0, 50)
        Min_.Font = Args.Font
        Min_.Text = tostring(Args.Min)
        Min_.TextColor3 = Color3.fromRGB(220, 221, 225)
        Min_.TextSize = 14.000
        Min_.TextXAlignment = Enum.TextXAlignment.Left
        Min_.ZIndex = 2 + ZIndex

        Max_.Name = "Max"
        Max_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Max_.BackgroundTransparency = 1.000
        Max_.Position = UDim2.new(0.577777743, 0, -7.33333397, 0)
        Max_.Size = UDim2.new(0, 77, 0, 50)
        Max_.Font = Args.Font
        Max_.Text = tostring(Args.Max)
        Max_.TextColor3 = Color3.fromRGB(220, 221, 225)
        Max_.TextSize = 14.000
        Max_.TextXAlignment = Enum.TextXAlignment.Right
        Max_.ZIndex = 2 + ZIndex
        Max_.Parent = Slider

        PastSliders[WinCount] = true

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    Description.Text = v
                elseif k == "TextColor" then
                    Description.TextColor3 = v
                elseif k == "Font" then
                    Description.Font = CheckEnum(Enum.Font, v)
                    Min_.Font = CheckEnum(Enum.Font, v)
                    Max_.Font = CheckEnum(Enum.Font, v)
                    Current.Font = CheckEnum(Enum.Font, v)
                elseif k == "TextSize" then
                    Description.TextSize = v
                elseif k == "Visible" then
                    Slider.Visible = v
                elseif k == "Value" then
                    v = math.clamp(v, Args.Min, Args.Max)
                    local xOffset = (v - Args.Min)/ Args.Max * (Slider.Size.X.Offset)
                    SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0)
                    SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
                    Current.Text = tostring(math.round(v))
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return Description.Text
                elseif k == "TextColor" then
                    return Description.TextColor3
                elseif k == "Font" then
                    return Description.Font
                elseif k == "TextSize" then
                    return Description.TextSize
                elseif k == "Visible" then
                    return Slider.Visible
                elseif k == "Value" then
                    return tonumber(Current.Text)
                end
            end
        })
    end

    function Functions:Dropdown(_Dropdown, ...)
        local Args = _Dropdown

        if typeof(_Dropdown) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "Dropdown"
        Args.List = (Args.List or Args[2]) or {}
        Args.Callback = (Args.Callback or Args[3]) or function() end
        Args.Selective = (Args.Selective or Args[4]) or false

        Args.Font = Args.Font and CheckEnum(Enum.Font, Args.Font) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Dropdown = Instance.new("TextButton")
        Dropdown.Name = "Dropdown"
        Dropdown.BackgroundColor3 = Arg.FrameColor
        Dropdown.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Dropdown.Position = UDim2.new(0, 12, 0, ListOffset[WinCount])
        Dropdown.Size = UDim2.new(0, 182, 0, 26)
        Dropdown.Selected = true
        Dropdown.Font = Args.Font
        Dropdown.Text = tostring(Args.Text)
        Dropdown.TextColor3 = Args.TextColor
        Dropdown.TextSize = Args.TextSize
        Dropdown.TextStrokeTransparency = 123.000
        Dropdown.TextWrapped = true
        Dropdown.ZIndex = 3 + ZIndex
        Dropdown.Parent = Window

        local DownSign = Instance.new("TextLabel")
        DownSign.Name = "DownSign"
        DownSign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DownSign.BackgroundTransparency = 1.000
        DownSign.Position = UDim2.new(0, 155, 0, 2)
        DownSign.Size = UDim2.new(0, 27, 0, 22)
        DownSign.Font = Enum.Font.SourceSans
        DownSign.Text = "^"
        DownSign.TextColor3 = Color3.fromRGB(220, 221, 225)
        DownSign.TextSize = 20.000
        DownSign.ZIndex = 4 + ZIndex
        DownSign.TextYAlignment = Enum.TextYAlignment.Bottom
        DownSign.Parent = Dropdown

        local DropdownFrame = Instance.new("ScrollingFrame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Active = true
        DropdownFrame.BackgroundColor3 = Arg.FrameColor 
        DropdownFrame.BorderColor3 = Arg.FrameColor 
        DropdownFrame.Position = UDim2.new(0, 0, 0, 28)
        DropdownFrame.Size = UDim2.new(0, 182, 0, 0)
        DropdownFrame.Visible = false
        DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropdownFrame.ScrollBarThickness = 4
        DropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
        DropdownFrame.ZIndex = 5 + ZIndex
        DropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        DropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 221, 225)
        DropdownFrame.Parent = Dropdown

        Dropdown.MouseButton1Down:Connect(function()
            for _,v in pairs(Dropdowns) do
                if v ~= DropdownFrame then
                    v.Visible = false
                    DownSign.Rotation = 0
                end
            end

            DownSign.Rotation = DropdownFrame.Visible and 0 or 180
            DropdownFrame.Visible = not DropdownFrame.Visible
        end)

        table.insert(Dropdowns, DropdownFrame)

        local CanvasSize = 0

        function Func:Button(ButtonText)
            ButtonText = ButtonText or ""

            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundColor3 = Arg.FrameColor
            Button.BorderColor3 = Color3.fromRGB(113, 128, 147)
            Button.Position = UDim2.new(0, 6, 0, CanvasSize + 1)
            Button.Size = UDim2.new(0, 170, 0, 26)
            Button.Selected = true
            Button.Font = Enum.Font.SourceSans
            Button.TextColor3 = Color3.fromRGB(245, 246, 250)
            Button.TextSize = 16.000
            Button.TextStrokeTransparency = 123.000
            Button.ZIndex = 6 + ZIndex
            Button.Text = ButtonText
            Button.TextWrapped = true
            Button.Parent = DropdownFrame

            CanvasSize = CanvasSize + 27

            DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, CanvasSize + 1)

            if #DropdownFrame:GetChildren() < 8 then
                DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset + 27)
            end

            Button.MouseButton1Down:Connect(function()
                Args.Callback(ButtonText)
                DropdownFrame.Visible = false

                if Args.Selective then
                    Dropdown.Text = ButtonText
                end
            end)
        end

        function Func:Remove(ButtonText)
            local Item

            for _,v in ipairs(DropdownFrame:GetChildren()) do
                if Item then
                    CanvasSize = CanvasSize - 27
                    v.Position = UDim2.new(0, 6, 0, v.Position.Y.Offset - 27)
                    DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, CanvasSize + 1)
                end

                if v.Text == ButtonText then
                    Item = true
                    v:Destroy()

                    if #DropdownFrame:GetChildren() < 8 then
                        DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset - 27)
                    end
                end
            end

            if not Item then
                warn("The button you tried to remove didn't exist!")
            end
        end

        for _,v in pairs(Args.List) do
            Func:Button(v)
        end

        return Func
    end

    function Functions:ColorPicker(_ColorPicker, ...)
        local Args = _ColorPicker

        if typeof(_ColorPicker) ~= "table" then
            Args = table.pack(Args, ...)
        end

        Args.Text = (Args.Text or Args[1]) or "ColorPicker"
        Args.Default = (Args.Default or Args[2]) or Color3.fromRGB(255, 255, 255)
        Args.Callback = (Args.Callback or Args[3]) or function() end

        Args.Font = Args.Font and CheckEnum(Enum.Font, Args.Font) or Enum.Font.SourceSans
        Args.TextSize = Args.TextSize or 16
        Args.TextColor = Args.TextColor or Color3.fromRGB(245, 246, 250)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local ColorPicker = Instance.new("TextButton")
        local PickerCorner = Instance.new("UICorner")
        local PickerDescription = Instance.new("TextLabel")
        local ColorPickerFrame = Instance.new("Frame")
        local ToggleRGB = Instance.new("TextButton")
        local ToggleFiller_2 = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local ClosePicker = Instance.new("TextButton")
        local Canvas = Instance.new("Frame")
        local CanvasGradient = Instance.new("UIGradient")
        local Cursor = Instance.new("ImageLabel")
        local Color = Instance.new("Frame")
        local ColorGradient = Instance.new("UIGradient")
        local ColorSlider = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local UICorner = Instance.new("UICorner")
        local ColorCorner = Instance.new("UICorner")
        local BlackOverlay = Instance.new("ImageLabel")

        ColorPicker.Name = "ColorPicker"
        ColorPicker.Position = UDim2.new(0, 137, 0, ListOffset[WinCount])
        ColorPicker.Size = UDim2.new(0, 57, 0, 26)
        ColorPicker.Font = Enum.Font.SourceSans
        ColorPicker.Text = ""
        ColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPicker.TextSize = 14.000
        ColorPicker.ZIndex = 2 + ZIndex
        ColorPicker.Parent = Window
        ColorPicker.MouseButton1Down:Connect(function()
            for _,v in pairs(ColorPickers) do
                v.Visible = false
            end

            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        PickerCorner.Name = "PickerCorner"
        PickerCorner.CornerRadius = UDim.new(0, 2)
        PickerCorner.Parent = ColorPicker

        PickerDescription.Name = "PickerDescription"
        PickerDescription.Parent = ColorPicker
        PickerDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PickerDescription.BackgroundTransparency = 1.000
        PickerDescription.Position = UDim2.new(-2.15789509, 0, 0, 0)
        PickerDescription.Size = UDim2.new(0, 116, 0, 26)
        PickerDescription.Font = Args.Font
        PickerDescription.Text = Args.Text
        PickerDescription.TextColor3 = Args.TextColor
        PickerDescription.TextSize = Args.TextSize
        PickerDescription.TextXAlignment = Enum.TextXAlignment.Left
        PickerDescription.ZIndex = 2 + ZIndex

        ColorPickerFrame.Name = "ColorPickerFrame"
        ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ColorPickerFrame.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ColorPickerFrame.Position = UDim2.new(1.40350854, 0, -2.84615374, 0)
        ColorPickerFrame.Size = UDim2.new(0, 158, 0, 155)
        ColorPickerFrame.ZIndex = 3 + ZIndex
        ColorPickerFrame.Visible = false
        ColorPickerFrame.Parent = ColorPicker

        ToggleRGB.Name = "ToggleRGB"
        ToggleRGB.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ToggleRGB.BorderColor3 = Color3.fromRGB(113, 128, 147)
        ToggleRGB.Position = UDim2.new(0, 125, 0, 127)
        ToggleRGB.Size = UDim2.new(0, 22, 0, 22)
        ToggleRGB.Font = Enum.Font.SourceSans
        ToggleRGB.Text = ""
        ToggleRGB.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleRGB.TextSize = 14.000
        ToggleRGB.ZIndex = 4 + ZIndex
        ToggleRGB.Parent = ColorPickerFrame

        ToggleFiller_2.Name = "ToggleFiller"
        ToggleFiller_2.BackgroundColor3 = Color3.fromRGB(76, 209, 55)
        ToggleFiller_2.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ToggleFiller_2.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller_2.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller_2.ZIndex = 4 + ZIndex
        ToggleFiller_2.Visible = false
        ToggleFiller_2.Parent = ToggleRGB

        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.Position = UDim2.new(-5.13636351, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 106, 0, 22)
        TextLabel.Font = Args.Font
        TextLabel.Text = "Rainbow"
        TextLabel.TextColor3 = Args.TextColor
        TextLabel.TextSize = Args.TextSize
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 4 + ZIndex
        TextLabel.Parent = ToggleRGB

        ClosePicker.Name = "ClosePicker"
        ClosePicker.Parent = ColorPickerFrame
        ClosePicker.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ClosePicker.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ClosePicker.Position = UDim2.new(0, 132, 0, 5)
        ClosePicker.Size = UDim2.new(0, 21, 0, 21)
        ClosePicker.Font = Enum.Font.SourceSans
        ClosePicker.Text = "X"
        ClosePicker.TextColor3 = Color3.fromRGB(245, 246, 250)
        ClosePicker.TextSize = 18.000
        ClosePicker.ZIndex = 4 + ZIndex
        ClosePicker.Parent = ColorPickerFrame
        ClosePicker.MouseButton1Down:Connect(function()
            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        CanvasGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
        CanvasGradient.Name = "CanvasGradient"
        CanvasGradient.Parent = Canvas

        BlackOverlay.Name = "BlackOverlay"
        BlackOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BlackOverlay.BackgroundTransparency = 1.000
        BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
        BlackOverlay.Image = "rbxassetid://5107152095"
        BlackOverlay.ZIndex = 5 + ZIndex
        BlackOverlay.Parent = Canvas

        UICorner.Name = "UICorner"
        UICorner.CornerRadius = UDim.new(0, 2)
        UICorner.Parent = Canvas

        Cursor.Name = "Cursor"
        Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Cursor.BackgroundTransparency = 1.000
        Cursor.Size = UDim2.new(0, 8, 0, 8)
        Cursor.Image = "rbxassetid://5100115962"
        Cursor.ZIndex = 5 + ZIndex
        Cursor.Parent = Canvas

        local _Color3
        local DraggingColor = false
        local Hue, Sat, Brightness = 0, 1, 1

        local Connection
        ToggleRGB.MouseButton1Down:Connect(function()
            ToggleFiller_2.Visible = not ToggleFiller_2.Visible

            if ToggleFiller_2.Visible then
                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local Hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(Hue2, 1, 1)
                        Args.Callback(_Color3, true, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
        end)

        if Args.Default and typeof(Args.Default) == "boolean" then
            ToggleFiller_2.Visible = true

            if ToggleFiller_2.Visible then
                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local Hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(Hue2, 1, 1)
                        Args.Callback(_Color3, true, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
        else
            ColorPicker.BackgroundColor3 = Args.Default
        end

        Canvas.Name = "Canvas"
        Canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Canvas.Position = UDim2.new(0, 5, 0, 34)
        Canvas.Size = UDim2.new(0, 148, 0, 64)
        Canvas.ZIndex = 4 + ZIndex
        Canvas.Parent = ColorPickerFrame

        local CanvasSize, CanvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition

        Canvas.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local Initial = Vector2.new(Cursor.Position.X.Offset, Cursor.Position.Y.Offset)
                local Delta = Cursor.AbsolutePosition - Initial

                local _Connection
                local IsDragging = true

                _Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local Delta2 = Vector2.new(Mouse.X, Mouse.Y) - Delta
                        local X = math.clamp(Delta2.X, 2, Canvas.Size.X.Offset - 2)
                        local Y = math.clamp(Delta2.Y, 2, Canvas.Size.Y.Offset - 2)

                        Sat = 1 - math.clamp((Mouse.X - CanvasPosition.X) / CanvasSize.X, 0, 1)
				        Brightness = 1 - math.clamp((Mouse.Y - CanvasPosition.Y) / CanvasSize.Y, 0, 1)

                        _Color3 = Color3.fromHSV(Hue, Sat, Brightness)

                        Cursor.Position = UDim2.fromOffset(X - 4, Y - 4)
                        ColorPicker.BackgroundColor3 = _Color3
                        Args.Callback(_Color3, false, Func)
                    else
                        _Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end)

        Color.Name = "Color"
        Color.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Color.Position = UDim2.new(0, 5, 0, 105)
        Color.Size = UDim2.new(0, 148, 0, 14)
        Color.BorderMode = Enum.BorderMode.Inset
        Color.ZIndex = 4 + ZIndex
        Color.Parent = ColorPickerFrame
        Color.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                DraggingColor = true
                local Initial  = ColorSlider.Position.X.Offset
                local Delta = ColorSlider.AbsolutePosition.X - Initial

                local _Connection
                _Connection = RunService.Stepped:Connect(function()
                    if DraggingColor then
                        local ColorPosition, ColorSize = Color.AbsolutePosition, Color.AbsoluteSize
                        Hue = 1 - math.clamp(1 - ((Mouse.X - ColorPosition.X) / ColorSize.X), 0, 1)
                        CanvasGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromHSV(Hue, 1, 1)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}

                        local xOffset = math.clamp(Mouse.X - Delta, 0, Color.Size.X.Offset - 3)
                        ColorSlider.Position = UDim2.new(0, xOffset, 0, 0);

                        _Color3 = Color3.fromHSV(Hue, Sat, Brightness)
                        ColorPicker.BackgroundColor3  = _Color3
                        Args.Callback(_Color3, false, Func)
                    else
                        _Connection:Disconnect()
                    end
                end)
            end
        end)

        Color.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                DraggingColor = false
            end
        end)

        ColorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        ColorGradient.Name = "ColorGradient"
        ColorGradient.Parent = Color

        ColorCorner.Name = "ColorCorner"
        ColorCorner.CornerRadius = UDim.new(0, 2)
        ColorCorner.Parent = Color

        ColorSlider.Name = "ColorSlider"
        ColorSlider.BackgroundColor3 = Color3.fromRGB(245, 246, 250)
        ColorSlider.BorderColor3 = Color3.fromRGB(245, 246, 250)
        ColorSlider.Size = UDim2.new(0, 2, 0, 14)
        ColorSlider.ZIndex = 5 + ZIndex
        ColorSlider.Parent = Color

        Title.Name = "Title"
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(0, 118, 0, 21)
        Title.Font = Args.Font
        Title.Text = Args.Text
        Title.TextColor3 = Args.TextColor
        Title.TextSize = 16.000
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 4 + ZIndex
        Title.Parent = ColorPickerFrame

        table.insert(ColorPickers, ColorPickerFrame)

        function Func:UpdateColorPicker(Value)
            if type(Value) == "userdata" then
                ToggleFiller_2.Visible = false
                ColorPicker.BackgroundColor3 = Value
            elseif Value and type(Value) == "boolean" and not Connection then
                ToggleFiller_2.Visible = true

                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(hue2, 1, 1)
                        Args.Callback(_Color3, false, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
	    end

        return setmetatable(Func, {
            __newindex = function(t, k, v)
                if k == "Text" then
                    Title.Text = v
                    PickerDescription.Text = v
                elseif k == "TextColor" then
                    Title.TextColor3 = v
                    TextLabel.TextColor3 = v
                    PickerDescription.TextColor3 = v
                elseif k == "TextSize" then
                    Title.TextSize = v
                    TextLabel.TextSize = v
                    PickerDescription.TextSize = v
                elseif k == "Font" then
                    TextLabel.Font = CheckEnum(Enum.Font, v)
                    Title.Font = CheckEnum(Enum.Font, v)
                    PickerDescription.Font = CheckEnum(Enum.Font, v)
                elseif k == "Visible" then
                    ColorPicker.Visible = v
                elseif k == "UpdateColorPicker" then
                    if typeof(v) == "Color3" then
                        ToggleFiller_2.Visible = false
                        ColorPicker.BackgroundColor3 = v
                    elseif v and type(v) == "boolean" and not Connection then
                        ToggleFiller_2.Visible = true

                        Connection = RunService.Stepped:Connect(function()
                            if ToggleFiller_2.Visible then
                                local hue2 = tick() % 5 / 5
                                _Color3 = Color3.fromHSV(hue2, 1, 1)
                                Args.Callback(_Color3, false, Func)
                                ColorPicker.BackgroundColor3 = _Color3
                            else
                                Connection:Disconnect()
                            end
                        end)
                    end
                end
            end,
            __index = function(t, k)
                if k == "Text" then
                    return PickerDescription.Text
                elseif k == "TextColor" then
                    return PickerDescription.TextColor3
                elseif k == "TextSize" then
                    return PickerDescription.TextSize
                elseif k == "Font" then
                    return PickerDescription.Font
                elseif k == "Visible" then
                    return ColorPicker.Visible
                end
            end
        })
    end

    function Functions:DestroyUI()
        Functions:Button("Destroy UI", function()
            NewInstance:Destroy()
        end)
    end

    function Functions:HideUI(Keybind)
        Keybind = Keybind or Setting.Key

        Functions:Bind({
            Text = "Hide UI",
            Bind = Keybind,
            Enabled = true,
            Callback = function(State, Key)
                NewInstance.Enabled = State

                if writefile then
                    Setting.Key = Key
                    writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
                end
            end
        })
    end

    function Functions:MinimizeWindows()
        Functions:Toggle({
            Text = "Minimize Windows",
            Enabled = Setting.Minimized,
            Callback = function(State, Func)
                for _,v in pairs(NewInstance:GetChildren()) do
                    if not v.Header.Window:GetAttribute("MinimizeButton") then
                        v.Header.Window.Visible = not State
                        v.Header.Minimize.Text = v.Header.Window.Visible and "-" or "+"
                    end
                end

                if writefile then
                    Setting.Minimized = Func.State
                    writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
                end
            end
        })
    end

    return Functions, setmetatable(Functions, {
        __newindex = function(t, k, v)
            if k == "Text" then
                HeaderText.Text = v
            elseif k == "TextColor" then
                HeaderText.TextColor3 = v
            elseif k == "Font" then
                HeaderText.Font = CheckEnum(Enum.Font, v)
            end
        end,
        __index = function(t, k)
            if k == "Text" then
                return HeaderText.Text
            elseif k == "TextColor" then
                return HeaderText.TextColor3
            elseif k == "Font" then
                return HeaderText.Font
            end
        end
    })
end

return Library