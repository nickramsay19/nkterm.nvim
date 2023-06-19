if vim.g.loaded_nkterm == 1 then
  return
end
vim.g.loaded_nkterm = 1

require('nkterm').setup()
