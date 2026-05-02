local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "FlashTP_Recovered_V34"
sg.ResetOnSpawn = false

local FlashAtivado = false

-- JANELA PRINCIPAL (DESIGN SÓLIDO PARA EVITAR TELA PRETA)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 250, 0, 200)
Main.Position = UDim2.new(0.5, -125, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Cinza Escuro
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Borda Vermelha
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "AUTO FLASH TP - ESTÁVEL"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local UIList = Instance.new("UIListLayout", Main)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ESPAÇADOR PARA O TÍTULO
local Pad = Instance.new("Frame", Main)
Pad.Size = UDim2.new(1, 0, 0, 40)
Pad.BackgroundTransparency = 1

-- LÓGICA DE BUSCA E ACIONAMENTO (DA NOSSA CONVERSA ANTERIOR)
local function AcionarFlashTP()
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- BUSCA O ITEM PELO NOME NO INVENTÁRIO (BACKPACK) OU NA MÃO (CHAR)
    local tool = player.Backpack:FindFirstChild("flash teleport") or char:FindFirstChild("flash teleport")
    
    -- SE NÃO ACHAR PELO NOME EXATO, TENTA ACHAR POR QUALQUER UM COM "FLASH"
    if not tool then
        for _, item in pairs(player.Backpack:GetChildren()) do
            if item.Name:lower():find("flash") then
                tool = item
                break
            end
        end
    end

    if tool and hum and hrp then
        hum:UnequipTools() -- LIMPA A MÃO (SOLTA O BRAINROT)
        task.wait(0.05)
        tool.Parent = char -- EQUIPA O FLASH
        task.wait(0.05)
        tool:Activate() -- ACIONA O TELEPORTE
        
        -- IMPULSO DE FUGA
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
    end
end

-- DETECTA QUANDO VOCÊ PEGA O ITEM DE ROUBO
player.CharacterChildAdded:Connect(function(child)
    if FlashAtivado and child:IsA("Tool") and not child.Name:lower():find("flash") then
        task.wait(0.05)
        AcionarFlashTP()
    end
end)

-- FUNÇÃO DE CRIAR BOTÃO (DESIGN PADRÃO ROBUSTO)
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 65)
        callback(state)
    end)
end

-- BOTÕES DE FUNCIONAMENTO
CreateButton("FLASH TP AUTO", function(v) FlashAtivado = v end)

local Manual = Instance.new("TextButton", Main)
Manual.Size = UDim2.new(0.9, 0, 0, 45)
Manual.Text = "USAR FLASH MANUAL"
Manual.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
Manual.TextColor3 = Color3.new(1, 1, 1)
Manual.Font = Enum.Font.GothamBold
Manual.MouseButton1Click:Connect(AcionarFlashTP)

-- TECLA P PARA SUMIR
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
