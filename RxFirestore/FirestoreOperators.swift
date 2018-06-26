//
//  FirestoreOperators.swift
//  DonationPointMe
//
//  Created by KD Chen on 25/6/18.
//  Copyright © 2018 Quest Payment Systems. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore

extension CollectionReference {
    func document(key: String) -> DocumentReference {
        let newPath = self.path + "/" + key
        return Firestore.firestore().document(newPath)
    }
}

extension DocumentReference {
    func subcollection(_ name: FirestoreCollection.Type) -> CollectionReference {
        let newPath = self.path + "/" + name.collectionName
        return Firestore.firestore().collection(newPath)
    }
}
