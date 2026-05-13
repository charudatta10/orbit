-- Set package path to include the root and the current directory
package.path = package.path .. ';../../?.lua;./?.lua'

local pf = require('orbit')

-- TODO: Implement logic for orbit-structured-output

local function main()
    print('Running orbit-structured-output')
end

main()
