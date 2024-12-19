vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


-- Copy Neovim's unnamed clipboard (i.e., the "* register) to the system clipboard
local function copy_to_clipboard()
  -- Get the current contents of Neovim's unnamed clipboard (the "* register)
  local clipboard_content = vim.fn.getreg('*')
  
  -- Check if clipboard content is not empty
  if clipboard_content ~= "" then
    -- Use xclip to copy the content to the system clipboard
    vim.fn.system({'xclip', '-selection', 'clipboard'}, clipboard_content)
    print("Copied to system clipboard")
  else
    print("Clipboard is empty")
  end
end

-- Map the function to a keybinding for convenience (optional)
vim.api.nvim_set_keymap('n', '<leader>y', [[:lua copy_to_clipboard()<CR>]], { noremap = true, silent = true })

