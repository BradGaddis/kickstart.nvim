local vault_path = '~/Documents/Vaults/'
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  keys = {
    { '<leader>oo', '<cmd>Obsidian open<CR>', desc = 'Obsidian: [O]pen note in app' },
    { '<leader>on', '<cmd>Obsidian new<CR>', desc = 'Obsidian: [N]ew note' },
    { '<leader>os', '<cmd>Obsidian search<CR>', desc = 'Obsidian: [S]earch notes' },
    { '<leader>ob', '<cmd>Obsidian backlinks<CR>', desc = 'Obsidian: [B]acklinks' },
    { '<leader>ot', '<cmd>Obsidian tags<CR>', desc = 'Obsidian: [T]ags' },
    { '<leader>oT', '<cmd>Obsidian toc<CR>', desc = 'Obsidian: Table of [C]ontents' },
    { '<leader>ol', '<cmd>Obsidian links<CR>', desc = 'Obsidian: [L]inks in note' },
    { '<leader>of', '<cmd>Obsidian follow_link<CR>', desc = 'Obsidian: [F]ollow link' },
    { '<leader>or', '<cmd>Obsidian rename<CR>', desc = 'Obsidian: [R]ename note' },
    { '<leader>op', '<cmd>Obsidian paste_img<CR>', desc = 'Obsidian: [P]aste image' },
    { '<leader>od', '<cmd>Obsidian today<CR>', desc = 'Obsidian: [T]oday note' },
    { '<leader>oD', '<cmd>Obsidian dailies<CR>', desc = 'Obsidian: [D]aily notes' },
    { '<leader>om', '<cmd>Obsidian template<CR>', desc = 'Obsidian: Insert [M]emplate' },
    { '<leader>oM', '<cmd>Obsidian new_from_template<CR>', desc = 'Obsidian: [N]ew from template' },
    { '<leader>oq', '<cmd>Obsidian quick_switch<CR>', desc = 'Obsidian: [Q]uick switch' },
    { '<leader>ou', '<cmd>Obsidian unique_note<CR>', desc = 'Obsidian: [U]nique note' },
    { '<leader>ow', '<cmd>Obsidian workspace<CR>', desc = 'Obsidian: [W]orkspace' },
    { '<leader>oF', '<cmd>Obsidian footnotes<CR>', desc = 'Obsidian: [F]ootnotes' },
    { '<leader>oi', '<cmd>Obsidian link<CR>', mode = 'v', desc = 'Obsidian: [L]ink selection to note' },
    { '<leader>oI', '<cmd>Obsidian link_new<CR>', mode = 'v', desc = 'Obsidian: Link selection to [N]ew note' },
    { '<leader>ox', '<cmd>Obsidian extract_note<CR>', mode = 'v', desc = 'Obsidian: E[x]tract selection to note' },
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md" -- refer to `:h file-pattern` for more examples
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
    -- render-markdown handles visual styling; disable obsidian's own
    -- extmark rendering so the two don't fight over the same buffer.
    ui = { enable = false },
    workspaces = {
      {
        name = 'Game Dev',
        path = vault_path .. 'GameDevelopmentVault',
      },
      {
        name = 'Personal',
        path = vault_path .. 'MindGardenVault',
      },
    },
    callbacks = {
      enter_note = function()
        -- Toggle check-boxes. `<CR>` (smart action) is already mapped by default.
        vim.keymap.set('n', '<leader>ch', '<cmd>Obsidian toggle_checkbox<CR>', { buffer = true, desc = 'Toggle checkbox' })
        vim.keymap.set('v', '<leader>ch', '<cmd>Obsidian toggle_checkbox<CR>', { buffer = true, desc = 'Toggle checkbox in range' })
      end,
    },
  },
  ---@param url string
  follow_url_func = function(url)
    -- Open the URL in the default web browser.
    -- vim.fn.jobstart { 'open', url } -- Mac OS
    vim.fn.jobstart { 'xdg-open', url } -- linux
    -- vim.cmd(':silent exec ""') -- Windows
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
