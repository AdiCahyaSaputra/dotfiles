return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require "configs.conform",
	},

	{
		"sphamba/smear-cursor.nvim",
		event = "BufReadPost",
		opts = {
			cursor_color = "#ffffff",
			particles_enabled = true,

			-- stiffness = 0.5,
			-- trailing_stiffness = 0.2,
			-- trailing_exponent = 5,
			-- damping = 0.6,
			-- gradient_exponent = 0,
			-- gamma = 1,

			never_draw_over_target = true, -- if you want to actually see under the cursor
			hide_target_hack = true,    -- same
			particle_spread = 1,
			particles_per_second = 400,
			particles_per_length = 40,
			particle_max_lifetime = 400,
			particle_max_initial_velocity = 20,
			particle_velocity_from_cursor = 0.5,
			particle_damping = 0.15,
			particle_gravity = -50,
			min_distance_emit_particles = 0,
		}
	},

	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		event = { "SessionLoadPost", "VimLeavePre" },
		keys = {
			{ "<leader>Rs", desc = "Kulala: send request" },
			{ "<leader>Ra", desc = "Kulala: send all requests" },
			{ "<leader>Rr", desc = "Kulala: replay last request" },
			{ "<leader>Rb", desc = "Kulala: open scratchpad" },
			{ "<leader>Ro", desc = "Kulala: open response" },
			{ "<leader>Re", desc = "Kulala: select environment" },
			{ "<leader>Rt", desc = "Kulala: toggle view" },
		},
		opts = require "configs.kulala",
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "configs.lspconfig"
		end,
	},

	-- test new blink
	{ import = "nvchad.blink.lazyspec" },

	{ "tpope/vim-fugitive",            event = "BufReadPost" },
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup {
				ignore_filetypes = { env = true },
			}
		end,
		event = "BufReadPost",
		enabled = false,
	},

	"NvChad/nvcommunity",
	{ import = "nvcommunity.lsp.lspsaga" },
	{ import = "nvcommunity.lsp.barbecue" },
	{ import = "nvcommunity.motion.hop" },
	{ import = "nvcommunity.git.diffview" },
	{ import = "nvcommunity.tools.presence",   enabled = false },
	{ import = "nvcommunity.folds.ufo" },
	{ import = "nvcommunity.motion.neoscroll", enabled = false },
	{ import = "nvcommunity.editor.illuminate" },
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure {
				under_cursor = true,
				max_file_lines = nil,
				delay = 100,
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				filetypes_denylist = {
					"NvimTree",
					"Trouble",
					"Outline",
					"TelescopePrompt",
					"Empty",
					"dirvish",
					"fugitive",
					"alpha",
					"packer",
					"neogitstatus",
					"spectre_panel",
					"toggleterm",
					"DressingSelect",
					"aerial",
				},
			}

			dofile(vim.g.base46_cache .. "vim-illuminate")
		end
	},
	{
		"kevinhwang91/nvim-ufo",
		init = function()
			vim.o.foldlevel = 99 -- Using ufo provider need a large value
			vim.o.foldlevelstart = 99
			vim.o.foldnestmax = 0
			vim.o.foldenable = true
			vim.o.foldmethod = "indent"

			vim.opt.fillchars = {
				fold = " ",
				foldopen = "",
				foldsep = " ",
				foldclose = "",
				stl = " ",
				eob = " ",
			}
		end,
	},

	{
		"smoka7/hop.nvim",
		init = function()
			dofile(vim.g.base46_cache .. "hop")

			vim.keymap.set("n", "<leader>aw", ":HopWord<cr>", { desc = "Hop: Hop all word", nowait = true })
		end,
	},

	{ import = "nvcommunity.tools.telescope-fzf-native" },
	{
		"nvimdev/lspsaga.nvim",
		opts = {
			symbol_in_winbar = {
				enable = false,
			},
			lightbulb = {
				enable = false,
			},
			border = "none",
		},
	},

	{
		'mg979/vim-visual-multi',
		branch = "master",
		init = function()
			vim.g.VM_maps = {
				['Find Under']         = '<C-n>',
				['Find Subword Under'] = '<C-n>',
				['Add Cursor Down']    = '<C-Down>',
				['Add Cursor Up']      = '<C-Up>',
			}
		end,
		lazy = false
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			filters = {
				dotfiles = true,
				exclude = nil,
				git_ignored = false,
			},
			git = {
				enable = true,
			},
			view = {
				relativenumber = true,
			},
			renderer = {
				root_folder_label = function(path)
					return "../" .. vim.fn.fnamemodify(path, ":t")
				end,
				full_name = true,
				highlight_git = true,
				icons = {
					show = {
						git = true,
					},
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"markdown",
				"markdown_inline",
				"php",
				"prisma",
				"vue",
				"dart",
			},
			indent = {
				enable = true,
				-- disable = {
				--   "python"
				-- },
			},
			folding = {
				enable = true
			}
		},
		dependencies = {
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup {
					opts = {
						enable_close_on_slash = true,
					},
					filetypes = {
						"html",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"svelte",
						"vue",
						"tsx",
						"jsx",
						"rescript",
						"xml",
						"php",
						"markdown",
						"astro",
						"glimmer",
						"handlebars",
						"hbs",
						"blade",
					},
				}
			end,
		},
	},
	{
		"folke/which-key.nvim",
		enabled = false,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require('tiny-code-action').setup()
		end
	},
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					require("ts_context_commentstring").setup {
						enable_autocmd = false,
					}
				end,
			},
			{
				"folke/ts-comments.nvim",
				opts = {
					lang = {
						html = '{{-- %s --}}'
					}
				}
			}
		},
		config = function()
			require("Comment").setup {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}

			local ft = require('Comment.ft')

			ft.set('html', '{{-- %s --}}')
			ft.set('env', '# %s')

			vim.keymap.set('n', 'gcc', require('Comment.api').toggle.linewise.current)
		end,
	}
}
