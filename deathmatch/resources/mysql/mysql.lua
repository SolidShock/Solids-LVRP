--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]
-- Production Server
production = (get( "production_server" ) == "1" or false)
socket = get( "socket" ) or ""

-- connection settings
hostname = "localhost"
username = "root"
password = ""
database = "mta_server"
port = tonumber("3306")

core_hostname = "localhost"
core_username = "root"
core_password = ""
core_database = "mta_server"
core_port = tonumber("3306")

local dbConns = {}

function createConnection(res, db)
	if ((db and db == "mta") or not db) and not dbConns.mta then
		dbConns.mta = dbConnect("mysql","dbname=".. database ..";host="..hostname..";port="..port..";"..socket, username, password, "autoreconnect=1")
		if dbConns.mta then
			if eventName then
				outputDebugString("[MYSQL] createConnection / "..database.." / OK")
			else
				connectToDatabase(res) -- Restart the connection for the MySQL Module
				outputDebugString("[MYSQL] reconnectConnection / "..database.." / OK")
			end
		else
			if eventName then
				cancelEvent(true, "Cannot connect to the database.")
				outputDebugString("[MYSQL] createConnection / "..database.." / FAILED")
			else
				outputDebugString("[MYSQL] reconnectConnection / "..database.." / FAILED")
			end
		end
		-- create the migrations table if it didn't already exist.
		createMigrationsTable()
	elseif (db and db == "core") and not dbConns.core then
		dbConns.core = dbConnect("mysql","dbname=".. core_database ..";host="..core_hostname..";port="..core_port..";"..socket, core_username, core_password, "autoreconnect=1")
		if dbConns.core then
			if eventName then
				outputDebugString("[MYSQL] createConnection / "..core_database.." / OK")
			else
				outputDebugString("[MYSQL] reconnectConnection / "..core_database.." / OK")
			end
		else
			if eventName then
				cancelEvent(true, "Cannot connect to the database.")
				outputDebugString("[MYSQL] createConnection / "..core_database.." / FAILED")
			else
				outputDebugString("[MYSQL] reconnectConnection / "..core_database.." / FAILED")
			end
		end
	end

	if not eventName then
		return dbConns[db]
	end
end
addEventHandler("onResourceStart", resourceRoot, createConnection)

function getConn(db)
	if isElement(dbConns[db or 'mta']) then
		return dbConns[db or 'mta']
	else
		return createConnection(false, db or 'mta')
	end
end

function getSmallestID( table, index )
	index = index or 'id'
	return "(SELECT MIN(e1."..index.."+1) FROM "..table.." AS e1 LEFT JOIN "..table.." AS e2 ON e1."..index.." +1 = e2."..index.." WHERE e2."..index.." IS NULL)"
end
