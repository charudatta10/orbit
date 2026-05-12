local pf = require("orbit")

local function assert_equal(actual, expected, message)
    if type(actual) == "table" and type(expected) == "table" then
        if #actual ~= #expected then
            error(string.format("Expected table of length %d, but got %d. %s", #expected, #actual, message or ""), 2)
        end
        for i = 1, #actual do
            if actual[i] ~= expected[i] then
                error(string.format("Expected element at index %d to be %s, but got %s. %s", i, tostring(expected[i]), tostring(actual[i]), message or ""), 2)
            end
        end
    elseif actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

-- --- Node Definitions ---

local function ArrayChunkNode(chunk_size)
    chunk_size = chunk_size or 10
    return pf.batch(function(shared, item)
        if not item then
            -- prep: split array into chunks
            local array = shared.input_array or {}
            local chunks = {}
            for i = 1, #array, chunk_size do
                local chunk = {}
                for j = i, math.min(i + chunk_size - 1, #array) do
                    table.insert(chunk, array[j])
                end
                table.insert(chunks, chunk)
            end
            shared.chunk_results = {} -- prepare to store results
            return chunks
        else
            -- exec: process chunk
            local sum = 0
            for _, v in ipairs(item) do sum = sum + v end
            -- post-like behavior: append to shared
            table.insert(shared.chunk_results, sum)
            return "default"
        end
    end)
end

local function SumReduceNode()
    return pf.node(function(shared)
        local total = 0
        for _, v in ipairs(shared.chunk_results or {}) do
            total = total + v
        end
        shared.total = total
    end)
end

-- --- Test Cases ---

local function test_array_chunking()
    print("Running test_array_chunking...")
    local array = {}
    for i = 0, 24 do table.insert(array, i) end
    
    local shared = { input_array = array }
    local chunk_node = ArrayChunkNode(10)
    
    pf.run(chunk_node, shared)
    
    -- Python expected: [45, 145, 110]
    -- Chunk 1: 0-9 sum = 45
    -- Chunk 2: 10-19 sum = 145
    -- Chunk 3: 20-24 sum = 20+21+22+23+24 = 110
    assert_equal(shared.chunk_results, {45, 145, 110})
end

local function test_map_reduce_sum()
    print("Running test_map_reduce_sum...")
    local array = {}
    local expected_sum = 0
    for i = 0, 99 do
        table.insert(array, i)
        expected_sum = expected_sum + i
    end
    
    local shared = { input_array = array }
    local chunk_node = ArrayChunkNode(10)
    local reduce_node = SumReduceNode()
    
    chunk_node:to("default", reduce_node)
    
    pf.run(chunk_node, shared)
    assert_equal(shared.total, expected_sum)
end

local function test_empty_array()
    print("Running test_empty_array...")
    local shared = { input_array = {} }
    local chunk_node = ArrayChunkNode(10)
    local reduce_node = SumReduceNode()
    
    chunk_node:to("default", reduce_node)
    
    pf.run(chunk_node, shared)
    assert_equal(shared.total, 0)
end

-- --- Run Tests ---

local function run_all()
    local ok, err = pcall(test_array_chunking)
    if not ok then print("FAILED: test_array_chunking: " .. err) else print("PASSED: test_array_chunking") end

    ok, err = pcall(test_map_reduce_sum)
    if not ok then print("FAILED: test_map_reduce_sum: " .. err) else print("PASSED: test_map_reduce_sum") end

    ok, err = pcall(test_empty_array)
    if not ok then print("FAILED: test_empty_array: " .. err) else print("PASSED: test_empty_array") end
end

run_all()
