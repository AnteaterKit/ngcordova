import ReplayKit
import UIKit

@available(iOS 10.0, *)
class BroadcastController : RPBroadcastController {
    // using this singleton to store a single instance of a broadcastcontroller
    static let controller = BroadcastController()
}

@objc(ScreenCast) class ScreenCast : RPBroadcastSampleHandler, CDVPlugin, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate, RPBroadcastActivityViewControllerDelegate {
    
    weak var previewViewController: RPPreviewViewController?
    var CDVWebview:UIWebView;

    // This is just called if <param name="onload" value="true" /> in plugin.xml.
    init(webView: UIWebView) {
        self.CDVWebview = webView
        //super.init(webView: webView)
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewViewController?.dismiss(animated: true)
    }
    
    @objc(isBroadcasting:)
    func isBroadcasting(_ command: CDVInvokedUrlCommand) {
        var recording = false;
        if #available(iOS 10.0, *) {
            recording = BroadcastController.controller.isBroadcasting
        }
        let pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: recording)
        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
    }
    
    weak var broadcastCommand:CDVInvokedUrlCommand?
    @objc(startBroadcast:)
    func startBroadcast(_ command: CDVInvokedUrlCommand) {
        if #available(iOS 10.0, *) {
            // pass the cordova command to broadcastactivityviewcontroller
            self.broadcastCommand = command;
            RPBroadcastActivityViewController.load { broadcastAVC, error in
                guard error == nil else {
                    print("Cannot load Broadcast Activity View Controller.")
                    var pluginResult:CDVPluginResult
                    pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: error?.localizedDescription)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    return
                }
                if let broadcastAVC = broadcastAVC {
                    broadcastAVC.delegate = self
                    self.viewController.present(broadcastAVC, animated: true, completion: {
                        // broadcastactivityviewcontroller will perform the callback when the broadcast starts (or fails)
                    })
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController,
                                         didFinishWith broadcastController: RPBroadcastController?,
                                         error: Error?)
    {
        let command = self.broadcastCommand;
        guard error == nil else {
            broadcastActivityViewController.dismiss(animated: true)
            print(error?.localizedDescription ?? "Broadcast Activity Controller is not available.")
            var pluginResult:CDVPluginResult
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: error?.localizedDescription)
            self.commandDelegate!.send(pluginResult, callbackId:command?.callbackId)
            return
        }
        broadcastActivityViewController.dismiss(animated: true) {
            broadcastController?.startBroadcast { error in
                if error == nil {
                    print("Broadcast started successfully!")
                    var pluginResult:CDVPluginResult
                    pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
                    self.commandDelegate!.send(pluginResult, callbackId:command?.callbackId)
                } else {
                    var pluginResult:CDVPluginResult
                    pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: error?.localizedDescription)
                    self.commandDelegate!.send(pluginResult, callbackId:command?.callbackId)
                }
            }
        }
    }
    override public func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
      self.commandDelegate!.evalJs("console.log('hello js')")
    }

    @objc(stopBroadcast:)
    func stopBroadcast(_ command: CDVInvokedUrlCommand) {
        if #available(iOS 10.0, *) {
            let controller = BroadcastController.controller;
            controller.finishBroadcast { error in
                if error == nil {
                    print("Broadcast ended")
                    var pluginResult:CDVPluginResult
                    pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
                    pluginResult.setKeepCallbackAs(true)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                } else {
                    var pluginResult:CDVPluginResult
                    pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: error?.localizedDescription)
                    pluginResult.setKeepCallbackAs(true)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            }
        }
    }
}