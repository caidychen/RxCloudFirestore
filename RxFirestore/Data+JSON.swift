//
//  Data+JSON.swift
//  DonationPointMe
//
//  Created by KD Chen on 8/6/18.
//  Copyright © 2018 Quest Payment Systems. All rights reserved.
//

import Foundation

extension Data {
    var JSONDictonary: [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension Dictionary {
    var JSONData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
