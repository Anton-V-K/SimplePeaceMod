-- Checks whether given value 'val' is present in given table 'tab'
-- (c) https://stackoverflow.com/a/33511182/536172
function has(tab, val)
    if val then
        for index, value in ipairs(tab) do
            if value == val then
                return true
            end
        end
    end
    return false
end

-- Splits given string 's' into parts, which are separated with given separator 'sep'
-- (c) https://stackoverflow.com/a/40180465/536172
function split(s, sep)
    local fields = {}

    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

-- Converts given table 'tab' to string (for printing)
-- (c) https://stackoverflow.com/a/50959106/536172
function tableToString(tab)
    local s = ""

    for k, v in pairs(tab) do
        if s ~= "" then
            s = s .. ","
        end
        -- concatenate key/value pairs, with a newline in-between
        s = s .. k .. ":";
        if type(v) == "table" then
            s = s .. tableToString(v)
        else
            s = s .. v
        end
    end

    return "{" .. s .. "}"
end
