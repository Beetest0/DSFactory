//
//  AppDelegate.swift
//  DasanFactoryApp
//
//  Created by Admin on 2021/04/25.
//

import Cocoa
import USBDeviceSwift

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let stm32DeviceMonitor = HIDDeviceMonitor([
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0110),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0113),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0120),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0122),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0123),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0124),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0125),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0126),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0127),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0128),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0130),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0131),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0132),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0133),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0134),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0135),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0136),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0140),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0141),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0142),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0143),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0144),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0145),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0151),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0152),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0220),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0221),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0310),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0320),
        
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0410),
        HIDMonitorData(vendorId: 0x2ea1, productId: 0x0500)
        ], reportSize: 64)

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let stm32DeviceDaemon = Thread(target: stm32DeviceMonitor, selector:#selector(stm32DeviceMonitor.start), object: nil)
        stm32DeviceDaemon.start()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            NSApplication.shared.terminate(self)
            return true
        }
    

}

