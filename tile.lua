-- dwindle-tiling: with the dwindle layout active, the tiled window past
-- cfg.max_tiled moves to the next workspace of the same desktop that has room.
-- Floating and pinned windows are not counted. When the desktop is full the
-- window stays where it opened.
local dir = (debug.getinfo(1, "S").source:match("^@(.*)/[^/]*$")) or "."
local ok, cfg = pcall(dofile, dir .. "/config.lua")
if not ok or type(cfg) ~= "table" then cfg = {} end
local MAX_TILED   = tonumber(cfg.max_tiled) or 4
local PER_DESKTOP = tonumber(cfg.per_desktop) or 10
local FOLLOW      = cfg.follow ~= false

hl.config({ dwindle = { preserve_split = true } })

local function tiled_count(ws_id, skip_address)
    local n = 0
    for _, w in ipairs(hl.get_windows()) do
        if w.address ~= skip_address and w.mapped ~= false and not w.floating and not w.pinned
            and w.workspace and w.workspace.id == ws_id then
            n = n + 1
        end
    end
    return n
end

hl.on("window.open", function(window)
    if not window or window.floating or window.pinned or not window.workspace then return end
    local ws = window.workspace.id
    if not ws or ws <= 0 or window.workspace.tiled_layout ~= "dwindle" then return end
    if tiled_count(ws, window.address) < MAX_TILED then return end
    local target = ws + 1
    while target % PER_DESKTOP ~= 1 and tiled_count(target, window.address) >= MAX_TILED do
        target = target + 1
    end
    if target % PER_DESKTOP == 1 then return end
    hl.dispatch(hl.dsp.window.move({ workspace = target, window = "address:" .. window.address }))
    if FOLLOW then hl.dispatch(hl.dsp.focus({ workspace = target })) end
end)
