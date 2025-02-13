vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Copy Neovim's unnamed clipboard (i.e., the "* register) to the system clipboard
local function copy_to_clipboard()
  -- Get the current contents of Neovim's unnamed clipboard (the "* register)
  local clipboard_content = vim.fn.getreg '*'

  -- Check if clipboard content is not empty
  if clipboard_content ~= '' then
    -- Use xclip to copy the content to the system clipboard
    vim.fn.system({ 'xclip', '-selection', 'clipboard' }, clipboard_content)
    print 'Copied to system clipboard'
  else
    print 'Clipboard is empty'
  end
end

-- Map the function to a keybinding for convenience (optional)
vim.api.nvim_set_keymap('n', '<leader>y', [[:lua copy_to_clipboard()<CR>]], { noremap = true, silent = true })

-- Yanking from kickstart, find in file
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Its alno possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

return {}
