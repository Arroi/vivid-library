--[[
    VividLibrary
    A modern UI library for Roblox exploits
    Version: 1.0.0
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local COLORS = {
    WindowBackground = Color3.fromRGB(24, 24, 24),
    Sidebar = Color3.fromRGB(30, 30, 30),
    DarkContrast = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(255, 255, 255),
    TextDimmed = Color3.fromRGB(175, 175, 175),
    AccentColor = Color3.fromRGB(40, 40, 40)
}

local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function Library.new(name)
    local window = {}
    local tabs = {}
    local activeTab = nil
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VividLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main window
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.BackgroundColor3 = COLORS.WindowBackground
    Window.BorderSizePixel = 1
    Window.BorderColor3 = COLORS.AccentColor
    Window.Position = UDim2.new(0.5, -300, 0.5, -200)
    Window.Size = UDim2.new(0, 600, 0, 400)
    Window.Parent = ScreenGui
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    Window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = COLORS.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.Parent = Window
    
    -- Pages Label
    local PagesLabel = Instance.new("TextLabel")
    PagesLabel.Name = "PagesLabel"
    PagesLabel.BackgroundTransparency = 1
    PagesLabel.Position = UDim2.new(0, 15, 0, 15)
    PagesLabel.Size = UDim2.new(1, -30, 0, 20)
    PagesLabel.Font = Enum.Font.GothamMedium
    PagesLabel.Text = "Pages"
    PagesLabel.TextColor3 = COLORS.TextDimmed
    PagesLabel.TextSize = 14
    PagesLabel.TextXAlignment = Enum.TextXAlignment.Left
    PagesLabel.Parent = Sidebar
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.Size = UDim2.new(1, 0, 1, -45)
    TabContainer.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)
    TabPadding.Parent = TabContainer
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundColor3 = COLORS.WindowBackground
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 150, 0, 0)
    ContentArea.Size = UDim2.new(1, -150, 1, 0)
    ContentArea.Parent = Window
    
    -- Separator Line
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.BackgroundColor3 = COLORS.AccentColor
    Separator.BorderSizePixel = 0
    Separator.Position = UDim2.new(0, 150, 0, 0)
    Separator.Size = UDim2.new(0, 1, 1, 0)
    Separator.Parent = Window
    
    function window:AddTab(name)
        local tab = {}
        tab.AddButton = function(_, text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.BackgroundColor3 = COLORS.DarkContrast
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = COLORS.TextColor
            Button.TextSize = 13
            Button.Parent = TabContent
            
            Button.MouseButton1Click:Connect(callback or function() end)
            return Button
        end
        
        tab.AddToggle = function(_, text, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = text
            Toggle.BackgroundColor3 = COLORS.DarkContrast
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.Size = UDim2.new(1, -46, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = COLORS.TextColor
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle
            
            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.AnchorPoint = Vector2.new(1, 0.5)
            Switch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
            Switch.BorderSizePixel = 0
            Switch.Position = UDim2.new(1, -8, 0.5, 0)
            Switch.Size = UDim2.new(0, 30, 0, 16)
            Switch.Parent = Toggle
            
            local value = default or false
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    value = not value
                    Switch.BackgroundColor3 = value and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
                    if callback then callback(value) end
                end
            end)
            
            return Toggle
        end
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = COLORS.AccentColor
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = name
        TabButton.TextColor3 = COLORS.TextDimmed
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = COLORS.AccentColor
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 6)
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.Parent = TabContent
        
        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            if activeTab then
                -- Deselect old tab
                TweenService:Create(activeTab.button, TWEEN_INFO, {
                    BackgroundTransparency = 1,
                    TextColor3 = COLORS.TextDimmed
                }):Play()
                activeTab.content.Visible = false
            end
            
            -- Select new tab
            TweenService:Create(TabButton, TWEEN_INFO, {
                BackgroundTransparency = 0,
                TextColor3 = COLORS.TextColor
            }):Play()
            TabContent.Visible = true
            
            activeTab = {button = TabButton, content = TabContent}
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if not activeTab or TabButton ~= activeTab.button then
                TweenService:Create(TabButton, TWEEN_INFO, {
                    BackgroundTransparency = 0.8,
                    TextColor3 = COLORS.TextColor
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not activeTab or TabButton ~= activeTab.button then
                TweenService:Create(TabButton, TWEEN_INFO, {
                    BackgroundTransparency = 1,
                    TextColor3 = COLORS.TextDimmed
                }):Play()
            end
        end)
        
        -- Component Creation Functions
        function tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.BackgroundColor3 = COLORS.DarkContrast
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = COLORS.TextColor
            Button.TextSize = 13
            Button.Parent = TabContent
            
            Button.MouseButton1Click:Connect(callback or function() end)
            return Button
        end
        
        function tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = text
            Toggle.BackgroundColor3 = COLORS.DarkContrast
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.Size = UDim2.new(1, -46, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = COLORS.TextColor
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle
            
            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.AnchorPoint = Vector2.new(1, 0.5)
            Switch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
            Switch.BorderSizePixel = 0
            Switch.Position = UDim2.new(1, -8, 0.5, 0)
            Switch.Size = UDim2.new(0, 30, 0, 16)
            Switch.Parent = Toggle
            
            local value = default or false
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    value = not value
                    Switch.BackgroundColor3 = value and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
                    if callback then callback(value) end
                end
            end)
            
            return Toggle
        end
        
        -- Select first tab by default
        if #tabs == 0 then
            TabButton.MouseButton1Click:Fire()
        end
        
        table.insert(tabs, tab)
        return tab
    end
    
    -- Return the window object with its methods
    return setmetatable(window, {
        __index = window
    })
end

return Library