//
//  SignInEmailViewModel.swift
//  Deneme4
//
//  Created by Eren on 17.06.2024.
//

import Foundation
import Firebase

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var userType: User.UserType.UserTypeEnum!
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password must not be empty.")
            return
        }
        
        guard password == confirmPassword else {
            print("Passwords do not match.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    enum AuthenticationError: Error {
        case missingEmailOrPassword
        //case missingCurrentUser
    }
    
//    enum FetchUserTypeError: Error {
//        case invalidUserType
//        case userDocumentNotFound
//    }
//    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthenticationError.missingEmailOrPassword
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        // Kullanıcı türünü al
        try await fetchUserType()
    }
    
    func resetPassword() async throws {
        guard !email.isEmpty else {
            print("Email adresinizi giriniz.")
            return
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func fetchUserType() async throws {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.missingEmailOrPassword
        }
        
        let snapshot = try await db.collection("Users").whereField("email", isEqualTo: user.email ?? "").getDocuments()
        
        if let document = snapshot.documents.first {
            let data = document.data()
            if let userTypeString = data["userType"] as? String,
               let userType = User.UserType.UserTypeEnum(rawValue: userTypeString) {
                self.userType = userType
            }
        }
    }
    
//    
//    func fetchUserType() async throws {
//        let db = Firestore.firestore()
//        guard let user = Auth.auth().currentUser else {
//            throw AuthenticationError.missingCurrentUser
//        }
//        
//        let snapshot = try await db.collection("Users")
//            .whereField("email", isEqualTo: user.email ?? "")
//            .getDocuments()
//        
//        if let document = snapshot.documents.first {
//            let data = document.data()
//            if let userTypeString = data["userType"] as? String,
//               let userType = User.UserType.UserTypeEnum(rawValue: userTypeString) {
//                self.userType = userType
//            } else {
//                throw FetchUserTypeError.invalidUserType
//            }
//        } else {
//            throw FetchUserTypeError.userDocumentNotFound
//        }
//    }

    
}
