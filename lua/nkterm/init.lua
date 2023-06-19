local terminal = require("nkterm.terminal")

-- creates an object for the module. all of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

function hello()
    --print('hello')
    terminal.toggle() 
end

function M.setup(opts)
    --vim.api.nvim_create_user_command("NkTermToggle", terminal.toggle)
    vim.api.nvim_create_user_command("NkTermToggle", hello, {})
end

-- vim.api.nvim_create_user_command(
--     "NkTermToggle", 
--     function(opts)
--         M.deleteprints(opts)
--     end, {
--         range = true,
--         desc = "Delete all debugprint statements in the current buffer.",
--     }
-- )

return M
