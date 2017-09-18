--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d43869801eb69b541ba0e6ff950732a9:1c3e021f18386ad91ef2e36bdf63cc35:d4bb029ab46746e1738fabbd3ab6937b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- atirar
            x=406,
            y=1027,
            width=166,
            height=166,

            sourceX = 17,
            sourceY = 16,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- atirar2
            x=539,
            y=1195,
            width=166,
            height=166,

            sourceX = 17,
            sourceY = 16,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- button1
            x=574,
            y=1027,
            width=166,
            height=166,

            sourceX = 17,
            sourceY = 16,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- button2
            x=707,
            y=1195,
            width=166,
            height=166,

            sourceX = 17,
            sourceY = 16,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- cannon
            x=259,
            y=1027,
            width=145,
            height=170,

        },
        {
            -- cannonball
            x=1,
            y=1027,
            width=256,
            height=256,

            sourceX = 12,
            sourceY = 14,
            sourceWidth = 276,
            sourceHeight = 278
        },
        {
            -- castleday
            x=1,
            y=1,
            width=1024,
            height=1024,

        },
        {
            -- creature orange
            x=259,
            y=1199,
            width=138,
            height=162,

            sourceX = 36,
            sourceY = 1,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- creature purple
            x=399,
            y=1199,
            width=138,
            height=162,

            sourceX = 36,
            sourceY = 1,
            sourceWidth = 200,
            sourceHeight = 200
        },
        {
            -- creaturey
            x=742,
            y=1027,
            width=138,
            height=162,

            sourceX = 36,
            sourceY = 1,
            sourceWidth = 200,
            sourceHeight = 200
        },
    },
    
    sheetContentWidth = 1026,
    sheetContentHeight = 1362
}

SheetInfo.frameIndex =
{

    ["atirar"] = 1,
    ["atirar2"] = 2,
    ["button1"] = 3,
    ["button2"] = 4,
    ["cannon"] = 5,
    ["cannonball"] = 6,
    ["castleday"] = 7,
    ["creature orange"] = 8,
    ["creature purple"] = 9,
    ["creaturey"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
