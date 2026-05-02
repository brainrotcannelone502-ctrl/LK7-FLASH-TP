local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")
local targetPosition = Vector3.new(-336.7, -7.2, 86.8) -- coordenada segura
local flashTPEnabled = false

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function teleportCharacter()
    local character = getCharacter()
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPosition)
    hrp.Anchored = true
    task.wait(0.2)
    hrp.Anchored = false
end

local function updateStatusLabel(label)
    if flashTPEnabled then
        label.Text = "Status: Ativado"
    else
        label.Text = "Status: Desativado"
    end
end

local function enableFlashTP(statusLabel)
    flashTPEnabled = true
    updateStatusLabel(statusLabel)
end

local function disableFlashTP(statusLabel)
    flashTPEnabled = false
    updateStatusLabel(statusLabel)
end

local function getEquippedTool(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LK7FlashTPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LK7 Flash TP"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -24, 0, 30)
statusLabel.Position = UDim2.new(0, 12, 0, 44)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
statusLabel.BorderSizePixel = 0
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Text = "Status: Desativado"
statusLabel.Parent = frame

local function createButton(name, text, posY)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -24, 0, 34)
    button.Position = UDim2.new(0, 12, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Text = text
    button.Parent = frame
    return button
end

local activateButton = createButton("ActivateButton", "Ativar Flash TP", 84)
local teleportButton = createButton("TeleportButton", "Teleportar Agora", 128)
local closeButton = createButton("CloseButton", "Fechar Painel", 172)

activateButton.MouseButton1Click:Connect(function()
    if flashTPEnabled then
        disableFlashTP(statusLabel)
        activateButton.Text = "Ativar Flash TP"
    else
        enableFlashTP(statusLabel)
        activateButton.Text = "Desativar Flash TP"
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local equippedTool = getEquippedTool(character)

    if equippedTool and equippedTool.Name:lower() == "brainrot" then
        if not flashTPEnabled then
            enableFlashTP(statusLabel)
            activateButton.Text = "Desativar Flash TP"
        end
        teleportCharacter()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

updateStatusLabel(statusLabel)
