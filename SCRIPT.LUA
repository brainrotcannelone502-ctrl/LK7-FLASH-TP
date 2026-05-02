local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KanyeHub_V30_Stable"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (ESTILO KANYEHUB - image_97ad99.png)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 15)

-- TÍTULO
local Title = Instance.new("TextLabel", Main)
Title.Text = "KANYEHUB FLASH TP"
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.LuckiestGuy 
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- FUNÇÃO DA CONVERSA ANTIGA (BUSCA NO INVENTÁRIO E ATIVA)
local function AutoFlashAction()
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    -- Lógica solicitada: Procura o item no inventário
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    -- Se não achar pelo nome exato, tenta achar por qualquer um que tenha "flash"
    if not tool then
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.Name:lower():find("flash") then
                tool = v
                break
            end
        end
    end

    if tool and hum then
        hum:UnequipTools() -- Solta o Brainrot
        task.wait(0.03)
        tool.Parent = char -- Pega o Flash
        task.wait(0.02)
        tool:Activate() -- Usa o Flash
        
        -- Impulso para garantir a saída
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
        end
    end
end

-- DETECTA QUANDO VOCÊ PEGA O BRAINROT (IGUAL AO VÍDEO)
player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.05) -- Delay curto para o item registrar na mão
        AutoFlashAction()
    end
end)

-- CRIADOR DE BOTÕES ESTILO KANYEHUB
local function CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.LuckiestGuy
    btn.TextSize = 16
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

-- BOTÕES
CreateButton("FLASH TP", 60, function(v) FlashAtivado = v end)
CreateButton("GIANT POTION", 115, function(v) end)
CreateButton("ALIGN", 170, function(v) end)

-- DISCORD TAG
local Footer = Instance.new("TextLabel", Main)
Footer.Text = "DISCORD.GG/KANYEHUB"
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.TextColor3 = Color3.new(1, 1, 1)
Footer.Font = Enum.Font.LuckiestGuy
Footer.TextSize = 14
Footer.BackgroundTransparency = 1

-- TECLA P PARA TOGGLE
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
