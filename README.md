# RxCloudFirestore

RxCloudFirestore is an Rx wrapper around iOS Firestore API that works seamlessly with Codable Protocol in Swift 4.0. The aim of making this library is to improve the developer experience of Google Firestore for those who are already familiar with RxSwift Frameworks.

#### Please note
This library is still work-in-progress. Any suggestions or issue reports are welcomed!

## Features
- [x] Get a single event for a single document or a collection of documents.
- [x] Observe a stream of events for a single document or a collection of documents.
- [x] Get a single event for updating an item.
- [x] Get a single event for setting an item.

## Examples
### Setup your model
Conform to both FirestoreCollection & SnapshotCodable Protocols, and implement 2 things as below:
1. Provide your collection name as defined in your Firestore console (If it is a sub-collection, just use the name of the sub-collection and ignore the whole path. We will get into building full sub-collection path later). 
2. Implement the key as constant because it is internally handled by Firestore and should be read-only.

```swift
struct Users: FirestoreCollection, SnapshotCodable {

    static let collectionName = "users"
    let key: String
    
    var firstName: String
    var lastName: String
    var age: Int
    
}
```
