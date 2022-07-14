-- Data export script for DCS, version 1.2.
-- Copyright (C) 2006-2014, Eagle Dynamics.
-- See http://www.lua.org for Lua script system info 
-- We recommend to use the LuaSocket addon (http://www.tecgraf.puc-rio.br/luasocket) 
-- to use standard network protocols in Lua scripts.
-- LuaSocket 2.0 files (*.dll and *.lua) are supplied in the Scripts/LuaSocket folder
-- and in the installation folder of the DCS. 

-- Expand the functionality of following functions for your external application needs.
-- Look into Saved Games\DCS\Logs\dcs.log for this script errors, please.

function LuaExportStart()
	package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
	package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
	socket = require("socket")
	host = host or "localhost"
	port = port or 6666
	FFB_socket = socket.try(socket.udp())
	FFB_socket:settimeout(100)
	FFB_socket:setpeername(host,port)
end

function LuaExportActivityNextEvent(t)
	local tNext = t
    local AOA = LoGetAngleOfAttack()
    local IAS = LoGetIndicatedAirSpeed()*3.6
	local G = LoGetAccelerationUnits().y
	local rpm = (LoGetEngineInfo().RPM.left + LoGetEngineInfo().RPM.right) / 2
	socket.try(FFB_socket:send(string.format("%.2f;%.2f;%.2f;%.2f;1\n", IAS, G, AOA, rpm)))
    tNext = tNext + 0.1
	return tNext
end

function LuaExportStop()
	socket.try(FFB_socket:send(string.format("%.2f;%.2f;%.2f;%.2f;0\n", 0,0,0,0)))
end

local Tacviewlfs=require('lfs');dofile(Tacviewlfs.writedir()..'Scripts/TacviewGameExport.lua')
