local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lplr = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedPanelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = lplr:WaitForChild("PlayerGui")

-- Create Toggle Icon Button
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Image = "rbxassetid://6031091002"
toggleButton.BackgroundTransparency = 1
toggleButton.Parent = screenGui

-- Create Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 350)
panel.Position = UDim2.new(0.5, -150, 0.5, -175)
panel.BackgroundColor3 = Color3.new(0, 0, 0)
panel.BackgroundTransparency = 0.3
panel.BorderSizePixel = 0
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Visible = false
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Speed Control"
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.Parent = panel

-- Speed label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -40, 0, 40)
speedLabel.Position = UDim2.new(0, 20, 0, 50)
speedLabel.Text = "Speed: 16"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = panel

-- Slider background
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(1, -40, 0, 10)
sliderBg.Position = UDim2.new(0, 20, 0, 110)
sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = panel

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBg

-- Slider knob
local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0, 20, 0, 105)
sliderKnob.BackgroundColor3 = Color3.fromRGB(30, 150, 250)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = panel

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

-- Speed logic
local dragging = false
local minSpeed = 16
local maxSpeed = 100

local function updateSpeed(posX)
    local sliderStart = sliderBg.AbsolutePosition.X
    local sliderEnd = sliderStart + sliderBg.AbsoluteSize.X

    local newX = math.clamp(posX, sliderStart, sliderEnd)
    local relative = (newX - sliderStart) / sliderBg.AbsoluteSize.X
    local speed = math.floor(minSpeed + relative * (maxSpeed - minSpeed))

    sliderKnob.Position = UDim2.new(0, newX - panel.AbsolutePosition.X - sliderKnob.Size.X.Offset/2, 0, 105)
    speedLabel.Text = "Speed: " .. tostring(speed)

    if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
        lplr.Character.Humanoid.WalkSpeed = speed
    end
end

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input.Position.X)
    end
end)

-- Toggle panel visibility
toggleButton.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Gear teleport toggle logic
local enableGearButton = Instance.new("TextButton")
enableGearButton.Size = UDim2.new(1, -40, 0, 40)
enableGearButton.Position = UDim2.new(0, 20, 0, 150)
enableGearButton.Text = "Enable Gear Teleport Button (OFF)"
enableGearButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
enableGearButton.TextColor3 = Color3.new(1,1,1)
enableGearButton.Font = Enum.Font.Gotham
enableGearButton.TextScaled = true
enableGearButton.Parent = panel

local gearButtonEnabled = false
local gearButton

enableGearButton.MouseButton1Click:Connect(function()
    gearButtonEnabled = not gearButtonEnabled
    enableGearButton.Text = gearButtonEnabled and "Enable Gear Teleport Button (ON)" or "Enable Gear Teleport Button (OFF)"

    if gearButtonEnabled then
        if not gearButton then
            gearButton = Instance.new("TextButton")
            gearButton.Size = UDim2.new(0, 80, 0, 40)

            local seedButton = screenGui:FindFirstChild("Seed") or screenGui:FindFirstChild("SeedButton")
            if seedButton and seedButton:IsA("GuiObject") then
                local sx, sxo = seedButton.Position.X.Scale, seedButton.Position.X.Offset
                local syo = seedButton.Position.Y.Offset
                local sw = seedButton.Size.X.Offset
                gearButton.Position = UDim2.new(sx, sxo + sw + 8, 0, syo)
            else
                gearButton.Position = UDim2.new(0, 200, 0, 10)
            end

            gearButton.AnchorPoint = Vector2.new(0, 0)
            gearButton.Text = "Gear"
            gearButton.BackgroundColor3 = Color3.fromRGB(30, 150, 250)
            gearButton.TextColor3 = Color3.new(1, 1, 1)
            gearButton.Font = Enum.Font.GothamBold
            gearButton.TextScaled = true
            gearButton.Parent = screenGui

            gearButton.MouseButton1Click:Connect(function()
                local gearShopPosition = Vector3.new(150, 4, -150)
                if lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(gearShopPosition)
                end
            end)
        else
            gearButton.Visible = true
        end
    else
        if gearButton then
            gearButton.Visible = false
        end
    end
end)

-- See Inside Egg Toggle Button
local seeInsideButton = Instance.new("TextButton")
seeInsideButton.Size = UDim2.new(1, -40, 0, 40)
seeInsideButton.Position = UDim2.new(0, 20, 0, 200)
seeInsideButton.Text = "See Inside Egg (OFF)"
seeInsideButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
seeInsideButton.TextColor3 = Color3.new(1,1,1)
seeInsideButton.Font = Enum.Font.Gotham
seeInsideButton.TextScaled = true
seeInsideButton.Parent = panel

local seeInsideEnabled = false

seeInsideButton.MouseButton1Click:Connect(function()
    seeInsideEnabled = not seeInsideEnabled
    seeInsideButton.Text = seeInsideEnabled and "See Inside Egg (ON)" or "See Inside Egg (OFF)"

    if seeInsideEnabled then
        local egg = workspace:FindFirstChild("Eggs") and workspace.Eggs:FindFirstChild("MyEgg")
        local petName
        if egg and egg:FindFirstChild("PetName") then
            petName = egg.PetName.Value
        else
            petName = "Unknown"
        end

        warn("[Grow a Garden] Inside Egg: " .. petName)

        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(0, 200, 0, 50)
        resultLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
        resultLabel.BackgroundColor3 = Color3.fromRGB(30, 150, 250)
        resultLabel.TextColor3 = Color3.new(1, 1, 1)
        resultLabel.Font = Enum.Font.GothamBold
        resultLabel.TextScaled = true
        resultLabel.Text = "Inside Egg:\n" .. petName
        resultLabel.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = resultLabel

        task.delay(3, function()
            resultLabel:Destroy()
        end)
    else
        warn("[Grow a Garden] See Inside Egg turned OFF")
    end
end)

-- Randomize Egg Button
local randomizeEggButton = Instance.new("TextButton")
randomizeEggButton.Size = UDim2.new(1, -40, 0, 40)
randomizeEggButton.Position = UDim2.new(0, 20, 0, 250)
randomizeEggButton.Text = "Randomize Egg"
randomizeEggButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
randomizeEggButton.TextColor3 = Color3.new(1,1,1)
randomizeEggButton.Font = Enum.Font.Gotham
randomizeEggButton.TextScaled = true
randomizeEggButton.Parent = panel

randomizeEggButton.MouseButton1Click:Connect(function()
    local possiblePets = {
        "Raccoon",
        "Dragonfly",
        "Mimic Octopus"
    }
    local chosenPet = possiblePets[math.random(1, #possiblePets)]

    local success = false
    local egg = workspace:FindFirstChild("Eggs") and workspace.Eggs:FindFirstChild("MyEgg")
    if egg and egg:FindFirstChild("PetName") and egg.PetName:IsA("StringValue") then
        egg.PetName.Value = chosenPet
        success = true
    end

    if success then
        warn("[Grow a Garden] Egg randomized! New pet is now set to: " .. chosenPet)
    else
        warn("[Grow a Garden] ERROR: Could not find egg object to randomize!")
    end

    local resultLabel = Instance.new("TextLabel")
    resultLabel.Size = UDim2.new(0, 200, 0, 50)
    resultLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
    resultLabel.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    resultLabel.TextColor3 = Color3.new(1, 1, 1)
    resultLabel.Font = Enum.Font.GothamBold
    resultLabel.TextScaled = true

    if success then
        resultLabel.Text = "Egg Randomized!\nPet: " .. chosenPet
    else
        resultLabel.Text = "Failed to randomize egg!"
    end

    resultLabel.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = resultLabel

    task.delay(3, function()
        resultLabel:Destroy()
    end)
end)