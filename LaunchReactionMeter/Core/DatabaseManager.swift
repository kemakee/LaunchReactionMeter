//
//  DatabaseManager.swift
//  LaunchReactionMeter
//
//  Created by Adam Horvath on 2018. 05. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Firebase

class DatabaseManager: NSObject {

    static let shared = DatabaseManager()
    let db: Firestore

    private override init() {
        db = Firestore.firestore()
    }

    func addResult(result: Double) {
        let date = Date()
        var ref: DocumentReference? = nil
        ref = db.collection("results").addDocument(data: [
            "email": Auth.auth().currentUser!.email!,
            "result": result,
            "date": date
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

    }

    func readResults(completion: @escaping (([UserResult]) -> ()))
    {
        db.collection("results").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var results = [UserResult]()
                var result: UserResult!
                var data: [String: Any]!
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    data = document.data()
                    result = UserResult()
                    result.date = data["date"] as! Date
                    result.result = data["result"] as! Double
                    results.append(result)
                }

                completion(results.sorted(by: { (first, second) -> Bool in
                    first.date! > second.date!
                }))
            }
        }
    }

}
