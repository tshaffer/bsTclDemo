''  Stream.url = "http://10.1.0.95:3000/fox5/play.m3u8"
''  Stream.url = "http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"
''  attractLoopUrl = "http://10.1.0.95:3000/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"

Sub Main()

  print "BrightSign / Roku TCL Demo"

''  rokuIPAddress = "10.1.0.89"
'' rokuIPAddress = "10.1.0.92"
''  rokuIPAddress = "192.168.0.109"

  bsIPAddress = "10.1.0.95"
''  bsIPAddress = "192.168.0.105"
  videoUrlPrefix = "http://" + bsIPAddress + ":3000/"

''  Stream.url = "http://10.1.0.95:3000/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"
  attractVideoUrl = videoUrlPrefix + "Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"

  videos = []
  video = {}

  video.url = videoUrlPrefix + "Roku_4K_Streams/dvretail.p5_U25000.mp4"
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

  html = LaunchHtmlServer()

  while true

    msg = wait(0, msgPort)
		print "msg received - type=" + type(msg)

    if type(msg) = "roControlDown" then

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

    endif


  end while

End Sub


Function CreateUDPSender()

  udpSender = CreateObject("roDatagramSender")
''	udpSender.SetDestination("BCAST-LOCAL-SUBNETS", 5000)
  udpSender.SetDestination("10.8.1.92", 5000)

''  if udpAddressType$ = "LocalSubnet" then
''  	udpSender.SetDestination("BCAST-LOCAL-SUBNETS", 5000)
''  else if udpAddressType$ = "Ethernet" then
''    udpSender.SetDestination("BCAST-SUBNET-0", udpSendPort)
''  else if udpAddressType$ = "Wireless" then
''    udpSender.SetDestination("BCAST-SUBNET-1", udpSendPort)
''  else
''    udpSender.SetDestination(udpAddress$, udpSendPort)
''  endif

  return udpSender

End Function


Sub LaunchAttractVideo(udpSender As Object, attractVideoUrl$ As String)
  udpMessage = "attract:" + attractVideoUrl$
  SendCommandToRoku(udpSender, udpMessage)
End Sub


Sub LaunchVideo(udpSender As Object, video As Object)
  print "launchVideo at: "; video.url
  udpMessage = "video:" + video.url + ":streamFormat:" + video.streamFormat
  SendCommandToRoku(udpSender, udpMessage)
End Sub


Sub SendCommandToRoku(udpSender As Object, udpMessage As String)
  udpSender.Send(udpMessage)
End Sub


Function LaunchHtmlServer() As Object
  x = 0
  y = 0
  width = 1280
  hight = 720

  aa = {}
  aa.AddReplace("nodejs_enabled",true)
  aa.AddReplace("brightsign_js_objects_enabled",true)
  aa.AddReplace("url","file:///index.html")

  is = {}
  is.AddReplace("port",2999)

  aa.AddReplace("inspector_server",is)

  rect = CreateObject("roRectangle", x, y, width, hight)
  html = CreateObject("roHtmlWidget", rect, aa)

  html.Show()

  return html

End Function
