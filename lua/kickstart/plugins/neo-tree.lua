return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x', -- Or "main" if you prefer, v3.x is the latest stable
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Optional, for file icons
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional, for image previews
  },
  cmd = 'Neotree', -- Load when Neotree command is executed
  keys = {
    -- Example keymap to toggle Neo-tree
    -- Adjust the key to your preference
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    {
      '<leader>E', -- Example: open to the file's directory
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.fn.expand '%:p:h' }
      end,
      desc = 'Explorer NeoTree (file dir)',
    },
    -- You can add more keymaps here as needed
  },
  -- Defer setup until Neotree is actually loaded
  -- This is often a good practice for plugins that aren't needed immediately at startup
  config = function()
    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

    -- Configure Neo-tree
    -- For all options, see :help neo-tree-options
    require('neo-tree').setup {
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- Buffer types that appear in the path list
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom sorting function
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          -- The next options are only used if you have 'nvim-web-devicons' installed
          -- To have unclear icon colors, set the highlight to 'NeoTreeFileName'
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            -- Change type
            added = '', -- or "✚", but this will override the folder icon because AddHighlight group is global
            modified = '', -- or "", but this will override the folder icon because ModHighlight group is global
            deleted = '✖', -- this will override the folder icon because DelHighlight group is global
            renamed = '󰁕', -- this will override the folder icon because RenHighlight group is global
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
        -- If you don't want to use the default settings, you can override them here:
        -- directory = {
        --   arrow_closed = "",
        --   arrow_open = "",
        -- },
        -- file = {
        --   enable_diagnostics = true,
        -- },
      },
      -- Add this section and customize to your liking
      window = {
        position = 'left',
        width = 50,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with <space>
          },
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['<esc>'] = 'cancel', -- close preview or floating neo-tree
          ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
          -- Read `#how-to-use` for details on how to define mappings
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          ['t'] = 'open_tabnew',
          -- ["<cr>"] = "open_drop",
          -- ["t"] = "open_tab_drop",
          ['w'] = 'open_with_window_picker',
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          ['C'] = 'close_node',
          -- ['C'] = 'close_all_subnodes',
          ['z'] = 'close_all_nodes',
          --["Z"] = "expand_all_nodes",
          ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = 'none', -- "none", "relative", "absolute"
            },
          },
          ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy', -- copy file_to_be_copied to directory
          ['m'] = 'move', -- move file_to_be_moved to directory
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if other settings would normally show it
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
          -- time the current file is changed while the tree is open.
          leave_dirs_open = false,
        },
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = { -- see `:h neo-tree-window` for details
          mappings = {
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the loaded sorter
            ['f'] = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
            -- ['<key>'] = function(state) ... end,
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
          },
        },
        commands = {}, -- Add custom commands or override default commands
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
          -- time the current file is changed while the tree is open.
          leave_dirs_open = false,
        },
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = { -- see `:h neo-tree-window` for details
          mappings = {
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },
      git_status = {
        window = { -- see `:h neo-tree-window` for details
          position = 'float',
          mappings = {
            ['A'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['ga'] = 'git_add_file',
            -- ["gr"] = "git_remove_file",
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },
    }
  end,
}
