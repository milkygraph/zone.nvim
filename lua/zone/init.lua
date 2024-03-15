local zone = {}
local timer

local default_opts = require("zone.config")

zone.setup = function(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local grp = vim.api.nvim_create_augroup('Zone', {clear=true})
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = grp,
        callback = function()
            if vim.g.zone then
                vim.notify("[zone.nvim]: Zone is already running!")
                return
            end
            if vim.tbl_contains(opts.exclude_filetypes, vim.bo.ft) then return end
            if vim.tbl_contains(opts.exclude_buftypes, vim.bo.bt) then return end

            timer = vim.loop.new_timer()
            vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                group = grp,
                callback = function()
                    if timer:is_active() then timer:stop() end
                    if not timer:is_closing() then timer:close() end
                    vim.g.zone = false
                end,
                once = true
            })
        end,
    })
end

return zone
