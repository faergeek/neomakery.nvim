local name = 'neomakery'

require('neoconf.plugins').register {
  name = name,
  on_schema = function(schema)
    local compiler = { enum = vim.fn.getcompletion('*', 'compiler') }
    local makeprg = { type = 'string' }

    schema:set(name, {
      type = 'object',
      properties = {
        compilers = {
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
        },
      },
    })
  end,
}
