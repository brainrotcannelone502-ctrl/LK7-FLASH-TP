local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KanyeHub_Official_V31"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (ESTILO image_97ad99.png)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 280, 0, 330)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Fundo escuro da imagem
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 15)

-- CABEÇALHO
local Title = Instance.new("TextLabel", Main)
Title.Text = "KANYEHUB FLASH TP"
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.LuckiestGuy 
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Icon = Instance.new("TextLabel", Main)
Icon.Text = "▼"
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(1, -50, 0, 5)
Icon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Icon.TextColor3 = Color3.new(1, 1, 1)
Icon.TextSize = 14
Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 8)

-- LÓGICA DE BUSCA E ACIONAMENTO (RECUPERADA DA CONVERSA ESTÁVEL)
local function AcionarFlashTP()
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- Busca o item "flash teleport" em qualquer lugar do inventário
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    if not tool then
        -- Se não achar pelo nome exato, busca qualquer item com "flash"
        for _, item in pairs(player.Backpack:GetChildren()) do
            if item.Name:lower():find("flash") then
                tool = item
                break
            end
        end
    end

    if tool and hum and hrp then
        hum:UnequipTools() -- Solta o Brainrot imediatamente
        task.wait(0.02)
        tool.Parent = char -- Equipa o Flash
        task.wait(0.02)
        tool:Activate() -- Aciona o Teleporte
        
        -- Impulso de saída (Visto no vídeo XRecorder)
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
    end
end

-- DETECTOR DE ROUBO
player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.02)
        AcionarFlashTP()
    end
end)

-- CRIADOR DE BOTÕES (DESIGN image_97ad99.png)
local function CreateKanyeButton(name, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.LuckiestGuy
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

-- ADICIONANDO BOTÕES
CreateKanyeButton("FLASH TP", 60, function(v) FlashAtivado = v end)
CreateKanyeButton("GIANT POTION", 120, function(v) end)
CreateKanyeButton("ALIGN", 180, function(v) end)

-- SEÇÃO TIMING
local TimingFrame = Instance.new("Frame", Main)
TimingFrame.Size = UDim2.new(0.9, 0, 0, 40)
TimingFrame.Position = UDim2.new(0.05, 0, 0, 240)
TimingFrame.BackgroundTransparency = 1

local TimingLabel = Instance.new("TextLabel", TimingFrame)
TimingLabel.Text = "TIMING:"
TimingLabel.Size = UDim2.new(0.5, 0, 1, 0)
TimingLabel.TextColor3 = Color3.new(1, 1, 1)
TimingLabel.Font = Enum.Font.LuckiestGuy
TimingLabel.TextSize = 18
TimingLabel.TextXAlignment = Enum.TextXAlignment.Left
TimingLabel.BackgroundTransparency = 1

local Percent = Instance.new("TextLabel", TimingFrame)
Percent.Text = "91%"
Percent.Size = UDim2.new(0.4, 0, 1, 0)
Percent.Position = UDim2.new(0.6, 0, 0, 0)
Percent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Percent.TextColor3 = Color3.new(1, 1, 1)
Percent.Font = Enum.Font.LuckiestGuy
Percent.TextSize = 18
Instance.new("UICorner", Percent).CornerRadius = UDim.new(0, 8)

-- DISCORD TAG
local Discord = Instance.new("TextLabel", Main)
Discord.Text = "DISCORD.GG/KANYEHUB"
Discord.Size = UDim2.new(1, 0, 0, 40)
Discord.Position = UDim2.new(0, 0, 1, -40)
Discord.TextColor3 = Color3.new(1, 1, 1)
Discord.Font = Enum.Font.LuckiestGuy
Discord.TextSize = 16
Discord.BackgroundTransparency = 1

-- TOGGLE MENU (TECLA P)
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
