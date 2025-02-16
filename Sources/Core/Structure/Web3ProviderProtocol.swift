//
//  Web3ProviderProtocol.swift
//  
//
//  Created by Yaroslav Yashin on 11.07.2022.
//

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Foundation

public protocol Web3Provider {
    var network: Networks? {get set}
    var attachedKeystoreManager: KeystoreManager? {get set}
    var url: URL {get}
    var session: URLSession {get}
}
