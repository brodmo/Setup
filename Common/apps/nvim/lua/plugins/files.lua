return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
      picker = {
        win = {
          preview = {
            wo = {
              signcolumn = "no",
              number = false,
            },
          },
        },
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preset = "default",
              preview = "preview",
            },
          },
        },
      },
    },
  },
}
