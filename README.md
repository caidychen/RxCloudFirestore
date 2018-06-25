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
We are designing a database for a collection of schools that have subcollections of courses, and these courses have subcollections of trainings. 
### Firestore database schema
```JSON
Schools <collection>{
    name: <String>,
    Courses <collection> {
        name: <String>,     
        startDate: <Int>             // Timestamp
        endDate: <Int> 
        Trainings <collection> {
            date: <Int>         // Timestamp
        }
    }
}
```  

### Setup your model
Conform to both FirestoreCollection & SnapshotCodable Protocols, and implement 2 things as below:
1. Supply your collection name as defined in your Firestore console (If it is a subcollection, just use the name of the subcollection and ignore the whole path. We will get into building full subcollection path later). 
2. Implement the key as constant because it is internally handled by Firestore and should be read-only.

```swift
struct Users: FirestoreCollection, SnapshotCodable {

    static let collectionName = "users"  // 1
    let key: String                      // 2
    
    var firstName: String
    var lastName: String
    var age: Int
    
}
```
