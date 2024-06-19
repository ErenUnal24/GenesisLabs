//
//  UserDataManager.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation
import Firebase

class UserDataManager: ObservableObject {
    @Published var users: [User] = []

    func fetchUsers() {
        users.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let userTypeString = data["userType"] as? String ?? ""
                    let userType = User.UserType.UserTypeEnum(rawValue: userTypeString) ?? .danisma
                    
                    let user = User(id: UUID(), documentID: documentID, general: User.General(name: name, email: email), userType: User.UserType(userType: userType))
                    
                    DispatchQueue.main.async {
                        self.users.append(user)
                    }
                }
            }
        }
    }
    
    func addUser(_ user: User) {
        let db = Firestore.firestore()
        db.collection("Users").addDocument(data: [
            "name": user.general.name,
            "email": user.general.email,
            "userType": user.userType.userType.rawValue
        ])
    }
    
    func deleteUser(_ user: User) {
        guard let documentID = user.documentID else {
            print("Document ID is nil")
            return
        }
        let db = Firestore.firestore()
        db.collection("Users").document(documentID).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            } else {
                print("User deleted successfully")
                DispatchQueue.main.async {
                    if let index = self.users.firstIndex(where: { $0.documentID == documentID }) {
                        self.users.remove(at: index)
                    }
                }
            }
        }
    }
    
    
    
    
    func addUserWithEmailPassword(_ user: User, password: String) async throws {
            let authResult = try await Auth.auth().createUser(withEmail: user.general.email, password: password)
            let db = Firestore.firestore()
        try await db.collection("Users").document(authResult.user.uid).setData([
                "name": user.general.name,
                "email": user.general.email,
                "userType": user.userType.userType.rawValue
            ])
            DispatchQueue.main.async {
                self.users.append(user)
            }
        }
        
       
}
