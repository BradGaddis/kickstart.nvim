return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see below for full list of optional dependencies 👇
  },
  opts = {

    legacy_commands = false,
    workspaces = {
      -- {
      --   name = 'personal',
      --   path = '~/vaults/personal',
      -- },
      {
        name = 'Personal',
        path = '~/Documents/MindGarden/',
      },
    },
  },
  mappings = {
    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    ['gf'] = {
      action = function() return require('obsidian').util.gf_passthrough() end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes.
    -- ['<leader>ch'] = {
    --   action = function() return require('obsidian').util.toggle_checkbox() end,
    --   opts = { buffer = true },
    -- },
    -- Smart action depending on context, either follow link or toggle checkbox.
    ['<cr>'] = {
      action = function() return require('obsidian').util.smart_action() end,
      opts = { buffer = true, expr = true },
    },
  },
  ---@param url string
  follow_url_func = function(url)
    -- Open the URL in the default web browser.
    -- vim.fn.jobstart { 'open', url } -- Mac OS
    vim.fn.jobstart { 'xdg-open', url } -- linux
    -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    -- vim.ui.open(url) -- need Neovim 0.10.0+
  end,
  -- picker = {
  --     -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
  --     name = "telescope.nvim",
  --     -- Optional, configure key mappings for the picker. These are the defaults.
  --     -- Not all pickers support all mappings.
  --     note_mappings = {
  --       -- Create a new note from your query.
  --       new = "<C-x>",
  --       -- Insert a link to the selected note.
  --       insert_link = "<C-l>",
  --     },
  --     tag_mappings = {
  --       -- Add tag(s) to current note.
  --       tag_note = "<C-x>",
  --       -- Insert a tag at the current location.
  --       insert_tag = "<C-l>",
  --     },
}
