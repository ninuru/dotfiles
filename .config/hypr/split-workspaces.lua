package.path = package.path .. ";/home/schreider/IdeaProjects/split-monitor-workspaces/lua/?.lua"
local smw = require("split-monitor-workspaces")

smw.setup({
    workspace_count = 10,
    monitor_priority = { "eDP-1", "DP-8", "DP-10" },
    keep_focused = true,
    enable_persistent_workspaces = true,
})

local mainMod = "SUPER"
for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end
    hl.bind(mainMod .. " +" .. n, smw.workspace(n))
    hl.bind(mainMod .. " + SHIFT +" .. n, smw.move_to_workspace(n))
end

hl.bind(mainMod .. " + mouse_down", smw.cycle_workspaces("next"))
hl.bind(mainMod .. " + mouse_up", smw.cycle_workspaces("prev"))
