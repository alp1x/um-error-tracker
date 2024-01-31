-- The code is registering a callback function with the name
-- 'um-admin-tracker:server:getConsoleBuffer'. When this callback is triggered, it will execute the
-- provided function, which calls the function GetConsoleBuffer() and returns its result.
lib.callback.register('um-admin-tracker:server:getConsoleBuffer', function()
    return GetConsoleBuffer() --@see https://docs.fivem.net/natives/?_0xE57429FA
end)


-- The code `lib.versionCheck('overextended/ox_lib')` is checking the version of the library--
-- 'overextended/ox_lib'. It is likely a function provided by the library that allows you to check if
-- you have the latest version installed.
lib.versionCheck('alp1x/um-error-tracker')
