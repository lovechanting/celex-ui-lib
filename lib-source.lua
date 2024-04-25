local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Name = "Toggle"
    frame.Size = UDim2.new(0, 100, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.Size = UDim2.new(0.5, 0, 1, 0)
    toggle.Position = UDim2.new(0.5, 0, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.Text = default and "ON" or "OFF"
        toggle.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        callback(default)
    end)
    
    frame.Parent = parent
    return frame
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Name = "Slider"
    frame.Size = UDim2.new(0, 200, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    
    local slider = Instance.new("TextButton")
    slider.Parent = frame
    slider.Size = UDim2.new(0.5, 0, 1, 0)
    slider.Position = UDim2.new(0.5, 0, 0, 0)
    slider.Text = ">"
    slider.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.BackgroundTransparency = 1
    
    local dragging = false
    local function updateValue()
        local percent = (slider.Position.X.Offset - 5) / (frame.Size.X.Offset - 10)
        local newValue = min + (max - min) * percent
        newValue = math.floor(newValue)
        valueLabel.Text = tostring(newValue)
        callback(newValue)
    end
    
    slider.MouseButton1Down:Connect(function()
        dragging = true
        updateValue()
    end)
    
    slider.MouseButton1Up:Connect(function()
        dragging = false
    end)
    
    slider.MouseMoved:Connect(function()
        if dragging then
            local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
            local framePosition = frame.AbsolutePosition
            local relativeX = mousePosition.X - framePosition.X
            relativeX = math.max(5, math.min(frame.Size.X.Offset - 5, relativeX))
            slider.Position = UDim2.new(0, relativeX, 0, 0)
            updateValue()
        end
    end)
    
    frame.Parent = parent
    return frame
end

-- Main UI Class

local CheetoUI = {}
CheetoUI.__index = CheetoUI

function CheetoUI.new()
    local self = setmetatable({}, CheetoUI)
    
    self.gui = Instance.new("ScreenGui")
    self.frame = Instance.new("Frame")
    self.tabs = {}
    
    self.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.frame.Parent = self.gui
    self.frame.BackgroundColor3 = Color3.new(0.0352941, 0.0313726, 0.0352941)
    self.frame.Size = UDim2.new(0, 457, 0, 333)
    
    return self
end

function CheetoUI:Tab(name)
    local tab = {}
    tab.name = name
    tab.pages = {}
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name
    tabFrame.Size = UDim2.new(0, 100, 0, 30)
    tabFrame.BackgroundColor3 = Color3.new(0.0352941, 0.0313726, 0.0352941)
    
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabFrame
    tabButton.Size = UDim2.new(1, 0, 1, 0)
    tabButton.Text = name
    tabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(tab.pages) do
            page.frame.Visible = false
        end
        self:ShowTab(name)
    end)
    
    tab.frame = tabFrame
    self.tabs[name] = tab
    
    return tab
end

function CheetoUI:ShowTab(name)
    for tabName, tab in pairs(self.tabs) do
        if tabName == name then
            tab.frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        else
            tab.frame.BackgroundColor3 = Color3.new(0.0352941, 0.0313726, 0.0352941)
        end
    end
end

function CheetoUI:Page(tabName)
    local tab = self.tabs[tabName]
    if not tab then return end
    
    local page = {}
    page.elements = {}
    
    local pageFrame = Instance.new("Frame")
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.Position = UDim2.new(0, 0, 0, 30)
    pageFrame.Visible = false
    pageFrame.Parent = self.frame
    
    tab.pages[#tab.pages + 1] = {
        name = "Page",
        frame = pageFrame,
        elements = page.elements
    }
    
    tab.pages[1].frame.Visible = true
    
    return page
end

function CheetoUI:Toggle(parent, text, default, callback)
    local toggle = CreateToggle(parent, text, default, callback)
    toggle.Parent = parent
    table.insert(parent.elements, toggle)
end

function CheetoUI:Button(parent, text, callback)
    local button = CreateButton(parent, text, callback)
    button.Parent = parent
    table.insert(parent.elements, button)
end

function CheetoUI:Slider(parent, text, min, max, default, callback)
    local slider = CreateSlider(parent, text, min, max, default, callback)
    slider.Parent = parent
    table.insert(parent.elements, slider)
end
