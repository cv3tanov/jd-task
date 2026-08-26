local settings = require 'config'
local isVisible = false

local function sendMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

---@param description string
---@param title? string
local function showTask(description, title)
    if type(description) ~= 'string' or description == '' then
        print('^3[jd-task]^7 Show очаква непразно описание като първи аргумент.')
        return false
    end

    sendMessage('show', {
        title = type(title) == 'string' and title ~= '' and title or settings.title,
        description = description,
        closeKey = settings.hide.defaultKey
    })
    isVisible = true
    return true
end

local function hideTask()
    if not isVisible then return false end
    sendMessage('hide')
    isVisible = false
    return true
end

exports('Show', showTask)
exports('Hide', hideTask)

RegisterCommand(settings.hide.command, hideTask, false)
RegisterKeyMapping(settings.hide.command, settings.hide.description, 'keyboard', settings.hide.defaultKey)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and isVisible then
        sendMessage('hide')
    end
end)
