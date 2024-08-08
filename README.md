# telescope-co-author.nvim

telescope-co-author.nvim is a plugin for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that provides a picker for selecting co-authors for your git commits.

# Get Started

```lua
{
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  dependencies = {
    'Penpen7/telescope-co-author.nvim'
  },
  keys = { "<leader>f" },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    telescope.load_extension('co_author')

    vim.keymap.set("n", "<leader>fc", ":Telescope co_author<CR>", { silent = true })
  end
},
```

# Usage

`:Telescope co_author`
