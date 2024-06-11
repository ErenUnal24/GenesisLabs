//
//  UserDataManager.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation
import Firebase

class UserDataManager: ObservableObject {
    @Published var users: [Users] = []


func fetchUsers() {
    users.removeAll()
    let db = Firestore.firestore()
    let ref = db.collection("Users")
    ref.getDocuments{ snapshot, error in
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let name               = data["name"] as? String ?? ""
                    let email              = data["email"] as? String ?? ""
                    let userTypeString     = data["userType"] as? String ?? ""
                    let userType           = Users.UserType.UserTypeEnum(rawValue: userTypeString) ?? .danisma
                    
                    let user = Users(id: UUID(), documentID: documentID, general: Users.General(name: name, email: email), userType: Users.UserType(userType: userType))
                    
                        DispatchQueue.main.async {
                            self.users.append(user)
                        }
                }
            }
        }
    }
    
    func addUser(_ user: Users) {
        let db = Firestore.firestore()
        db.collection("Users").addDocument(data: [
            "name": user.general.name,
            "email": user.general.email,
            "userType": user.userType.userType.rawValue])
    }
    
    
    func deleteUser(_ user: Users) {
        guard let documentID = user.documentID else {
                print("Document ID is nil")
                return
            }
        let db = Firestore.firestore()
            db.collection("Users").document(documentID).delete
            { error in
                if let error = error {
                    print("Error deleting patient: \(error)")
                    
                } else {
                    print("Patient deleted successfully")
                }
            }
        }
    
    
    
    
    
    
}
