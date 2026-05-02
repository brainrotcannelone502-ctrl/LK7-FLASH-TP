local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KanyeHub_Flash_TP"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (ESTILO KANYEHUB)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
Title.Font = Enum.Font.LuckiestGuy -- Fonte parecida com a da imagem
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- FUNÇÃO DE TELEPORTE (BUSCA AUTOMÁTICA)
local function UsarFlashTP()
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    -- Busca o item exato "flash teleport" no inventário ou na mão
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    if tool and hum then
        hum:UnequipTools() -- Garante que a mão esteja livre
        task.wait(0.05)
        tool.Parent = char
        task.wait(0.05)
        tool:Activate()
        
        -- Pequeno impulso para frente
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 10)
        end
    end
end

-- LÓGICA DE AUTO-STEAL (VIDEO)
player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.1)
        UsarFlashTP()
    end
end)

-- CRIADOR DE BOTÕES (ESTILO ARREDONDADO CINZA)
local function CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.LuckiestGuy
    btn.TextSize = 16
    btn.AutoButtonColor = true
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

-- ADICIONANDO BOTÕES IGUAL À IMAGEM
CreateButton("FLASH TP", 60, function(v) FlashAtivado = v end)
CreateButton("GIANT POTION", 115, function(v) end)
CreateButton("ALIGN", 170, function(v) end)

-- RODAPÉ (DISCORD)
local Footer = Instance.new("TextLabel", Main)
Footer.Text = "DISCORD.GG/KANYEHUB"
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.TextColor3 = Color3.new(1, 1, 1)
Footer.Font = Enum.Font.LuckiestGuy
Footer.TextSize = 14
Footer.BackgroundTransparency = 1

-- TECLA P PARA SUMIR
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
