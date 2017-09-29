--[[----------------------------------------------------------------------------

--------------------------------------------------------------------------------


------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrSocket = import 'LrSocket'
local LrTasks = import 'LrTasks'
local LrLogger = import 'LrLogger'
local LrHttp = import 'LrHttp'
local LrSelection = import 'LrSelection'
local LrUndo = import 'LrUndo'

-- local LrString = import 'LrString'

local myLogger = LrLogger( 'exportLogger' )
myLogger:enable( "print" )
myLogger:trace("start")

-- LrDialogs.message( "ExportMenuItem Selected", "Meh", "info" );

VIRTUALMIDI = {PARAM_OBSERVER = {}, SERVER = {}, CLIENT = {}, RUNNING = true}
-- LrDialogs.message("Go", "Go", "Go")

LrTasks.startAsyncTask( function()
local function startServer (context)
    LrFunctionContext.callWithContext( 'socket_remote', function( context )
     local running = true
	 local LrDevelopController = import 'LrDevelopController'
     local receiver = LrSocket.bind {
      functionContext = context,
	  plugin = _PLUGIN,
      port = 55555,
      mode = "receive",
      onConnecting = function( socket, port )
       -- TODO
      end,
      onConnected = function( socket, port )
	  LrStringUtils = import 'LrStringUtils'
	  LrDialogs.message("Connected3",LrStringUtils.numberToString(port))
	  -- socket:type("send")
	  -- socket:send("hello")
       -- TODO
      end,
      onMessage = function( socket, message )
		
	  local control = message:sub(1,1)
	  local value = message:sub(3)
		-- LrDialogs.message(control,value,*2,value*2)
		-- LrDialogs.message("A", "B", "C")
		local split = message:find(',',1,true)
		local param = message:sub(1,split-1)
        local value = message:sub(split+1)
		
		-- LrDialogs.message(receiver:type(),"","")
		-- receiver:send("hello")
		-- LrDialogs.message(param,value)
		if param == "Back" then
			LrSelection.previousPhoto()
		elseif param == "First" then
			LrSelection.selectFirstPhoto()
		elseif param == "Next" then
			LrSelection.nextPhoto()
		elseif param == "Last" then
			LrSelection.selectLastPhoto()
		elseif param == "Undo" then
			if (LrUndo.canUndo) then
			LrUndo.undo()
			end
		elseif param == "quit" then
			running=false
		else
			LrDialogs.message("Setting", param)
			local iValue = value + 0
			local low, high = LrDevelopController.getRange(param)
			
			-- normalise the control to the range of the slider (0-100)
			local cScale = (high - low) / 100
			iValue = (iValue * cScale) + low
			LrDevelopController.setValue(param,iValue)
			end
			
      end,
      onClosed = function( socket )
       running = false
	   -- -- -- undo this: socket:reconnect()
	   -- receiver:close()
	   -- startServer(context)
      end,
      onError = function( socket, err )
       if err == "timeout" then
        socket:reconnect()
       end
      end,
     }
     -- sender:send( "Hello world" )
     while running do
		--local response, headers = LrHttp.get("http://127.0.0.1:8000/sliders.txt")
		--LrDialogs.message(response,"","")
      LrTasks.sleep( 1/2 ) -- seconds
     end
     receiver:close()
    end )
end
startServer(context)
 end )
