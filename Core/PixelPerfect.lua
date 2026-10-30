local ADDON_NAME, Q = ...

Q.PixelPerfect = {}

local PP = Q.PixelPerfect

local function GetPixelsPerUnit(frame)
    frame = frame or UIParent

    local screenHeight = select(2, GetPhysicalScreenSize())

    return frame:GetEffectiveScale() * screenHeight / 768
end

-- Convert physical pixels into UI units.
function PP:Pixel(value, frame)
    return value / GetPixelsPerUnit(frame)
end

-- Convert UI units into physical pixels.
function PP:ToPhysical(value, frame)
    return value * GetPixelsPerUnit(frame)
end

-- Snap a local coordinate to the nearest physical pixel.
function PP:Snap(value, frame)
    local pixelsPerUnit = GetPixelsPerUnit(frame)

    return math.floor(value * pixelsPerUnit + 0.5) / pixelsPerUnit
end

-- Calculate physical dimensions of a frame.
function PP:GetPhysicalSize(frame)
    local scale = GetPixelsPerUnit(frame)

    return
        frame:GetWidth() * scale,
        frame:GetHeight() * scale
end

local function GetPixelsPerUnit(frame)
    local _, screenHeight = GetPhysicalScreenSize()

    return frame:GetEffectiveScale() * screenHeight / 768
end

local function GetPixelSize(frame, pixels)
    return pixels / GetPixelsPerUnit(frame)
end

local function SnapToPixel(frame, value)
    local pixelsPerUnit = GetPixelsPerUnit(frame)
    return math.floor((value * pixelsPerUnit) + 0.5) / pixelsPerUnit
end