
#if os(iOS)
import Foundation
import NetworkExtension

open class FilterUtilities {
    
    // MARK: Properties
    public static let defaults = UserDefaults(suiteName: "7J3EXH6427.group.com.demo.ContentFilterDemoApp")
    public static let remediationURLMapKey = "blockedContentURL"
    public static let remediationButtonMapKey = "blockedContentButton"
    public static let remediationButtonText = "Learn why KFilter blocked this site"
    public static let remediationURL = "https://maps.apple.com/?q=BlockedSite&address=\(NEFilterProviderRemediationURLFlowURLHostname)&ll=37.3349,-122.0090"
    open class func shouldAllowAccess(_ flow: NEFilterFlow) -> Bool {
        let hostname = FilterUtilities.getFlowHostname(flow)
        
        logw("host name is \(hostname)")

        if hostname == "www.google.com" || hostname.hasSuffix(".google.com") {
            return false
        }else{
            return true
        }
        //access to your app and certains url should be allowd handling
        if #available(iOS 11.0, *) {
            if let bundleId = flow.sourceAppIdentifier {
                logw("sourceAppIdentifier \(bundleId)")
                if bundleId == "4J82HMXY47.com.demo.ContentFilterDemoApp"{
                    return true
                }
            }
        } else {
            // Fallback on earlier versions
            let hostname = FilterUtilities.getFlowHostname(flow)
            logw("host name is \(hostname)")
            if hostname.isEmpty {
                return true
            }
            
            if hostname == "www.google.com" || hostname.hasSuffix(".google.com") {
                return false
            }else{
                return true
            }
            
            if hostname == "192.168.100.48" {
                return true //our own server url
            }
        }
        return defaults?.bool(forKey: "rules") ?? true
    }
    
    
    /// Get the hostname from a browser flow.
    open class func getFlowHostname(_ flow: NEFilterFlow) -> String {
        guard let browserFlow : NEFilterBrowserFlow = flow as? NEFilterBrowserFlow,
            let url = browserFlow.url,
            let hostname = url.host
            , flow is NEFilterBrowserFlow
            else { return "" }
        return hostname
    }
    
    
    open class func fetchRulesFromServer(_ serverAddress: String?) {
        guard serverAddress != nil else { return }
        guard let infoURL = URL(string: "\(serverAddress!)/api/v1/rules") else { return }
        let content: String
        do {
            content = try String(contentsOf: infoURL, encoding: String.Encoding.utf8)
        }
        catch {
            return
        }
        let utf8ShouldAllowAccess = String(utf8String: "ALLOW".cString(using: .utf8)!)
        if content ==  utf8ShouldAllowAccess{
            defaults?.setValue(true, forKey:"rules")
        }else{
            defaults?.setValue(false, forKey:"rules")
        }
    }
    
}

#endif
