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
We will use <>{...} to annotate a collection type followed by a collection name.
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
Conform to both FirestoreCollection & SnapshotCodable Protocols, and implement 2 things as below:
1. Supply your collection name as defined in your Firestore console (If it is a subcollection, just use the name of the subcollection and ignore the whole path. We will get into building full subcollection path later). 
2. Implement the key as constant because it is internally handled by Firestore and should be read-only.

```swift

struct School: FirestoreCollection, SnapshotCodable {

    static let collectionName = "schools"  // 1
    let key: String                      // 2
    
    var name: String
}

struct Course: FirestoreCollection, SnapshotCodable {

    static let collectionName = "courses"  // 1
    let key: String                      // 2
    
    var name: String
    var startDate: Int
    var endDate: Int
}

```

### Observe a collection of schools
```swift

GoogleFirestore.firestore().rx
    .observe(School.collectionPath(), School.self)
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
    .observe(School.documentPath(key: key), School.self)
    .subscribe(onNext: {school in
        print(school)
    })
    .disposed(by: disposeBag)
    
```

### Observe a subcollection of courses from a speicfic school
We use special operators **~>** and **~>>** to "navigate" through subcollections and build the full path automatically.
```swift

// Return a specific document from a subcollection from its parent document
   let coursePath = School.documentPath(key: "SchoolID") ~> Course.documentPath(key: "CourseID")
   
   GoogleFirestore.firestore().rx
    .observe(coursePath, Course.self)
    .subscribe(onNext: {course in
        print(course)
    })
    .disposed(by: disposeBag)
```

```swift

// Return an entire subcollection from its parent document
    let courseCollectionPath = School.documentPath(key: "SchoolID") ~>> Course.collectionPath()
    
    GoogleFirestore.firestore().rx
    .observe(courseCollectionPath, Course.self)
    .subscribe(onNext: { allCourses in
        allCourses.forEach({ course in
            print(course)     
        })
    })
    .disposed(by: disposeBag)
    
```

You can of course chain the navigation however you like:
```swift

// Although I personally don't like the idea of having too many subcollections in Firestore, I will 
// still demonstrate the full capability of this library for educational purposes.

let schoolPath = School.documentPath(key: "SchoolID") 
let coursePath = Course.documentPath(key: "CourseID")
let studentPath = Student.documentPath(key: "StudentID")
let allReportPath = AcademicReport.collectionPath()

let combinedPath = (schoolPath ~> coursePath ~> studentPath) ~>> allReportPath

```
