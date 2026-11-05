-- Roblox Studio: coloca este Script en ServerScriptService.
-- Resalta NPCs con contorno RGB sin modificar sus partes ni animaciones.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local highlights = {}

local function addNPC(model)
    if not model:IsA("Model") then return end
    if Players:GetPlayerFromCharacter(model) then return end
    if not model:FindFirstChildOfClass("Humanoid") then return end
    if highlights[model] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NPCRainbow"
    highlight.Adornee = model
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model

    highlights[model] = highlight

    model.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if highlights[model] then
                highlights[model]:Destroy()
                highlights[model] = nil
            end
        end
    end)
end

for _, object in ipairs(Workspace:GetDescendants()) do
    if object:IsA("Model") then
        addNPC(object)
    end
end

Workspace.DescendantAdded:Connect(function(object)
    if object:IsA("Model") then
        task.wait(0.2)
        addNPC(object)
    end
end)

task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.01) % 1
        local color = Color3.fromHSV(hue, 1, 1)

        for model, highlight in pairs(highlights) do
            if model.Parent and highlight.Parent then
                highlight.OutlineColor = color
            end
        end

        task.wait(0.05)
    end
end)
