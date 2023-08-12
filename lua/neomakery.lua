local M = {}

function M.setup()
  require('neoconf.plugins').register {
    name = 'neomakery',
    on_schema = function(schema)
      local compiler = { enum = vim.fn.getcompletion('*', 'compiler') }
      local makeprg = { type = 'string' }

      schema:set('neomakery.compilers', {
        type = 'object',
        additionalProperties = {
          type = 'object',
          anyOf = {
            {
              type = 'object',
              properties = {
                compiler = compiler,
                makeprg = makeprg,
              },
              required = { 'makeprg' },
            },
            {
              type = 'object',
              properties = {
                compiler = compiler,
                makeprg = makeprg,
              },
              required = { 'compiler' },
            },
          },
          properties = {
            errorformat = { type = 'string' },
          },
        },
      })
    end,
  }
end

function M.show_menu()
  local settings = require('neoconf').get('neomakery', {
    compilers = {},
  })

  local orig_makeprg = vim.o.makeprg
  local orig_errorformat = vim.o.errorformat
  local select_options = {
    {
      name = 'Current',
      makeprg = orig_makeprg,
      errorformat = orig_errorformat,
    },
  }
  for name, option in pairs(settings.compilers) do
    if option.compiler then vim.cmd.compiler(option.compiler) end

    table.insert(select_options, {
      name = name,
      makeprg = option.makeprg or vim.o.makeprg,
      errorformat = option.errorformat or vim.o.errorformat,
    })
  end

  vim.o.makeprg = orig_makeprg
  vim.o.errorformat = orig_errorformat

  vim.ui.select(select_options, {
    prompt = 'Choose a compiler to run',
    format_item = function(option)
      return vim.fn.printf('%s (%s)', option.name, option.makeprg)
    end,
  }, function(option)
    if not option then return end

    vim.o.makeprg = option.makeprg
    vim.o.errorformat = option.errorformat
    vim.cmd.make()
    vim.cmd.cwindow()
  end)
end

return M
