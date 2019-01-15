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
class SECBlockJSAPI: NSObject {
    /// Singleton instance. Much more resource-friendly than creating multiple new instances.
    static let shared = SECBlockJSAPI()
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    @objc override init() {
        let jsCode = try? String.init(contentsOf: Bundle.main.url(forResource: "SECSDK.bundle", withExtension: "js")!)
        
        // Create a new JavaScript context that will contain the state of our evaluated JS code.
        self.context = JSContext(virtualMachine: self.vm)
        
        // Evaluate the JS code that defines the functions to be used later on.
        self.context.evaluateScript(jsCode)
    }
    
    /**
     Sign a tx
     
     - Parameters:
     - tx: The tx to txsign
     - completion: The block to be called on the main thread upon completion
     - value: The signed tx
     */
    @objc func txSign(_ tx: String, completion: @escaping (_ value: String) -> Void) {
        // Run this asynchronously in the background
        DispatchQueue.global(qos: .userInitiated).async {
            var Transaction = ""
            let jsModule = self.context.objectForKeyedSubscript("SECSDK")
            let TxSign = jsModule?.objectForKeyedSubscript("txSign")
            if let result = TxSign?.call(withArguments: [tx]) {
                Transaction = result.toString()
            }
            // Call the completion block on the main thread
            DispatchQueue.main.async {
                completion(Transaction)
            }
        }
    }
    
    @objc func privKeyToMnemonic(_ privKey: String, completion: @escaping (_ value: String) -> Void) {
        // Run this asynchronously in the background
        DispatchQueue.global(qos: .userInitiated).async {
            var Mnemonic = ""
            let jsModule = self.context.objectForKeyedSubscript("SECSDK")
            let entropyToMnemonic = jsModule?.objectForKeyedSubscript("entropyToMnemonic")
            
            if let result = entropyToMnemonic?.call(withArguments: [privKey]) {
                Mnemonic = result.toString()
            }
            // Call the completion block on the main thread
            DispatchQueue.main.async {
                completion(Mnemonic)
            }
        }
    }
    
    @objc func mnemonicToPrivKey(_ mnemonic: String, completion: @escaping (_ value: String) -> Void) {
        // Run this asynchronously in the background
        DispatchQueue.global(qos: .userInitiated).async {
            var privKey = ""
            let jsModule = self.context.objectForKeyedSubscript("SECSDK")
            let mnemonicToEntropy = jsModule?.objectForKeyedSubscript("mnemonicToEntropy")
            if let result = mnemonicToEntropy?.call(withArguments: [mnemonic]) {
                privKey = result.toString()
            }
            // Call the completion block on the main thread
            DispatchQueue.main.async {
                completion(privKey)
            }
        }
    }
}
