local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KanyeHub_V33_UltraSafe"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (ESTILO image_97ad99.png)
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = sg
Main.Size = UDim2.new(0, 280, 0, 330)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ZIndex = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- TÍTULO
local Title = Instance.new("TextLabel", Main)
Title.Text = "KANYEHUB FLASH TP"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.ZIndex = 5

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

-- FUNÇÃO DE CRIAR BOTÕES (MÉTODO DE INJEÇÃO DIRETA)
local function CreateKanyeButton(name, yPos, callback)
    -- Criamos fora e depois jogamos dentro para forçar a aparição
    local btn = Instance.new("TextButton")
    btn.Parent = Main
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.ZIndex = 10
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(55, 55, 55)
        callback(state)
    end)
end

-- GERANDO ELEMENTOS COM INTERVALO (PARA NÃO TRAVAR A RENDERIZAÇÃO)
task.spawn(function()
    task.wait(0.2)
    CreateKanyeButton("FLASH TP", 60, function(v) FlashAtivado = v end)
    task.wait(0.1)
    CreateKanyeButton("GIANT POTION", 120, function(v) end)
    task.wait(0.1)
    CreateKanyeButton("ALIGN", 180, function(v) end)
end)

-- DISCORD (RODAPÉ)
local Discord = Instance.new("TextLabel", Main)
Discord.Text = "DISCORD.GG/KANYEHUB"
Discord.Size = UDim2.new(1, 0, 0, 40)
Discord.Position = UDim2.new(0, 0, 1, -40)
Discord.TextColor3 = Color3.new(1, 1, 1)
Discord.Font = Enum.Font.SourceSans
Discord.BackgroundTransparency = 1
Discord.ZIndex = 5

-- TECLA P PARA SUMIR
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
