local awful = require("awful")
local naughty = require("naughty")

local hk = {}

function is_idea(c)
    return awful.rules.match(c, {class = "jetbrains-idea-ce"})
end
    
function move_idea(target)
    local idea = awful.client.cycle(is_idea)()
    awful.client.movetotag(target, idea)
end

function make_idea_master()
    local idea = awful.client.cycle(is_idea)()
    idea:swap(awful.client.getmaster())
end


function hk.init(args)
    keys = awful.util.table.join(root.keys(),
    awful.key({ args.modkey, }, "d", function()
        move_idea(args.altdevtag)
        awful.tag.viewonly(args.testtag)
        awful.tag.viewonly(args.altdevtag)
    end),
    awful.key({ args.modkey, "Shift" }, "d", function()
        awful.tag.viewonly(args.altdevtag)
        move_idea(args.devtag)
        awful.tag.viewonly(args.devtag)
        make_idea_master()
    end))
    root.keys(keys)
end

return hk
