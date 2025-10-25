import AppKit
import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(named: "TrayIconDisabled")
            button.image?.isTemplate = true
            button.action = #selector(showMenu(_:))
            button.target = self
        }
    }
    
    @objc func showMenu(_ sender: AnyObject?) {
        guard let button = statusBarItem?.button else { return }
        
        let menu = NSMenu()
        
        let menuItem = swiftUItoNSItem(AppMenu())
        
        menu.addItem(menuItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        // TODO: Check if the offsets look good on notchless macs
        menu.popUp(positioning: nil, at: NSPoint(x: -2, y: button.bounds.height + 5), in: button)
    }
    
    func swiftUItoNSItem(_ view: some View) -> NSMenuItem {
        let menuItem = NSMenuItem()
        let hostingView = NSHostingView(rootView: view)
        
        let targetSize = hostingView.fittingSize
        hostingView.frame = NSRect(
            x: 0,
            y: 0,
            width: 300,
            height: targetSize.height
        )
        menuItem.view = hostingView

        return menuItem
    }
        
}
