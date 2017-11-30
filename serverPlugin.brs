Function serverPlugin_Initialize(msgPort As Object, userVariables As Object, o as Object)

  print "serverPlugin_Initialize - entry"
  print "type of msgPort is ";type(msgPort)
  print "type of userVariables is ";type(userVariables)
	print "type of o is ";type(o)

  print "type of o.localServer is ";type(o.localServer)
  ServerPlugin = newServerPlugin(msgPort, userVariables, o)

  server = o.localServer
  ok = server.AddGetFromFile({ url_path: "/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4", content_type: "video/mp4", filename: "hls/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"})
  print ok
  ok = server.AddGetFromFile({ url_path: "/Roku_4K_Streams/trimforted.mp4", content_type: "video/mp4", filename: "hls/Roku_4K_Streams/trimforted.mp4"})
  print ok
  ok = server.AddGetFromFile({ url_path: "/GetM", content_type: "text/plain; charset=utf-8", filename: "hls/fox5/play.m3u8"})
  print ok

  return ServerPlugin

End Function


Function newServerPlugin(msgPort As Object, userVariables As Object, o As Object)

  ServerPlugin = { }
  ServerPlugin.msgPort = msgPort
  ServerPlugin.userVariables = userVariables
	ServerPlugin.o = o

  ServerPlugin.ProcessEvent = serverPlugin_ProcessEvent

  return ServerPlugin

End Function


Function serverPlugin_ProcessEvent(event As Object) As Boolean

  print "serverPlugin_ProcessEvent - entry"
  print "type of m is ";type(m)
  print "type of event is ";type(event)

	if type(event) = "roAssociativeArray" then
		if type(event["EventType"]) = "roString"
			if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
			  print "received plugin message"
			endif
		endif
	endif

	return false

End Function