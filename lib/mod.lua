require("func")             -- split

-- Returns version (as number XXYYZZ) for mod with given name
function mod_version(name)
    local res = 0
    for n_, version in pairs(game.active_mods) do
        -- log
        -- game.print(n_ .. " version " .. version) -- DEBUG
        if n_ == name then
            local ver = split(version, ".")
            for _, v in pairs(ver) do
                res = res * 100 + tonumber(v)
            end
            -- game.print(n_ .. " version " .. version .. " = " .. res) -- DEBUG
            break
        end
    end
    return res
end
