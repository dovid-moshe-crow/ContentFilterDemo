//
//  FilterControlProvider.swift
//  ContentFilter
//
//  Created by Sheshnath Kumar on 21/12/18.
//  Copyright © 2018 Demo Technologies. All rights reserved.
//

import NetworkExtension

class FilterControlProvider: NEFilterControlProvider {

    public static let defaults = UserDefaults(suiteName: "7J3EXH6427.group.com.demo.ContentFilterDemoApp")
    override init() {
        super.init()
        self.remediationMap = [
            NEFilterProviderRemediationMapRemediationURLs: [
                FilterUtilities.remediationURLMapKey: FilterUtilities.remediationURL as NSString
            ],
            NEFilterProviderRemediationMapRemediationButtonTexts: [
                FilterUtilities.remediationButtonMapKey: FilterUtilities.remediationButtonText as NSString
            ]
        ]
        FilterUtilities.fetchRulesFromServer(self.filterConfiguration.serverAddress)
    }
        
    /// Handle a new flow of network data
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        if FilterUtilities.shouldAllowAccess(flow) == true {
            completionHandler(NEFilterControlVerdict.allow(withUpdateRules: false))
        } else {
            completionHandler(NEFilterControlVerdict.drop(withUpdateRules: false))
        }
    }
}