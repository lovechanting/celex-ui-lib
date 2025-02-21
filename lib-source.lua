local CheetoUI = {}
CheetoUI.__index = CheetoUI

function CheetoUI.new()
    local self = setmetatable({}, CheetoUI)
    
    self.gui = Instance.new("ScreenGui")
    self.frame = Instance.new("Frame")
    self.tabs = {}
    
    self.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.frame.Parent = self.gui
    self.frame.BackgroundColor3 = Color3.new(0.035, 0.031, 0.035)
    self.frame.Size = UDim2.new(0, 457, 0, 333)
    
    return self
end

function CheetoUI:Tab(name)
    local tab = { name = name, pages = {} }
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name
    tabFrame.Size = UDim2.new(0, 100, 0, 30)
    tabFrame.BackgroundColor3 = Color3.new(0.035, 0.031, 0.035)
    
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
        tab.frame.BackgroundColor3 = tabName == name and Color3.new(0.2, 0.2, 0.2) or Color3.new(0.035, 0.031, 0.035)
    end
end

function CheetoUI:Page(tabName)
    local tab = self.tabs[tabName]
    if not tab then return end
    
    local page = { elements = {} }
    local pageFrame = Instance.new("Frame")
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.Position = UDim2.new(0, 0, 0, 30)
    pageFrame.Visible = false
    pageFrame.Parent = self.frame
    
    table.insert(tab.pages, { name = "Page", frame = pageFrame, elements = page.elements })
    tab.pages[1].frame.Visible = true
    
    return page
end

function CheetoUI:CreateToggle(parent, text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Parent = parent
    toggle.Size = UDim2.new(0, 100, 0, 30)
    toggle.Text = default and "ON" or "OFF"
    toggle.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.Text = default and "ON" or "OFF"
        toggle.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        callback(default)
    end)
    
    return toggle
end

function CheetoUI:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function CheetoUI:CreateSlider(parent, text, min, max, default, callback)
    local slider = Instance.new("TextButton")
    slider.Parent = parent
    slider.Size = UDim2.new(0, 200, 0, 30)
    slider.Text = text .. ": " .. tostring(default)
    slider.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    
    slider.MouseButton1Click:Connect(function()
        local newValue = math.clamp(default + 1, min, max)
        slider.Text = text .. ": " .. tostring(newValue)
        callback(newValue)
    end)
    
    return slider
end

return CheetoUI
