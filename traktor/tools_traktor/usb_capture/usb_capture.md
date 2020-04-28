

wireshark capture midi:
----------------------- 
  winpcap: https://wiki.wireshark.org/CaptureSetup/USB
  analyse: https://bulldogjob.com/news/97-how-i-reverse-engineered-synthesizer-protocol
  python:  https://medium.com/@ali.bawazeeer/kaizen-ctf-2018-reverse-engineer-usb-keystrok-from-pcap-file-2412351679f4
  
  specific steps:
    c:\program files\winpcap\winpcap  (see hub) 
    unplug USB
    c:\program files\winpcap\winpcap  / "1" /  test.pcap / 
    plug USB
    ctrl+C
    wireshark 
    filter: 
      frame.time_relative >= 18 and  frame.time_relative <= 19  and usbaudio.midi.code_index
      usbaudio.midi.code_index
      
      
    file / export packet dissection / as csv
    
    