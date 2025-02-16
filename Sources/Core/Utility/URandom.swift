//
//  File.swift
//  
//
//  Created by Ronald Mannak on 10/29/22.
//

import Foundation
#if canImport(libc)
import libc


///// URandom represents a file connection to /dev/urandom on Unix systems.
///// /dev/urandom is a cryptographically secure random generator provided by the OS.
//public final class URandom: RandomProtocol {
//    public enum Error: Swift.Error {
//        case open(Int32)
//        case read(Int32)
//    }
//
//    private let file: UnsafeMutablePointer<FILE>
//
//    /// Initialize URandom
//    public init(path: String) throws {
//        guard let file = fopen(path, "rb") else {
//            // The Random protocol doesn't allow init to fail, so we have to
//            // check whether /dev/urandom was successfully opened here
//            throw Error.open(errno)
//        }
//        self.file = file
//    }
//
//    deinit {
//        fclose(file)
//    }
//
//    private func read(numBytes: Int) throws -> [Int8] {
//
//
//        // Initialize an empty array with space for numBytes bytes
//        var bytes = [Int8](repeating: 0, count: numBytes)
//        guard fread(&bytes, 1, numBytes, file) == numBytes else {
//            // If the requested number of random bytes couldn't be read,
//            // we need to throw an error
//            throw Error.read(errno)
//        }
//
//        return bytes
//    }
//
//    /// Get a random array of Bytes
//    public func bytes(count: Int) throws -> Bytes {
//        return try read(numBytes: count).map({ Byte(bitPattern: $0) })
//    }
//}
//
//extension URandom: EmptyInitializable {
//    public convenience init() throws {
//        try self.init(path: "/dev/urandom")
//    }
//}

#endif


extension Data {
    /// Returns cryptographically secure random data.
    /// Not safe. Needs to be replaced. See https://forums.swift.org/t/random-data-uint8-random-or-secrandomcopybytes/56165
    ///
    /// - Parameter length: Length of the data in bytes.
    /// - Returns: Generated data of the specified length.
    public static func random(length: Int) throws -> Data {
        return Data((0 ..< length).map { _ in UInt8.random(in: UInt8.min ... UInt8.max) })
    }
}
