package.path = package.path .. ";../../?.lua;./?.lua"

local orbit = require("orbit")
local pf = orbit.pf
local utils = require("utils")

local FetchRecipes = pf.node:extend()
function FetchRecipes:prep(shared)
    return utils.get_user_input("Enter ingredient: ")
end
function FetchRecipes:exec(ingredient)
    return utils.fetch_recipes(ingredient)
end
function FetchRecipes:post(shared, prep_res, recipes)
    shared.recipes = recipes
    shared.ingredient = prep_res
    return "suggest"
end

local SuggestRecipe = pf.node:extend()
function SuggestRecipe:prep(shared)
    return shared.recipes
end
function SuggestRecipe:exec(recipes)
    return utils.call_llm("Choose best recipe from: " .. table.concat(recipes, ", "))
end
function SuggestRecipe:post(shared, prep_res, suggestion)
    shared.suggestion = suggestion
    return "approve"
end

local GetApproval = pf.node:extend()
function GetApproval:prep(shared)
    return shared.suggestion
end
function GetApproval:exec(suggestion)
    return utils.get_user_input("\nAccept this recipe? (y/n): ")
end
function GetApproval:post(shared, prep_res, answer)
    if answer == "y" then
        print("\nGreat choice! Here's your recipe...")
        print("Recipe: " .. shared.suggestion)
        print("Ingredient: " .. shared.ingredient)
        return "accept"
    else
        print("\nLet's try another recipe...")
        return "retry"
    end
end

local fetch = FetchRecipes:new()
local suggest = SuggestRecipe:new()
local approve = GetApproval:new()
local noop = pf.node:new()

fetch:add_transition("suggest", suggest)
suggest:add_transition("approve", approve)
approve:add_transition("retry", suggest)
approve:add_transition("accept", noop)

local flow = pf.flow:new(fetch)
local shared = {}

print("\nWelcome to Recipe Finder!")
print("------------------------")
flow:run(shared)
print("\nThanks for using Recipe Finder!")
