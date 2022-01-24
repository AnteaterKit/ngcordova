import ReplayKit
import UIKit

@available(iOS 10.0, *)
class BroadcastController : RPBroadcastController {
    // using this singleton to store a single instance of a broadcastcontroller
    static let controller = BroadcastController()
}

@objc(VideoCast) class VideoCast CDVPlugin {
    
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
    
    @objc(startCast:)
    func startCast(_ command: CDVInvokedUrlCommand) {
         let pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: "startCast")
         self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
    }


    func loadFileFromLocalPath(_ localFilePath: String) ->Data? {
        return try? Data(contentsOf: URL(fileURLWithPath: localFilePath))
    }

}