//
//  SentimentAnalyzer.swift
//  Sentimentalist
//
//  Created by Yuan Li on 07.01.19.
//  Copyright © 2019 Yuan Li. All rights reserved.
//

import UIKit
import JavaScriptCore

/// An analyzer of sentiments
class SentimentAnalyzer: NSObject {
    /// Singleton instance. Much more resource-friendly than creating multiple new instances.
    static let shared = SentimentAnalyzer()
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    @objc override init() {
        let jsCode = try? String.init(contentsOf: Bundle.main.url(forResource: "Sentimentalist.bundle", withExtension: "js")!)
        
        // Create a new JavaScript context that will contain the state of our evaluated JS code.
        self.context = JSContext(virtualMachine: self.vm)
        
        // Evaluate the JS code that defines the functions to be used later on.
        self.context.evaluateScript(jsCode)
    }
    
    /**
     Analyze the sentiment of a given English sentence.
     
     - Parameters:
     - sentence: The sentence to analyze
     - completion: The block to be called on the main thread upon completion
     - value: The sentiment value
     */
    @objc func analyze(_ sentence: String, completion: @escaping (_ value: String) -> Void) {
        // Run this asynchronously in the background
        DispatchQueue.global(qos: .userInitiated).async {
            var value = ""
            let jsModule = self.context.objectForKeyedSubscript("Sentimentalist")
            let TxSign = jsModule?.objectForKeyedSubscript("TxSign")
            if let result = TxSign?.objectForKeyedSubscript("txSign").call(withArguments: [sentence]) {
                value = result.toString()
//                print(result)
            }
            // Call the completion block on the main thread
            DispatchQueue.main.async {
                completion(value)
            }
        }
    }
    
    /**
     Return the result from js file
     
     - Parameters:
     - value: The sentiment value
     
     - Returns: String the value
     */
    func display(forValue value: String) -> String {
        return value
    }
    
}
