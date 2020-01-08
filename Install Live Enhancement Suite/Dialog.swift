//
//  Dialog.swift
//  Install Live Enhancement Suite
//
//  Created by James Morris on 05/01/2020.
//  Copyright © 2020 James Morris. All rights reserved.
//

import Cocoa

class Dialog: NSObject {
    static func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Continue")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }

    static func dialogError (error: Any) {
        let alert = NSAlert()
        alert.messageText = "An error occured during installation"
        alert.informativeText = error as! String
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Quit")
        alert.runModal()
        
    }
    
    static func dialogHammerspoonFound () {
        let alert = NSAlert()
        alert.messageText = "Hammerspoon instalation found"
        alert.informativeText = "Live Enhancement Suite is not currently compatible with hammerspoon. Please uninstall it before proceeding."
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Quit")
        alert.runModal()
    }
    
    static func dialogComfirmQuit (window: NSWindow, completion: @escaping (Bool)->()) {
        let alert = NSAlert()
        alert.messageText = "Instalation Incomplete"
        alert.informativeText = "The installation is amost compelte. Are you sure you want to exit?"
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Cancel Instalation")
        alert.addButton(withTitle: "Continue Instalation")
        alert.beginSheetModal(for: window, completionHandler: { result in
            completion(result == NSApplication.ModalResponse.alertFirstButtonReturn)
         })
    }
}
