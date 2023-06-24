local terminal = {}

terminal.term_buf_id = nil
terminal.term_win_h = nil

-- configure the current window for the terminal buffer
function configure()
    if terminal.term_buf_id ~= nil then
        local win_id = vim.api.nvim_get_current_win()

        vim.api.nvim_win_set_buf(win_id, terminal.term_buf_id)

        -- move window to the bottom 
        vim.cmd('wincmd J') 

        -- calculate the desired height for the terminal window
        terminal.term_win_h = 10 --math.floor(math.max(win_h / 3, 8))
        vim.cmd.resize(terminal.term_win_h)

        -- autocmd to keep the same height after resize
        vim.api.nvim_create_autocmd({'WinResized'}, {
            callback = function(ev)
                local curr_win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(win_id) 
                vim.cmd.resize(terminal.term_win_h)
                vim.api.nvim_set_current_win(curr_win) 
            end
        })

        -- additional options
        --vim.api.nvim_win_set_option(win_id, 'number', false) -- hide line nums
        --vim.cmd('startinsert') -- insert mode
    end
end

function get_term_win_id()
    local wins = vim.api.nvim_list_wins()
    local wins_count = table.getn(wins)

    for w = 1, wins_count do
        if vim.api.nvim_win_get_buf(wins[w]) == terminal.term_buf_id then 
            --vim.api.nvim_win_close(wins[w], true)
            return wins[w]
        end
    end

    return nil
end

function terminal.fix_layout()
    local win_id = vim.api.nvim_get_current_win()
    local buf_id = vim.api.nvim_get_current_buf()

    local bufs = vim.api.nvim_list_bufs()
    local bufs_count = table.getn(bufs)

    local wins = vim.api.nvim_list_wins()
    local wins_count = table.getn(wins)

    -- check if the terminal is open
    local term_win_id = get_term_win_id()
    if term_win_id ~= nil then

        -- check if the only remaining buffer is the terminal
        if bufs_count == 2 then
            vim.api.nvim_win_close(get_term_win_id(), true)
        elseif bufs_count > 2 then

            vim.cmd.split()
            local new_win_id = vim.api.nvim_get_current_win()      

            for b = 1, table.getn(bufs) do
                if bufs[b] ~= terminal.term_buf_id and bufs[b] ~= vim.api.nvim_win_get_buf(win_id) then
                    vim.api.nvim_win_set_buf(new_win_id, bufs[b])
                    
                    break
                end
            end

            -- close the original buf
            vim.api.nvim_buf_delete(buf_id, { force = true })

            -- open the terminal
            --vim.cmd.split()
            --local new_term_win_id = vim.api.nvim_get_current_win()
            --vim.api.nvim_win_set_buf(new_term_win_id, terminal.term_buf_id)
            --configure()
            vim.api.nvim_set_current_win(term_win_id)
            configure()
        end
    end
end

function terminal.toggle()

    -- check if terminal is already open (in a hidden buffer)
    if terminal.term_buf_id == nil or not vim.api.nvim_buf_is_valid(terminal.term_buf_id) then
        vim.cmd.split('term://$SHELL')
        terminal.term_buf_id = vim.api.nvim_get_current_buf()

        configure()
    else
        local wins = vim.api.nvim_list_wins()
        local wins_count = table.getn(wins)

        -- check every open window to see if we can find the terminal buffer
        local term_win_id = get_term_win_id()
        if term_win_id ~= nil then
            vim.api.nvim_win_close(term_win_id, true)
        else
            -- the terminal isn't open, create a window for it
            vim.cmd.split()
            configure()
        end
    end
end

return terminal
