local LrHttp = import "LrHttp"
local LrMD5 = import "LrMD5"
local LrDevelopController = import 'LrDevelopController'
local LrStringUtils = import 'LrStringUtils'
local LrDialogs = import 'LrDialogs'
local LrBinding = import 'LrBinding'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'

local i = 1




local function observerCallBack( propertyTable, key, value )
     -- do something with new value
	 --LrDialogs.message("something","changed")
 end
 


 local headers = {
	 {field = 'Content-Type', value = 'skip' },
	 {field = 'Accept', value = 'skip' },
 }
 
 local pluginRunning = true
 

 
 -- adjustPanel
 
 import "LrTasks".startAsyncTask( function()
     -- local result, hdrs = LrHttp.get( "http://192.168.43.1:55556/Temperature=4000&Tint=0", headers, 1)
	 
	LrFunctionContext.callWithContext ("Observer", function (context)  
        LrDevelopController.addAdjustmentChangeObserver (  
            context, "", updateController)  
        while pluginRunning do LrTasks.sleep (1) end  
        end)
	end)
	
function updateController(propertyTable, key, value)
	 local min,max = LrDevelopController.getRange(param)	 
	 local tempValue = LrDevelopController.getValue(param)
	 local fields = { "Temperature", "Tint", "Exposure", "Contrast", "Highlights", "Shadows", "Whites", "Blacks" }
	 local URL = "http://192.168.43.1:55556/"
	 
	 for i=1,#fields,1
	 do
		-- LrDialogs.message(fields[i])
		local param = fields[i]
		local min,max = LrDevelopController.getRange(param)	 
		local tempValue = LrDevelopController.getValue(param)
		tempValue = 100 * (tempValue-min) / (max - min)
		local tempString = LrStringUtils.numberToString(tempValue)
		URL = URL .. param
		URL = URL .. "="
		URL = URL .. LrStringUtils.numberToString(tempValue)
		if i < #fields then URL = URL .. "&" end
	
	end
	import "LrTasks".startAsyncTask( function()
	-- LrDialogs.message("",URL)
		local result, hdrs = LrHttp.get( URL, headers, 1)
	end) 
 end