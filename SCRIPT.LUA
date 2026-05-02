local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "FlashTP_Original_Recovery"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (ESTILO RETRÔ - GARANTE QUE APAREÇA)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 250, 0, 200)
Main.Position = UDim2.new(0.5, -125, 0.4, 0)
Main.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- Cinza sólido
Main.BorderSizePixel = 4
Main.BorderColor3 = Color3.new(1, 0, 0) -- Borda vermelha grossa
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "FLASH TP - RECUPERADO"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.new(0.6, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- LÓGICA DE BUSCA DO ITEM (CONVERSA ANTERIOR)
local function UsarFlashNoInventario()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    -- Busca automática pelo nome "flash teleport"
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    -- Se não achar o nome exato, procura qualquer um que tenha "flash"
    if not tool then
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.Name:lower():find("flash") then
                tool = v
                break
            end
        end
    end

    if tool and hum then
        hum:UnequipTools() -- Solta o item de roubo
        task.wait(0.05)
        tool.Parent = char -- Puxa o flash
        task.wait(0.05)
        tool:Activate() -- Aciona
        
        -- Impulso para sair da base
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
        end
    end
end

-- DETECTA O MOMENTO DO ROUBO
player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.05)
        UsarFlashNoInventario()
    end
end)

-- CRIANDO OS BOTÕES SEM ESTILO KANYEHUB (MÉTODO TRADICIONAL)
local function CreateSimpleButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = text .. ": OFF"
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.new(0, 0.5, 0) or Color3.new(0.3, 0.3, 0.3)
        callback(state)
    end)
end

-- ADICIONANDO BOTÕES EM POSIÇÕES FIXAS (EVITA ERRO DE LAYOUT)
CreateSimpleButton("AUTO FLASH TP", 50, function(v) FlashAtivado = v end)
CreateSimpleButton("FLASH AGORA", 100, function() UsarFlashNoInventario() end)

-- INSTRUÇÃO DE USO
local info = Instance.new("TextLabel", Main)
info.Text = "TECLA 'P' PARA FECHAR"
info.Size = UDim2.new(1, 0, 0, 30)
info.Position = UDim2.new(0, 0, 1, -30)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1, 1, 1)
info.TextSize = 12

game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
