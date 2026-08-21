# this took me (mamzhoe) around 5 hours!
_
local TweenService = game:GetService("TweenService")
local part = script.Parent

local originalY = part.Position.Y
local originalSize = part.Size

local jumpHeight = 5
local anticipationTime = 0.12   -- quick crouch before jumping
local launchTime = 0.28         -- fast rise, decelerating near the top
local fallTime = 0.32           -- falling is faster than rising (gravity)
local landTime = 0.08           -- quick compression on landing
local recoverTime = 0.12        -- settle back to normal
local pauseBetweenJumps = 0.4

local function setY(y)
    part.Position = Vector3.new(part.Position.X, y, part.Position.Z)
end

local function jumpOnce()
    -- 1. Anticipation: slight crouch down + squash before launching
    local crouch = TweenService:Create(part,
        TweenInfo.new(anticipationTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(originalSize.X * 1.15, originalSize.Y * 0.8, originalSize.Z * 1.15)}
    )
    crouch:Play()
    crouch.Completed:Wait()

    -- 2. Launch: fast off the ground, decelerating as it reaches the peak (like real gravity)
    local riseTween = TweenService:Create(part,
        TweenInfo.new(launchTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = Vector3.new(part.Position.X, originalY + jumpHeight, part.Position.Z)}
    )
    local stretchUp = TweenService:Create(part,
        TweenInfo.new(launchTime * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize}
    )
    riseTween:Play()
    stretchUp:Play()
    riseTween.Completed:Wait()

    -- 3. Fall: accelerating down (gravity feels stronger on the way down)
    local fallTween = TweenService:Create(part,
        TweenInfo.new(fallTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = Vector3.new(part.Position.X, originalY, part.Position.Z)}
    )
    fallTween:Play()
    fallTween.Completed:Wait()

    -- 4. Landing: squash on impact
    local squash = TweenService:Create(part,
        TweenInfo.new(landTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(originalSize.X * 1.2, originalSize.Y * 0.75, originalSize.Z * 1.2)}
    )
    squash:Play()
    squash.Completed:Wait()

    -- 5. Recover: back to normal size
    local recover = TweenService:Create(part,
        TweenInfo.new(recoverTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = originalSize}
    )
    recover:Play()
    recover.Completed:Wait()
end

while true do
    jumpOnce()
    task.wait(pauseBetweenJumps)
end
