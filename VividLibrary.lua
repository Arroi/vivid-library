--[[
    VividLibrary
    A modern, collapsible sidebar UI library for Roblox exploits
    Version: 1.0.0
]]

local VividLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local SIDEBAR_DEFAULT_WIDTH = 250
local SIDEBAR_MIN_WIDTH = 200
local SIDEBAR_MAX_WIDTH = 400
local TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local COLORS = {
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(30, 30, 30),
    TopBar = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(175, 175, 175),
    AccentPrimary = Color3.fromRGB(65, 65, 65),
    AccentSecondary = Color3.fromRGB(45, 45, 45)
}

-- Constants
local SIDEBAR_DEFAULT_WIDTH = 200
local SIDEBAR_MIN_WIDTH = 150
local SIDEBAR_MAX_WIDTH = 400
local TWEEN_SPEED = 0.15

-- Create base GUI
function VividLibrary.new(title)
    local gui = {}
    
    -- Create base ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VividLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, _ = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Background Frame (covers entire screen)
    local BackgroundFrame = Instance.new("Frame")
    BackgroundFrame.Name = "BackgroundFrame"
    BackgroundFrame.BackgroundColor3 = COLORS.Background
    BackgroundFrame.BorderSizePixel = 0
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.Parent = ScreenGui

    -- Sidebar Frame
    local SidebarFrame = Instance.new("Frame")
    SidebarFrame.Name = "SidebarFrame"
    SidebarFrame.BackgroundColor3 = COLORS.Sidebar
    SidebarFrame.BorderSizePixel = 0
    SidebarFrame.Position = UDim2.new(0, 0, 0, 0)
    SidebarFrame.Size = UDim2.new(0, SIDEBAR_DEFAULT_WIDTH, 1, 0)
    SidebarFrame.Parent = BackgroundFrame

    -- Add blur effect to background
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 10
    BlurEffect.Parent = game:GetService("Lighting")
    
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
    
    -- Sidebar Header
    local SidebarHeader = Instance.new("Frame")
    SidebarHeader.Name = "SidebarHeader"
    SidebarHeader.BackgroundColor3 = COLORS.TopBar
    SidebarHeader.BorderSizePixel = 0
    SidebarHeader.Size = UDim2.new(1, 0, 0, 50)
    SidebarHeader.Parent = SidebarFrame

    -- Pages Label
    local PagesLabel = Instance.new("TextLabel")
    PagesLabel.Name = "PagesLabel"
    PagesLabel.BackgroundTransparency = 1
    PagesLabel.Position = UDim2.new(0, 15, 0, 0)
    PagesLabel.Size = UDim2.new(1, -30, 1, 0)
    PagesLabel.Font = Enum.Font.GothamMedium
    PagesLabel.Text = "Pages"
    PagesLabel.TextColor3 = COLORS.TextDim
    PagesLabel.TextSize = 14
    PagesLabel.TextXAlignment = Enum.TextXAlignment.Left
    PagesLabel.Parent = SidebarHeader
    
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
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = COLORS.AccentPrimary
    TabContainer.Parent = SidebarFrame

    -- Content Frame (right side)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, SIDEBAR_DEFAULT_WIDTH, 0, 0)
    ContentFrame.Size = UDim2.new(1, -SIDEBAR_DEFAULT_WIDTH, 1, 0)
    ContentFrame.Parent = BackgroundFrame
    
    -- Add UIListLayout for tabs
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    -- Add UIPadding for tabs
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Resizing functionality
    local Resizer = Instance.new("Frame")
    Resizer.Name = "Resizer"
    Resizer.BackgroundColor3 = COLORS.AccentPrimary
    Resizer.BorderSizePixel = 0
    Resizer.Position = UDim2.new(1, -2, 0, 0)
    Resizer.Size = UDim2.new(0, 2, 1, 0)
    Resizer.Parent = SidebarFrame
    
    -- Resizing logic
    local resizing = false
    local startX = nil
    local startWidth = nil
    
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startX = input.Position.X
            startWidth = SidebarFrame.Size.X.Offset
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position.X - startX
            local newWidth = math.clamp(startWidth + delta, SIDEBAR_MIN_WIDTH, SIDEBAR_MAX_WIDTH)
            
            -- Update sidebar width
            SidebarFrame.Size = UDim2.new(0, newWidth, 1, 0)
            
            -- Update content frame position
            ContentFrame.Position = UDim2.new(0, newWidth, 0, 0)
            ContentFrame.Size = UDim2.new(1, -newWidth, 1, 0)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
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
        TabButton.BackgroundColor3 = COLORS.AccentSecondary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = name
        TabButton.TextColor3 = COLORS.TextDim
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer

        -- Add hover effect
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TWEEN_INFO, {
                BackgroundTransparency = 0,
                TextColor3 = COLORS.Text
            }):Play()
        end)

        TabButton.MouseLeave:Connect(function()
            if not TabButton.Selected then
                TweenService:Create(TabButton, TWEEN_INFO, {
                    BackgroundTransparency = 1,
                    TextColor3 = COLORS.TextDim
                }):Play()
            end
        end)
        
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
