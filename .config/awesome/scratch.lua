local client = client
local awful = require("awful")
local util = require("awful.util")

local scratch = {}
local defaultRule = { instance = "scratch" }

local function turn_on(c)
    local current_tag = awful.tag.selected(c.screen)
    ctags = {current_tag}
    for k,tag in pairs(c:tags()) do
        if tag ~= current_tag then
            table.insert(ctags, tag)
        end
    end
    c:tags(ctags)
    c:raise()
    client.focus = c
end

local function turn_off(c)
    local current_tag = awful.tag.selected(c.screen)
    local ctags = {}
    for k,tag in pairs(c:tags()) do
        if tag ~= current_tag then
            table.insert(ctags, tag)
        end
    end
    c:tags(ctags)
end

function scratch.raise(cmd, rule)
    local rule = rule or defaultRule
    local function matcher(c) return awful.rules.match(c, rule) end

    local clients = client.get()
    local findex  = util.table.hasitem(clients, client.focus) or 1
    local start   = util.cycle(#clients, findex + 1)

    for c in awful.client.cycle(matcher, start) do
        turn_on(c)
        return
    end

    -- client not found, spawn it
    util.spawn(cmd)
end

function scratch.toggle(cmd, rule, alwaysclose)
    local rule = rule or defaultRule

    if client.focus and awful.rules.match(client.focus, rule) then
        turn_off(client.focus)
    else
        scratch.raise(cmd, rule)
    end
end

return scratch
