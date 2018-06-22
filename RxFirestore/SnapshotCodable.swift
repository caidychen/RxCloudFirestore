//
//  SnapshotCodable.swift
//  DonationPointMe
//
//  Created by KD Chen on 8/6/18.
//  Copyright © 2018 Quest Payment Systems. All rights reserved.
//

import Foundation

protocol SnapshotCodable: Codable {
    var JSONData: Data? {get}
    var JSONDictionary: [String: Any]? {get}
    static func createFromJSONData(_ jsonData: Data) -> Self?
}

extension SnapshotCodable {
    var JSONData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // JSON reflection of original model without the firestore key
    var JSONDictionary: [String: Any]? {
        var dict = self.JSONData?.JSONDictonary ?? [:]
        dict["key"] = nil
        return dict
    }
    
    static func createFromJSONData(_ jsonData: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    static func createFromDictionary(_ dict: [String: Any]?, key: String?) -> Self? {
        guard let dict = dict, let key = key else {return nil}
        var dictWithFIRKey = dict
        dictWithFIRKey["key"] = key
        guard let jsonData = dictWithFIRKey.JSONData else {return nil}
        return createFromJSONData(jsonData)
    }
}

