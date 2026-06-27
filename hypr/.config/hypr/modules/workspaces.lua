------------------
--- WORKSPACES ---
------------------
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

hl.workspace_rule({workspace = "5", on_created_empty = "spotify-launcher"})

-- Define modifiers
local mainMod = "SUPER"
local ctrl = "CTRL"
local alt = "ALT"
local shift = "SHIFT"

-- Global rule to ensure they are centered and floating when they exist there
hl.window_rule({
    match = { workspace = "special:*" },
    float = true,
    center = true,
})

-- Loop to generate binds for special workspaces 1 through 9
for i = 1, 9 do
    local key = tostring(i)
    local workspaceName = "special:" .. key

    -- Toggle view of special workspace i (SUPER + CTRL + Key)
    hl.bind(
        mainMod .. " + " .. ctrl .. " + " .. key, 
        hl.dsp.workspace.toggle_special(key)
    )

    -- Move active window AND force resize instantly (SUPER + CTRL + SHIFT + Key)
    hl.bind(
        mainMod .. " + " .. ctrl .. " + " .. shift .. " + " .. key, 
        function()
            -- 1. Move the window to the target scratchpad
            hl.dispatch(hl.dsp.window.move({ workspace = workspaceName }))
            
            -- 2. Explicitly force floating state and structural dimensions 
            -- to bypass background layout caching quirks.
            hl.dispatch(hl.dsp.window.float({ action = "enable" }))
            hl.dispatch(hl.dsp.window.resize({ x = 1200, y = 1000, relative = false }))
            hl.dispatch(hl.dsp.window.center())
        end
    )
end
