--[[
    VividLibrary
    A modern, resizable UI library for Roblox exploits
    Version: 1.0.0
]]

local VividLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local SIDEBAR_DEFAULT_WIDTH = 200
local SIDEBAR_MIN_WIDTH = 150
local SIDEBAR_MAX_WIDTH = 400
local TWEEN_SPEED = 0.15

-- Create base GUI
function VividLibrary.new(title)
    local gui = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VividLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, _ = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0, 20, 0, 20)
    MainFrame.Size = UDim2.new(0, SIDEBAR_DEFAULT_WIDTH, 0, 400)
    MainFrame.Parent = ScreenGui
    
    -- Add shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = MainFrame
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(1, -20, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = title or "Vivid Library"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(1, 0, 1, -30)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
    TabContainer.Parent = MainFrame
    
    -- Add UIListLayout for tabs
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 2)
    TabList.Parent = TabContainer
    
    -- Resizing functionality
    local Resizer = Instance.new("Frame")
    Resizer.Name = "Resizer"
    Resizer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Resizer.BorderSizePixel = 0
    Resizer.Position = UDim2.new(1, -2, 0, 0)
    Resizer.Size = UDim2.new(0, 2, 1, 0)
    Resizer.Parent = MainFrame
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
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
    
    -- Resizing logic
    local resizing = false
    local originalWidth = SIDEBAR_DEFAULT_WIDTH
    
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            originalWidth = MainFrame.Size.X.Offset
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position.X - Resizer.AbsolutePosition.X
            local newWidth = math.clamp(originalWidth + delta, SIDEBAR_MIN_WIDTH, SIDEBAR_MAX_WIDTH)
            MainFrame.Size = UDim2.new(0, newWidth, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    -- Tab creation function
    function gui:AddTab(name)
        local tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        
        -- Content frame for this tab
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = name.."Content"
        ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.Visible = false
        ContentFrame.Parent = TabContainer
        
        -- Add components container
        local ComponentContainer = Instance.new("ScrollingFrame")
        ComponentContainer.Name = "Components"
        ComponentContainer.BackgroundTransparency = 1
        ComponentContainer.Size = UDim2.new(1, -10, 1, 0)
        ComponentContainer.Position = UDim2.new(0, 5, 0, 0)
        ComponentContainer.ScrollBarThickness = 2
        ComponentContainer.Parent = ContentFrame
        
        local ComponentList = Instance.new("UIListLayout")
        ComponentList.Padding = UDim.new(0, 5)
        ComponentList.Parent = ComponentContainer
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all content frames
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("Frame") and child.Name:match("Content$") then
                    child.Visible = false
                end
            end
            -- Show this tab's content
            ContentFrame.Visible = true
        end)
        
        -- Component creation functions
        function tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Parent = ComponentContainer
            
            Button.MouseButton1Click:Connect(callback or function() end)
            return Button
        end
        
        function tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = text
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            Toggle.Parent = ComponentContainer
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle
            
            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
            Switch.BorderSizePixel = 0
            Switch.Position = UDim2.new(1, -40, 0.5, -10)
            Switch.Size = UDim2.new(0, 30, 0, 20)
            Switch.Parent = Toggle
            
            local value = default or false
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    value = not value
                    Switch.BackgroundColor3 = value and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 64, 64)
                    if callback then
                        callback(value)
                    end
                end
            end)
            
            return Toggle
        end
        
        return tab
    end
    
    return gui
end

return VividLibrary
