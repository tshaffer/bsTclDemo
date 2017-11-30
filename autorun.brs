Sub Main()

  print "BrightSign / Roku TCL Demo"

  bsIPAddress = "10.1.0.95"
  rokuIPAddress = "10.8.1.155"

  videoUrlPrefix = "http://" + bsIPAddress + ":3000/"

''  attractVideoUrl = videoUrlPrefix + "Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"

  videos = []

  video = {}
  video.url = videoUrlPrefix + "Roku_4K_Streams/trimforted.mp4"
  video.streamFormat = "mp4"
  videos.push(video)

  video = {}
  video.url = videoUrlPrefix + "fox5/play.m3u8"
  video.streamFormat = "hls"
  videos.push(video)

  video = {}
  video.url = videoUrlPrefix + "v3sample/play.m3u8"
  video.streamFormat = "hls"
  videos.push(video)

  msgPort = CreateObject("roMessagePort")

	controlPort = CreateObject("roControlPort", "TouchBoard-0-GPIO")
	controlPort.SetPort(msgPort)

	svcPort = CreateObject("roControlPort", "BrightSign")
	svcPort.SetPort(msgPort)

  udpSender = CreateUdpSender()

  udpReceiver = CreateObject("roDatagramReceiver", 5000)
  udpReceiver.SetPort(msgPort)

  httpServer = LaunchHttpServer(msgPort)

  timer = CreateObject("roTimer")
  timer.SetPort(msgPort)
  timer.SetElapsed(10, 0)
  timer.Start()

  xfer = CreateObject("roUrlTransfer")
  xfer.SetUrl(rokuIPAddress + ":8060/launch/dev")

  while true

    msg = wait(0, msgPort)
		print "msg received - type=" + type(msg)

    if type(msg) = "roControlDown" then

      ' user pressed button to select video

      buttonNumber% = msg.GetInt()
      if buttonNumber% = 12 then
        stop
      else if buttonNumber% = 0 then
        LaunchVideo(udpSender, videos[0])
      else if buttonNumber% = 1 then
        LaunchVideo(udpSender, videos[1])
      else if buttonNumber% = 2 then
        LaunchVideo(udpSender, videos[2])
      endif

    else if type(msg) = "roDatagramEvent" then

      ' heartbeat received from roku

      msg$ = msg.GetString()
      if msg$ = "roku" then
        print "roku heartbeat received"
        timer.Stop()
        timer.SetElapsed(10, 0)
        timer.Start()
      endif

    else if type(msg) = "roTimerEvent" then

      ' no heartbeat received from Roku app - try to launch it (Roku apparently ignores this if the app is already active)

      xfer.PostFromString("")
      timer.SetElapsed(10, 0)
      timer.Start()

    endif

  end while

End Sub


Function CreateUDPSender()
  udpSender = CreateObject("roDatagramSender")
  udpSender.SetDestination("10.8.1.155", 5000)
  return udpSender
End Function


''Sub LaunchAttractVideo(udpSender As Object, attractVideoUrl$ As String)
''  udpMessage = "attract:" + attractVideoUrl$
''  SendCommandToRoku(udpSender, udpMessage)
''End Sub


Sub LaunchVideo(udpSender As Object, video As Object)
  print "launchVideo at: "; video.url
  udpMessage = "video:" + video.url + ":streamFormat:" + video.streamFormat
  SendCommandToRoku(udpSender, udpMessage)
End Sub


Sub SendCommandToRoku(udpSender As Object, udpMessage As String)
  udpSender.Send(udpMessage)
End Sub


Function LaunchHttpServer(msgPort) As Object

'https=createobject("roHttpServer", { port: 1770 })
'm=createobject("romessageport")
'https.addgetfromfile({ url_path: "/res.ts", filename: "SD:/res.ts"})

  httpServer = CreateObject("roHttpServer", { port : 3000 })
  httpServer.SetPort(msgPort)
	httpServer.AddGetFromFile({ url_path: "/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4", content_type: "video/mp4", filename: "hls/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"})
	httpServer.AddGetFromFile({ url_path: "/Roku_4K_Streams/trimforted.mp4", content_type: "video/mp4", filename: "hls/Roku_4K_Streams/trimforted.mp4"})
	httpServer.AddGetFromFile({ url_path: "/fox5/play.m3u8", content_type: "application/x-mpegURL", filename: "hls/fox5/play.m3u8"})
	httpServer.AddGetFromFile({ url_path: "/v3sample/play.m3u8", content_type: "application/x-mpegURL", filename: "hls/v3sample/play.m3u8"})

  return httpServer

''  x = 0
''  y = 0
''  width = 1280
''  hight = 720

''  aa = {}
''  aa.AddReplace("nodejs_enabled",true)
''  aa.AddReplace("brightsign_js_objects_enabled",true)
''  aa.AddReplace("url","file:///index.html")

''  is = {}
''  is.AddReplace("port",2999)

''  aa.AddReplace("inspector_server",is)

''  rect = CreateObject("roRectangle", x, y, width, hight)
''  html = CreateObject("roHtmlWidget", rect, aa)

''  html.Show()

''  return html

End Function
