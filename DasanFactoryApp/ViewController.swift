//
//  ViewController.swift
//  DasanFactoryApp
//
//  Created by Admin on 2021/04/25.
//

import Cocoa
import USBDeviceSwift

class ViewController: NSViewController {
    
    @IBOutlet weak var TxtDeviceName: NSTextField!
    @IBOutlet weak var TxtUsbInfo: NSTextField!
    @IBOutlet weak var ImgDevice: NSImageView!
    
    
    @IBOutlet weak var ImgHook: NSImageView!
    @IBOutlet weak var TxtHookStatus: NSTextField!
    @IBOutlet weak var ImgMute: NSImageView!
    @IBOutlet weak var TxtMuteStatus: NSTextField!
    
    var connectedDevice:JPLDevice?
    var isFirstConnected:Bool = false
    
    var ring:Bool = false
    var hook:Bool = true
    var mute:Bool = false
    
    @IBOutlet weak var BtnRing: NSButton!
    @IBOutlet weak var BtnHook: NSButton!
    @IBOutlet weak var BtnMute: NSButton!
    
    @IBOutlet weak var TxtRing: NSTextField!
    
    @IBAction func ClickRing(_ sender: Any) {
        print("button ring")
        
        if (!ring)
        {
            
//            if(!hook)
//            {
//                print("hook 1", hook)
//                let writeData = Data([ 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ])
//                connectedDevice?.write(writeData);
//                hook = true
//
//            }
            
            print("ring start 1",ring,"hook ",hook)
            let writeData = Data([ 0x04, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ])
            connectedDevice?.write(writeData);
            self.TxtRing.stringValue = "RING START"
            
        }
        else
        {
            print("ring stop 2",ring,"hook ",hook)
            let writeData = Data([ 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ])
                
            connectedDevice?.write(writeData);
            self.TxtRing.stringValue = "RING STOP"
        }
        
        ring = !ring
        
        self.BtnRing.isEnabled = true
        self.BtnHook.isEnabled = true
        self.BtnMute.isEnabled = false

    }
    
    @IBAction func ClickHook(_ sender: Any) {
        
        
        if (!hook)
        {
            print("hook on 1", hook)
            let writeData = Data([ 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ])
            connectedDevice?.write(writeData);
            self.BtnRing.isEnabled = true
            self.TxtRing.stringValue = ""
        }
        else
        {
            print("hook off 2", hook)
            let writeData = Data([ 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ])
            connectedDevice?.write(writeData);
            self.BtnRing.isEnabled = false
            self.TxtRing.stringValue = ""
        }
        
        hook = !hook
        
        //self.BtnRing.isEnabled = true
        self.BtnHook.isEnabled = true
        self.BtnMute.isEnabled = true
    }
    
    @IBAction func ClickMute(_ sender: Any) {
        print("mute")
        
        if (!mute)
        {

            let writeData = Data([ 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ])
            connectedDevice?.write(writeData);
            
            self.TxtMuteStatus.stringValue = "Mute On"
            self.ImgMute.image = NSImage(named: "redcircle")
           
            
        }
        else
        {
            let writeData = Data([ 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ])
            connectedDevice?.write(writeData);
            
            self.TxtMuteStatus.stringValue = "Mute Off"
            self.ImgMute.image = NSImage(named: "bluecircle")
            
           
        }
        
       
        
        mute = !mute
        
        
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isFirstConnected = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbConnected), name: .HIDDeviceConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbDisconnected), name: .HIDDeviceDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidReadData), name: .HIDDeviceDataReceived, object: nil)
        
        
        BtnRing.isEnabled = false
        BtnHook.isEnabled = false
        
        BtnMute.isEnabled = false
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    @objc func usbConnected(notification: NSNotification) {
        
        print("usbConnected")
        
        
        guard let nobj = notification.object as? NSDictionary else {
            return
        }
        
        guard let deviceInfo:HIDDevice = nobj["device"] as? HIDDevice else {
            return
        }
        
        let device = JPLDevice(deviceInfo)
        
        
        
        DispatchQueue.main.async {
            //self.deviceName.stringValue = deviceInfo.name
            let rtnInfo = self.selectDeviceImage(devicename: deviceInfo.name)
            print(deviceInfo.vendorId)
            print(deviceInfo.productId)
            let h1 = String(deviceInfo.vendorId, radix: 16)
            print(h1) // "3d"
            let h2 = String(deviceInfo.productId, radix: 16)
            print(h2) // "3d"
            
            
            self.TxtDeviceName.stringValue = rtnInfo.1
            self.TxtUsbInfo.stringValue = h1+"/"+h2
            
            
            print(rtnInfo.0)
            print(rtnInfo.1)
            
            let image = NSImage(named: rtnInfo.0)
            
            self.ImgDevice.image = image
            
            self.isFirstConnected = true
            
            if(!self.isFirstConnected){
                
            }
            else {
               
            }
            
            // init
            self.ring = false
            self.hook = true
            self.mute = false
            
            self.TxtHookStatus.stringValue = ""
            self.ImgHook.image = NSImage(named: "bluecircle")
            
            self.TxtMuteStatus.stringValue = ""
            self.ImgMute.image = NSImage(named: "bluecircle")
            
            self.connectedDevice = device
            
            self.BtnRing.isEnabled = true
            self.BtnHook.isEnabled = false
 
            self.BtnMute.isEnabled = false
        }
        
    }
    
    
    @objc func usbDisconnected(notification: NSNotification) {
        
        print("usbDisconnected")
        
        
        DispatchQueue.main.async {
            print("usbDisconnected 3 ")
            self.TxtDeviceName.stringValue = "No Device"
            self.TxtUsbInfo.stringValue = ""
            
            let image = NSImage(named: "NOUSB")
            self.ImgDevice.image = image
            self.connectedDevice = nil
            
            self.TxtHookStatus.stringValue = ""
            self.ImgHook.image = NSImage(named: "bluecircle")
            
            self.TxtMuteStatus.stringValue = ""
            self.ImgMute.image = NSImage(named: "bluecircle")
            
            self.BtnRing.isEnabled = false
            self.BtnHook.isEnabled = false
            self.BtnMute.isEnabled = false
        }
    }
    
    @objc func hidReadData(notification: Notification) {
        let obj = notification.object as! NSDictionary
        let data = obj["data"] as! Data
        
        //print(data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8])
        if let str = self.connectedDevice?.convertByteDataToString(data) {
            
            DispatchQueue.main.async {
                if(str.count>0)
                {
                    print("msg",str)
                    
                    if(str == "hookon")
                    {
                        self.TxtHookStatus.stringValue = "Hook On"
                        self.ImgHook.image = NSImage(named: "bluecircle")
                        self.hook = true
                        self.ring = false
                    }
                    else if(str == "hookoff")
                    {
                        self.TxtHookStatus.stringValue = "Hook Off"
                        self.ImgHook.image = NSImage(named: "redcircle")
                        self.hook = false
                        self.ring = false
                    }
                    
                    if(str == "mute")
                    {
                        if(!self.mute)
                        {
                            self.TxtMuteStatus.stringValue = "Mute On"
                            self.ImgMute.image = NSImage(named: "redcircle")
                        }
                        else
                        {
                            self.TxtMuteStatus.stringValue = "Mute Off"
                            self.ImgMute.image = NSImage(named: "bluecircle")
                        }
                        
                        self.mute = !self.mute
                       
                    }
                }
                    
            }
            
        }
    }
    
    
    
    func selectDeviceImage(devicename: String) -> (String,String) {
        
        var rtnDeviceName = "Lync_new"
        var rtnDeviceImageName = "Lync_new"
        
        rtnDeviceName = devicename
        
        if (devicename.count>0)
        {
            if (devicename=="Lync USB Headset1")
            {
                rtnDeviceImageName = "Lync_new"
            }
            else if (devicename=="Lync USB Headset")
            {
                rtnDeviceImageName = "Lync_new"
            }
            else if (devicename=="DSU-08M")
            {
                rtnDeviceImageName = "DSU-08M"
            }
            else if (devicename=="BL-052L")
            {
                rtnDeviceImageName = "DSU-08M"
            }
                //===============================================================================
            else if (devicename=="DSU-09M")
            {
                rtnDeviceImageName = "DSU-09M"
            }
            else if (devicename=="BL-05MS")
            {
                rtnDeviceImageName = "DSU-09M"
            }
            else if (devicename=="DSU-09MT")
            {
                rtnDeviceImageName = "DSU-09M"
            }
            else if (devicename=="DSU-09ML")
            {
                rtnDeviceImageName = "DSU-09M"
            }
            else if (devicename=="DSU-09M-2CH")
            {
                rtnDeviceImageName = "DSU-09M"
            }
            else if (devicename=="JPL-400M")
            {
                rtnDeviceImageName = "JPL400M"
            }
            else if (devicename=="JPL-400B")
            {
                rtnDeviceImageName = "JPL400B"
            }
                //=============================================================================
            else if (devicename=="DSU-10M")
            {
                rtnDeviceImageName = "DSU-10M"
            }
            else if (devicename=="DSU-10M-2CH")
            {
                rtnDeviceImageName = "DSU-10M"
            }
            else if (devicename=="DSU-10ML-2CH")
            {
                rtnDeviceImageName = "DSU-10M"
            }
            else if (devicename=="BL-053")
            {
                rtnDeviceImageName = "BL-053"
            }
            else if (devicename=="BL-05")
            {
                rtnDeviceImageName = "JPL-611-IB"
            }
                //=============================================================================
            else if (devicename=="DSU-11M")
            {
                rtnDeviceImageName = "DSU-11M"
            }
            else if (devicename=="DSU-11M-2CH")
            {
                rtnDeviceImageName = "DSU-11M"
            }
            else if (devicename=="BL-054MS")
            {
                rtnDeviceImageName = "DSU-11MBL-054MS"
            }
                //=============================================================================
            else if (devicename=="DSU-15M")
            {
                rtnDeviceImageName = "DSU-15M"
            }
            else if (devicename=="DW-779U Lync")
            {
                rtnDeviceImageName = "DW-779U1"
            }
            else if (devicename=="X-400")
            {
                rtnDeviceImageName = "Lync_new"
            }
            else if (devicename=="DW-800U")
            {
                rtnDeviceImageName = "X500_Base_with_USB_Module"
                
            }
            else if (devicename=="X-500U")
            {
                rtnDeviceImageName = "X500_Base_with_USB_Module"
            }
            else if (devicename=="VoicePro 575")
            {
                rtnDeviceImageName = "VoicePro_575"
            }
            else if (devicename=="JPL Companion")
            {
                rtnDeviceImageName = "VoicePro-575"
            }
            else if (devicename=="DA-575")
            {
                rtnDeviceImageName = "VoicePro-575"
            }
            else if (devicename=="EHS-CI-01")
            {
                rtnDeviceImageName = "LYNC"
            }
            else if (devicename=="BT-200")
            {
                rtnDeviceImageName = "BT200"
            }
            else if (devicename=="BT-200U")
            {
                rtnDeviceImageName = "BT200"
            }
            
        }
        //rtnDeviceImageName = "DSU-08M"
        //rtnDeviceImageName = "VoicePro-575"
        //rtnDeviceImageName = "LYNC"
        // rtnDeviceImageName = "DSU-11MBL-054MS"
        //print (rtnDeviceImageName)
        
        return (rtnDeviceImageName,rtnDeviceName)
    }


}

