return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function()
          local is_nuxt_project = false
          local file_list = vim.fn.systemlist("ls -a")
          for _, name in ipairs(file_list) do
            if name == ".nuxt" then
              is_nuxt_project = true
            end
          end
          if not is_nuxt_project then
            return
          end
          local original_definition = vim.lsp.buf.definition
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            group = vim.api.nvim_create_augroup("VueGoToDefinition", { clear = true }),
            pattern = "*.vue",
            callback = function(ev)
              vim.lsp.buf.definition = function()
                original_definition()
                vim.defer_fn(function()
                  local current_file = vim.fn.expand("%")
                  if not string.find(current_file, "components.d.ts") then
                    return
                  end
                  local line = vim.fn.getline(".")
                  local path = string.match(line, '".-/(.-)"')
                  vim.cmd("edit " .. path)
                end, 500)
              end
            end,
          })
        end,
      },
    },
  },
}
