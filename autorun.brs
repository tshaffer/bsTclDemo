Sub Main()

  print "BrightSign / Roku TCL Demo"

''  rokuIPAddress = "10.1.0.89"
''  rokuIPAddress = "192.168.0.109"

''  bsIPAddress = "10.1.0.95"
  bsIPAddress = "192.168.0.105"
  videoUrlPrefix = "http://" + bsIPAddress + ":3000/"

''  Stream.url = "http://10.1.0.95:3000/Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"
  attractVideoUrl = videoUrlPrefix + "Roku_4K_Streams/TCL_2017_C-Series_BBY_4K-res.mp4"

  videoUrls = []
  videoUrls.push(videoUrlPrefix + "Roku_4K_Streams/dvretail.p5_U25000.mp4")
  videoUrls.push(videoUrlPrefix + "xx")
  videoUrls.push(videoUrlPrefix + "xx")

  msgPort = CreateObject("roMessagePort")

	controlPort = CreateObject("roControlPort", "TouchBoard-0-GPIO")
	controlPort.SetPort(msgPort)

	svcPort = CreateObject("roControlPort", "BrightSign")
	svcPort.SetPort(msgPort)

  udpSender = CreateUdpSender()

' html
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

  while true

    msg = wait(0, msgPort)
		print "msg received - type=" + type(msg)

    if type(msg) = "roControlDown" then

      buttonNumber% = msg.GetInt()

      if buttonNumber% = 12 then
        stop
      else if buttonNumber% = 0 then
        LaunchVideo(udpSender, videoUrls[0])
      else if buttonNumber% = 1 then
        LaunchVideo(udpSender, videoUrls[1])
      else if buttonNumber% = 2 then
        LaunchVideo(udpSender, videoUrls[2])
      endif

    endif


  end while

End Sub


Function CreateUDPSender()

  udpSender = CreateObject("roDatagramSender")
	udpSender.SetDestination("BCAST-LOCAL-SUBNETS", 5000)

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


' also contentType'
Sub LaunchAttractVideo(udpSender As Object, attractVideoUrl$ As String)
  udpMessage = "attract:" + attractVideoUrl$
  SendCommandToRoku(udpSender, udpMessage)
End Sub


' also contentType'
Sub LaunchVideo(udpSender As Object, videoUrl$ As String)
  print "launchVideo at: "; videoUrl$
  udpMessage = "video:" + videoUrl$
  SendCommandToRoku(udpSender, udpMessage)
End Sub


Sub SendCommandToRoku(udpSender As Object, udpMessage As String)
  udpSender.Send(udpMessage)
End Sub
