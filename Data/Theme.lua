local _, Q = ...

Q.Theme = {
    Background = {
        Primary   = {11/255, 13/255, 16/255, 1}, -- #0B0D10
        Secondary = {23/255, 24/255, 25/255, 1}, -- #171819
        Tertiary  = {39/255, 37/255, 34/255, 1}, -- #272522
    },

    Border = {
        Default = {83/255, 76/255, 61/255, 1}, -- #534C3D
        Accent  = {190/255, 143/255, 49/255, 1}, -- #BE8F31
    },

    Text = {
        Primary   = {239/255, 232/255, 211/255, 1}, -- #EFE8D3
        Secondary = {170/255, 163/255, 143/255, 1}, -- #AAA38F
        Accent    = {221/255, 171/255, 65/255, 1}, -- #DDAB41
        Disabled  = {96/255, 96/255, 91/255, 1}, -- #60605B
        Emphasized = {187/255, 79/255, 66/255, 1}, -- #BB4F42
        Success   = {99/255, 151/255, 69/255, 1}, -- #639745
    },

    Status = {
        Success = {99/255, 151/255, 69/255, 1}, -- #639745
        Warning = {213/255, 148/255, 40/255, 1}, -- #D59428
        Error   = {194/255, 68/255, 57/255, 1}, -- #C24439
        Info    = {66/255, 125/255, 158/255, 1}, -- #427D9E
    },
    DifficultyColors = {
        Red = { r = 163/255, g = 59/255, b = 57/255 },
        Orange = { r = 196/255, g = 120/255, b = 43/255 },
        Yellow = { r = 255/255, g = 239/255, b = 0/255 },
        Green = { r = 35/255, g = 213/255, b = 0/255 },
        Gray = { r = 146/255, g = 146/255, b = 146/255 },
    },
    Alpha = {
        ButtonBackground = 0.15,
        ButtonBackgroundHover = 0.45,
        ButtonBorder = 0.75,
        ButtonBorderHover = 1,
        Hover = 0.1,
        Pressed = 0.2,
    },
    Padding = {
        S  = 9,
        M = 18,
        L  = 27,
    },
    Font = {
        XS = 10,
        S  = 12,
        M = 14,
        L  = 16,
        XL = 18,
        XXL = 20,
        XXXL = 22,
    }
}
