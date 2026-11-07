-- dwindle-tiling settings. Edit, then run `hyprctl reload`. (`ryoku-mods reapply` alone does not reload the compositor.)
return {
    max_tiled   = 4,    -- tiled windows per workspace before the next one moves on
    per_desktop = 10,   -- workspace ids per desktop (matches scripts/ryoku-workspace)
    follow      = true, -- focus the workspace the window moved to
}
