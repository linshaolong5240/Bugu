//
//  AppDelegate.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/19.
//  Copyright © 2020 teeloong. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if UserDefaults.standard.bool(forKey: UserDataKey.everLaunch) {
            UserDefaults.standard.set(false, forKey: UserDataKey.isFirstLaunch)
        } else {//first Launch
            UserDefaults.standard.set(true, forKey: UserDataKey.everLaunch)
            UserDefaults.standard.set(true, forKey: UserDataKey.isFirstLaunch)
        }

        // Create the SwiftUI view that provides the window contents.
        let userData =  UserData()
        let player = Player()
        
        //        updateJSON()
        let contentView = ContentView()
            .environmentObject(userData)
            .environmentObject(player)

        // Create the window and set the content view. 
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
        
        popover.behavior = .transient
        popover.contentViewController =  NSHostingController(rootView: AnyView(contentView))

        popover.contentViewController?.preferredContentSize = NSSize(width: 272, height: 600)
        statusBarItem.button?.title = "Cyber Space"
        statusBarItem.button?.action = #selector(togglePopover(sender:))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    func showPopover(sender: AnyObject?) {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
}

