local terminal = {}

function layout(win_id, win_h)
    vim.cmd('wincmd J')
    vim.cmd.resize(math.floor(win_h))
    vim.api.nvim_win_set_option(win_id, 'number', false) -- hide line nums
    vim.cmd('startinsert') -- insert mode
end

-- run this when the terminal is entered through an autocmd
function enter()
    local term_win_id = vim.api.nvim_get_current_win()
end

function terminal.toggle()

    -- calculate the desired height for the terminal window
    local win_id = vim.api.nvim_get_current_win()
    local win_h = vim.api.nvim_win_get_height(win_id)
    local term_win_h = math.max(win_h / 3, 8)

    -- check if terminal is already open (in a hidden buffer)
    if term_buf_id == nil or vim.api.nvim_buf_is_valid(term_buf_id) then
        vim.cmd.split('term://$SHELL')

        -- store id for later
        term_buf_id = vim.api.nvim_get_current_buf()
        term_win_id = vim.api.nvim_get_current_win()

        layout(term_win_id, term_win_h)

    -- check if the buffer is hidden
    elseif not vim.api.nvim_win_is_valid(term_win_id) then
        -- create a new window to place our existing terminal buffer into
        vim.cmd.split()

        -- move terminal buffer to the new window
        term_win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(term_win_id, term_buf_id)

        term_layout(term_win_id, term_win_h)

    -- terminal is still open
    elseif vim.api.nvim_win_get_buf(term_win_id) == term_buf_id then
        vim.api.nvim_win_close(term_win_id, true)
    
    -- terminal has been lost, must create a new one
    else
        print('lost term!')
    end
end

return terminal
