local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local SIZE = 6
local modified, highlights = {}, {}

local function processNPC(model)
    if not model:IsA("Model") or Players:GetPlayerFromCharacter(model) then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local head = model:FindFirstChild("Head") or model:FindFirstChild("HeadHitbox")
    if not humanoid or not head or not head:IsA("BasePart") then return end

    if not modified[head] then
        modified[head] = true
        head.Size = head.Size * SIZE
    end

    if not highlights[model] then
        local h = Instance.new("Highlight")
        h.Name = "NPCRainbow"
        h.FillTransparency = 1
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = model
        highlights[model] = h
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("Model") then processNPC(obj) end
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") then
        task.wait(0.2)
        processNPC(obj)
    end
end)

task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.01) % 1
        for model, h in pairs(highlights) do
            if model.Parent and h.Parent then
                h.OutlineColor = Color3.fromHSV(hue, 1, 1)
            end
        end
        task.wait(0.05)
    end
end)
