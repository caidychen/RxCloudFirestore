# RxCloudFirestore
RxCloudFirestore is an RxSwift wrapper around iOS Firestore API that works seamlessly with Codable Protocol in Swift 4.0. 

#### Please note
This library is still work-in-progress. Any suggestions or issue reports are welcomed!

## Features
- [x] Get a single event for a single document or a collection of documents.
- [x] Observe a stream of events for a single document or a collection of documents.
- [x] Get a single event for updating an item.
- [x] Get a single event for setting an item.

## Requirements
- Swift 4.0
- Google Firestore (https://firebase.google.com/docs/firestore/)
- RxSwift (https://github.com/ReactiveX/RxSwift)

## Examples
Let's start off by defining a simple data structure. 
Assuming we are designing a database for a collection of schools that have subcollections of courses:
### Firestore database schema
We will use <>{...} to annotate a collection type that follows a collection name.
```XML

schools <> {
    name: "",
    courses <> {
        name: "",     
        startDate: 0,    // Timestamp
        endDate: 0,      // Timestamp
    }
}

```  

### Setup your model
Conform to both **FirestoreCollection** & **SnapshotCodable** Protocols, and implement 2 things as below:
1. Supply your collection name as defined in your Firestore console (If it is a subcollection, just use the name of the subcollection and ignore the whole path. We will get into building full subcollection path later). 
2. Implement the key as constant because it is internally handled by Firestore and should be read-only.

```swift

struct School: FirestoreCollection, SnapshotCodable {

    static let collectionName = "schools"   // 1
    let key: String                         // 2
    
    var name: String
}

struct Course: FirestoreCollection, SnapshotCodable {

    static let collectionName = "courses"   // 1
    let key: String                         // 2
    
    var name: String
    var startDate: Int
    var endDate: Int
}

```

### Observe a collection of schools
```swift

GoogleFirestore.firestore().rx
    .observe(School.collection(), School.self)
    .subscribe(onNext: { allSchools in
        allSchools.forEach({ school in
            print(school)     
        })
    })
    .disposed(by: disposeBag)
    
```
If you want to combine the path with a query, just append Firestore query functions as usual: 
```swift

GoogleFirestore.firestore().rx
    .observe(School.collection().whereField("name", isEqualTo: "MIT"), School.self)
    .subscribe(onNext: { allSchools in
        allSchools.forEach({ school in
            print(school)     
        })
    })
    .disposed(by: disposeBag)
    
```

### Observe a specific school 
```swift

let key = "FirebaseID"

GoogleFirestore.firestore().rx
    .observe(School.document(key: key), School.self)
    .subscribe(onNext: {school in
        print(school)
    })
    .disposed(by: disposeBag)
    
```

### Query a subcollection of courses from a speicfic school
Chain your collection path and document path together like an **alternating pattern** to "navigate" through subcollections: 
*Collection(odd) -> Document(even) -> Collection(odd)*

```swift

// Return a specific document from a subcollection from its parent document
   
GoogleFirestore.firestore().rx
    .observe(
        School.collection()
              .document(key: "SchoolID")
              .subcollection(Course.self)
              .document(key: "CourseID"), 
        Course.self
    )
    .subscribe(onNext: {course in
        print(course)
    })
    .disposed(by: disposeBag)
```

```swift

// Return an entire subcollection from its parent document
    
GoogleFirestore.firestore().rx
    .observe(
        School.collection()
              .document(key: "SchoolID")
              .subcollection(Course.self), 
        Course.self
     )
    .subscribe(onNext: { allCourses in
        allCourses.forEach({ course in
            print(course)     
        })
    })
    .disposed(by: disposeBag)
    
```
