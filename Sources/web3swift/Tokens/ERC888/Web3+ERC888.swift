//
//  Web3+ERC888.swift
//
//  Created by Anton Grigorev on 15/12/2018.
//  Copyright © 2018 The Matter Inc. All rights reserved.
//

import Foundation
import BigInt
import Core

// MultiDimensional Token Standard
protocol IERC888 {
    func getBalance(account: EthereumAddress) async throws -> BigUInt
    func transfer(from: EthereumAddress, to: EthereumAddress, amount: String) async throws -> WriteOperation
}

// FIXME: Rewrite this to CodableTransaction
public class ERC888: IERC888, ERC20BaseProperties {

    internal var _name: String? = nil
    internal var _symbol: String? = nil
    internal var _decimals: UInt8? = nil
    internal var _hasReadProperties: Bool = false

    public var transactionOptions: CodableTransaction
    public var web3: web3
    public var provider: Web3Provider
    public var address: EthereumAddress
    public var abi: String

    lazy var contract: web3.Contract = {
        let contract = self.web3.contract(self.abi, at: self.address, abiVersion: 2)
        precondition(contract != nil)
        return contract!
    }()

    public init(web3: web3, provider: Web3Provider, address: EthereumAddress, abi: String = Web3.Utils.erc888ABI, transaction: CodableTransaction = .emptyTransaction) {
        self.web3 = web3
        self.provider = provider
        self.address = address
        self.transactionOptions = transaction
        self.transactionOptions.to = address
        self.abi = abi
    }

    public func getBalance(account: EthereumAddress) async throws -> BigUInt {
        let contract = self.contract
        var transactionOptions = CodableTransaction.emptyTransaction
        transactionOptions.callOnBlock = .latest
        let result = try await contract.createReadOperation("balanceOf", parameters: [account] as [AnyObject], extraData: Data(), transactionOptions: self.transactionOptions)!.decodedData()
        guard let res = result["0"] as? BigUInt else {throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node")}
        return res
    }

    public func transfer(from: EthereumAddress, to: EthereumAddress, amount: String) async throws -> WriteOperation {
        let contract = self.contract
        var basicOptions = CodableTransaction.emptyTransaction
        basicOptions.from = from
        basicOptions.to = self.address
        basicOptions.callOnBlock = .latest

        // get the decimals manually
        let callResult = try await contract.createReadOperation("decimals", transactionOptions: basicOptions)!.decodedData()
        var decimals = BigUInt(0)
        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
            throw Web3Error.inputError(desc: "Contract may be not ERC20 compatible, can not get decimals")}
        decimals = decTyped

        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }
        let tx = contract.createWriteOperation("transfer", parameters: [to, value] as [AnyObject], transactionOptions: basicOptions)!
        return tx
    }

}
