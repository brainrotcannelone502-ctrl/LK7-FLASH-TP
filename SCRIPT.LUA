local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KanyeHub_V32_Forced"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (DESIGN KANYEHUB - image_97ad99.png)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 280, 0, 330)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BackgroundTransparency = 0.1 -- Transparência para evitar que fique tudo preto
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ZIndex = 1

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 15)

-- TÍTULO
local Title = Instance.new("TextLabel", Main)
Title.Text = "KANYEHUB FLASH TP"
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.LuckiestGuy 
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.ZIndex = 2

-- LÓGICA DE BUSCA DO ITEM (RECUPERADA)
local function UsarFlashTP()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    if not tool then
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.Name:lower():find("flash") then tool = v break end
        end
    end

    if tool and hum then
        hum:UnequipTools()
        task.wait(0.05)
        tool.Parent = char
        task.wait(0.05)
        tool:Activate()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15) end
    end
end

player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.05)
        UsarFlashTP()
    end
end)

-- FUNÇÃO DE CRIAR BOTÕES (FORÇADA)
local function CreateKanyeButton(name, yPos, callback)
    task.wait(0.1) -- Atraso para garantir que o Frame principal já exista
    local btn = Instance.new("TextButton", Main)
    btn.Name = "Btn_" .. name
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.LuckiestGuy
    btn.TextSize = 18
    btn.ZIndex = 10 -- FORÇA PARA A FRENTE DE TUDO
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- ADICIONANDO OS BOTÕES UM POR UM
CreateKanyeButton("FLASH TP", 60, function(v) FlashAtivado = v end)
CreateKanyeButton("GIANT POTION", 120, function(v) end)
CreateKanyeButton("ALIGN", 180, function(v) end)

-- DISCORD (RODAPÉ)
local Discord = Instance.new("TextLabel", Main)
Discord.Text = "DISCORD.GG/KANYEHUB"
Discord.Size = UDim2.new(1, 0, 0, 40)
Discord.Position = UDim2.new(0, 0, 1, -40)
Discord.TextColor3 = Color3.new(1, 1, 1)
Discord.Font = Enum.Font.LuckiestGuy
Discord.BackgroundTransparency = 1
Discord.ZIndex = 5

-- TECLA P PARA TOGGLE
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
