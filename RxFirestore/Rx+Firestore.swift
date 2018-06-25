//
//  Rx+Firestore.swift
//  DonationPointMe
//
//  Created by KD Chen on 22/6/18.
//  Copyright © 2018 Quest Payment Systems. All rights reserved.
//

import RxSwift
import FirebaseCore
import FirebaseFirestore

extension Reactive where Base: Firestore {
    
    /**
     Get a single event for a collection of documents.
     */
    func get<T: SnapshotCodable>(_ collectionPath: TypedCollectionPath<T>) -> Single<[T]> {
        return Single.create{observer in
            collectionPath.0.getDocuments(source: .cache, completion: { (snapshot, error) in
                guard let snapshot = snapshot?.documents else {
                    if let error = error {
                        observer(.error(error))
                    }
                    return
                }
                observer(.success(snapshot.compactMap{T.createFromDictionary($0.data(), key: $0.documentID)}))
            })
            return Disposables.create()
        }
    }
    
    /**
     Get a single event for a single document.
     */
    func get<T: SnapshotCodable>(_ documentPath: TypedDocumentPath<T>) -> Single<T?> {
        return Single.create{observer in
            documentPath.0.getDocument(source: .cache, completion: { (snapshot, error) in
                guard let snapshot = snapshot else {
                    if let error = error {
                        observer(.error(error))
                    }
                    return
                }
                observer(.success(T.createFromDictionary(snapshot.data(), key: snapshot.documentID)))
            })
            return Disposables.create()
        }
    }
    
    /**
     Observe a stream of events for a collection of documents.
     */
    func observe<T: SnapshotCodable>(_ collectionPath: TypedCollectionPath<T>) -> Observable<[T]> {
        return Observable<[DocumentSnapshot]>.create({ observer in
            let handler = collectionPath.0.addSnapshotListener {(snapshot, error) in
                guard let snapshot = snapshot?.documents else {
                    if let error = error {
                        observer.onError(error)
                    }
                    return
                }
                observer.onNext(snapshot)
            }
            return Disposables.create{
                handler.remove()
            }
        }).map({ (snapshotList) in
            return snapshotList.compactMap{T.createFromDictionary($0.data(), key: $0.documentID)}
        })
    }
    
    /**
     Observe a stream of events for a single document.
     */
    func observe<T: SnapshotCodable>(_ documentPath: TypedDocumentPath<T>) -> Observable<T?> {
        return Observable<DocumentSnapshot>.create({ observer in
            let handler = documentPath.0.addSnapshotListener {(snapshot, error) in
                guard let snapshot = snapshot else {
                    if let error = error {
                        observer.onError(error)
                    }
                    return
                }
                observer.onNext(snapshot)
            }
            return Disposables.create{
                handler.remove()
            }
        }).map{T.createFromDictionary($0.data(), key: $0.documentID)}
    }
    
    /**
     Get a single event for updating an item.
     */
    func update<T: FirestoreCollection & SnapshotCodable>(_ item: T) -> Single<()>? {
        guard let dic = item.JSONDictionary else {return nil}
        return Single.create{observer in
            T.documentPath(typed: T.self, key: item.key).0.updateData(dic) { error in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     Get a single event for setting an item.
     */
    func set<T: FirestoreCollection & SnapshotCodable>(_ item: T) -> Single<()>? {
        guard let dic = item.JSONDictionary else {return nil}
        return Single.create{observer in
            T.documentPath(typed: T.self, key: item.key).0.setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }
}
