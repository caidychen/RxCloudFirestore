//
//  FirestoreOperators.swift
//  DonationPointMe
//
//  Created by KD Chen on 25/6/18.
//  Copyright © 2018 Quest Payment Systems. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore

infix operator ~> : AdditionPrecedence
infix operator ~>> : AdditionPrecedence

func ~> (lhs: DocumentReference, rhs: DocumentReference) -> DocumentReference{
    let newPath = lhs.path + "/" + rhs.path
    return Firestore.firestore().document(newPath)
}

func ~>> (lhs: DocumentReference, rhs: CollectionReference) -> CollectionReference{
    let newPath = lhs.path + "/" + rhs.path
    return Firestore.firestore().collection(newPath)
}
