local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")
-- Marcador de Destino (Home Base): Coordenada fixa da base para teletransporte
local targetPosition = Vector3.new(-336.7, -7.2, 86.8) -- coordenada da home base
local flashTPEnabled = true
local xRayEnabled = true
local alignEnabled = false
local tpDistance = 10 -- exemplo, talvez não usado no teleporte fixo

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function teleportCharacter()
    -- 3. Garantir o Teletransporte Exato
    -- Usa os números exatos do Developer Console para teletransportar exatamente para a base
    local character = getCharacter()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    if alignEnabled then
        -- Align with camera direction on horizontal axis and reset velocities
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookVector)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    
    hrp.CFrame = CFrame.new(targetPosition)
    
    -- 4. Evitar que o Boneco "Caia" do Mapa
    -- Trava o personagem por 0.2 segundos para o chão carregar, evitando queda
    hrp.Anchored = true
    task.wait(0.2)
    hrp.Anchored = false
end

local function toggleXRay()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
            part.Transparency = xRayEnabled and 0.5 or 0
        end
    end
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
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LK7 HUB | Flash TP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local toggleFlashTP = Instance.new("TextButton")
toggleFlashTP.Name = "ToggleFlashTP"
toggleFlashTP.Size = UDim2.new(0.8, 0, 0, 40)
toggleFlashTP.Position = UDim2.new(0.1, 0, 0, 50)
toggleFlashTP.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
toggleFlashTP.BorderSizePixel = 0
toggleFlashTP.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFlashTP.Font = Enum.Font.GothamBold
toggleFlashTP.TextScaled = true
toggleFlashTP.Text = "Ativar Flash TP: OFF"
toggleFlashTP.Parent = frame

local uiCornerToggle = Instance.new("UICorner")
uiCornerToggle.CornerRadius = UDim.new(0, 8)
uiCornerToggle.Parent = toggleFlashTP

local toggleXRay = Instance.new("TextButton")
toggleXRay.Name = "ToggleXRay"
toggleXRay.Size = UDim2.new(0.8, 0, 0, 40)
toggleXRay.Position = UDim2.new(0.1, 0, 0, 100)
toggleXRay.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
toggleXRay.BorderSizePixel = 0
toggleXRay.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleXRay.Font = Enum.Font.GothamBold
toggleXRay.TextScaled = true
toggleXRay.Text = "X-Ray: OFF"
toggleXRay.Parent = frame

local uiCornerXRay = Instance.new("UICorner")
uiCornerXRay.CornerRadius = UDim.new(0, 8)
uiCornerXRay.Parent = toggleXRay

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Name = "SliderLabel"
sliderLabel.Size = UDim2.new(0.8, 0, 0, 30)
sliderLabel.Position = UDim2.new(0.1, 0, 0, 150)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Distância TP: " .. tpDistance
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.TextScaled = true
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.Parent = frame

local minusButton = Instance.new("TextButton")
minusButton.Name = "MinusButton"
minusButton.Size = UDim2.new(0, 40, 0, 40)
minusButton.Position = UDim2.new(0.1, 0, 0, 180)
minusButton.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
minusButton.BorderSizePixel = 0
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.Font = Enum.Font.GothamBold
minusButton.TextScaled = true
minusButton.Text = "-"
minusButton.Parent = frame

local uiCornerMinus = Instance.new("UICorner")
uiCornerMinus.CornerRadius = UDim.new(0, 8)
uiCornerMinus.Parent = minusButton

local plusButton = Instance.new("TextButton")
plusButton.Name = "PlusButton"
plusButton.Size = UDim2.new(0, 40, 0, 40)
plusButton.Position = UDim2.new(0.7, 0, 0, 180)
plusButton.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
plusButton.BorderSizePixel = 0
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.Font = Enum.Font.GothamBold
plusButton.TextScaled = true
plusButton.Text = "+"
plusButton.Parent = frame

local uiCornerPlus = Instance.new("UICorner")
uiCornerPlus.CornerRadius = UDim.new(0, 8)
uiCornerPlus.Parent = plusButton

local alignButton = Instance.new("TextButton")
alignButton.Name = "AlignButton"
alignButton.Size = UDim2.new(0.8, 0, 0, 40)
alignButton.Position = UDim2.new(0.1, 0, 0, 230)
alignButton.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
alignButton.BorderSizePixel = 0
alignButton.TextColor3 = Color3.fromRGB(255, 255, 255)
alignButton.Font = Enum.Font.GothamBold
alignButton.TextScaled = true
alignButton.Text = "ALIGN: OFF"
alignButton.Parent = frame

local uiCornerAlign = Instance.new("UICorner")
uiCornerAlign.CornerRadius = UDim.new(0, 8)
uiCornerAlign.Parent = alignButton

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0.8, 0, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0, 280)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
teleportButton.BorderSizePixel = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextScaled = true
teleportButton.Text = "Teleportar Agora"
teleportButton.Parent = frame

local uiCornerTeleport = Instance.new("UICorner")
uiCornerTeleport.CornerRadius = UDim.new(0, 10)
uiCornerTeleport.Parent = teleportButton

toggleFlashTP.MouseButton1Click:Connect(function()
    flashTPEnabled = true
    toggleFlashTP.Text = "Ativar Flash TP: ON"
end)

toggleXRay.MouseButton1Click:Connect(function()
    xRayEnabled = true
    toggleXRay.Text = "X-Ray: ON"
    toggleXRay()
end)

minusButton.MouseButton1Click:Connect(function()
    tpDistance = math.max(1, tpDistance - 1)
    sliderLabel.Text = "Distância TP: " .. tpDistance
end)

plusButton.MouseButton1Click:Connect(function()
    tpDistance = math.min(100, tpDistance + 1)
    sliderLabel.Text = "Distância TP: " .. tpDistance
end)

alignButton.MouseButton1Click:Connect(function()
    alignEnabled = not alignEnabled
    alignButton.Text = "ALIGN: " .. (alignEnabled and "ON" or "OFF")
end)

teleportButton.MouseButton1Click:Connect(function()
    -- 1. Conectar ao Botão da Interface (GUI)
    -- Este evento conecta o clique do botão "Teleportar Agora" à função de teletransporte
    local character = getCharacter()
    local equippedTool = getEquippedTool(character)

    -- 2. Definir a Regra de Uso (Segurança)
    -- Verifica se o item "flash tp" está equipado para evitar teletransporte sem querer
    -- Se não estiver, apenas ignora, evitando detecção por anti-cheat
    if equippedTool and equippedTool.Name == "flash tp" then
        teleportCharacter()
    end
end)
