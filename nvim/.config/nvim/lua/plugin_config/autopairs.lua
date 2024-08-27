vim.cmd ([[
	au FileType tex let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', "'":"'", "$":"$"}
]])
vim.cmd ([[
	au FileType latex let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', "'":"'", "$":"$"}
]])
--[=====[
vim.cmd ([[
	autocmd FileType html let b:AutoPairs = AutoPairsDefine({'>' : '<'}, [])
]])
vim.cmd ([[
	autocmd FileType tsx let b:AutoPairs = AutoPairsDefine({'>' : '<'}, [])
]])
vim.cmd ([[
	autocmd FileType ts let b:AutoPairs = AutoPairsDefine({'>' : '<'}, [])
]])
vim.cmd ([[
	autocmd FileType jsx let b:AutoPairs = AutoPairsDefine({'>' : '<'}, [])
]])
vim.cmd ([[
	autocmd FileType js let b:AutoPairs = AutoPairsDefine({'>' : '<'}, [])
]])
--]=====]
