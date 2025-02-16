//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3.Eth {
    public func getTransactionCount(for address: EthereumAddress, onBlock: BlockNumber = .latest) async throws -> BigUInt {
        let requestCall: APIRequest = .getTransactionCount(address.address, onBlock)
        return try await APIRequest.sendRequest(with: self.provider, for: requestCall).result
    }
}
