//
//  AppDelegate.swift
//  Install Live Enhancement Suite
//
//  Created by James Morris on 05/01/2020.
//  Copyright © 2020 James Morris. All rights reserved.
//

import Cocoa
import Foundation

import SSZipArchive

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, URLSessionDownloadDelegate, NSWindowDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var status: NSTextField!


    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)

        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }


    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.progress.isIndeterminate = true
            self.progress.startAnimation(self)
            self.status.stringValue = "Installing..."
        }

        let destinationURL = try! FileManager.default.url(for: .applicationDirectory, in: .localDomainMask, appropriateFor: nil, create: true)

        let success: Bool = SSZipArchive.unzipFile(atPath: location.path,
                toDestination: destinationURL.path,
                preserveAttributes: true,
                overwrite: true,
                nestedZipLevel: 1,
                password: nil,
                error: nil,
                delegate: nil,
                progressHandler: nil,
                completionHandler: nil)


        if success != false {
            print("Success unzip")
            quit()
        } else {
            Dialog.dialogError(error: "Error code 101")
            quit()
        }
    }


// MARK: protocol stubs for tracking download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        let percentDownloaded = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100

        DispatchQueue.main.async {
            self.status.stringValue = "Downloading..."
            self.progress.isIndeterminate = false
            self.progress.doubleValue = Double(percentDownloaded)
        }
    }


    func updateProgress(value: Double) {
        DispatchQueue.main.async {
            self.progress.doubleValue = value
        }
    }

    func quit() {
        DispatchQueue.main.async {
            NSApplication.shared.terminate(self)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let archiveUrl: URL

        if #available(macOS 10.15, *) {
            archiveUrl = URL(string: "https://les302.now.sh/api")!
        } else {
            archiveUrl = URL(string: "https://les302.now.sh/api/legacy")!
        }

        if hammerspoonInstalled() {
            Dialog.dialogHammerspoonFound()
            quit()
        }

        window.delegate = self
        progress.startAnimation(self)
        window.setIsVisible(true)

        download(from: archiveUrl)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func hammerspoonInstalled() -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: "/Applications/Hammerspoon.app")
    }


    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        Dialog.dialogComfirmQuit(window: window, completion: { answer in
            if answer {
                self.quit()
            }
        }
        )
        return false
    }
}
