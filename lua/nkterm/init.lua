local terminal = require("nkterm.terminal")

local M = {}

function M.setup(opts)
    vim.api.nvim_create_user_command('NkTermToggle', terminal.toggle, {})

    -- if a sibling window is quitting fix the layout of the terminal
    vim.api.nvim_create_autocmd({'QuitPre'}, {
        callback = function(ev)
            if terminal.term_buf_id == nil or vim.api.nvim_get_current_buf() ~= terminal.term_buf_id then
                terminal.fix_layout()
            end
        end
    })
end

return M
