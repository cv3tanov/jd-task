local settings = JDTaskConfig

local activeTask
local isVisible = false

local function sendMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function validDescription(description, exportName)
    if type(description) == 'string' and description ~= '' then return true end
    print(('^3[jd-task]^7 %s очаква непразно описание като първи аргумент.'):format(exportName))
    return false
end

local function applyTask(description, title, options)
    options = type(options) == 'table' and options or {}
    local duration = tonumber(options.duration)

    activeTask = activeTask or {}
    activeTask.description = description
    activeTask.title = type(title) == 'string' and title ~= '' and title or activeTask.title or settings.title
    activeTask.timerLabel = type(options.timerLabel) == 'string' and options.timerLabel ~= '' and options.timerLabel
        or activeTask.timerLabel or settings.timerLabel

    if duration then
        activeTask.deadline = GetGameTimer() + math.max(0, math.floor(duration))
    elseif options.clearTimer == true then
        activeTask.deadline = nil
    end
end

local function taskData()
    if not activeTask then return nil end
    return {
        title = activeTask.title,
        description = activeTask.description,
        closeKey = settings.toggle.defaultKey,
        timerLabel = activeTask.timerLabel,
        duration = activeTask.deadline and math.max(0, activeTask.deadline - GetGameTimer()) or nil
    }
end

---@param description string
---@param title? string
---@param options? table
local function showTask(description, title, options)
    if not validDescription(description, 'Show') then return false end
    applyTask(description, title, options)
    sendMessage('show', taskData())
    isVisible = true
    return true
end

---@param description string
---@param title? string
---@param options? table
local function updateTask(description, title, options)
    if not validDescription(description, 'Update') then return false end
    applyTask(description, title, options)
    sendMessage('update', taskData())
    return true
end

local function hideTask()
    if not activeTask then return false end
    activeTask = nil
    isVisible = false
    sendMessage('hide')
    return true
end

local function toggleTask()
    if not activeTask then return false end
    if isVisible then
        sendMessage('hide')
        isVisible = false
    else
        sendMessage('show', taskData())
        isVisible = true
    end
    return true
end

exports('Show', showTask)
exports('Update', updateTask)
exports('Hide', hideTask)
exports('Toggle', toggleTask)

RegisterCommand(settings.toggle.command, toggleTask, false)
RegisterKeyMapping(settings.toggle.command, settings.toggle.description, 'keyboard', settings.toggle.defaultKey)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then sendMessage('hide') end
end)
