//
//  SignInEmailViewModel.swift
//  GeneSys
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
    
    // Enum for authentication errors
        enum AuthenticationError: LocalizedError {
            case missingEmailOrPassword
            case passwordsDoNotMatch
            case signInFailed
            case resetPasswordFailed
            case fetchUserTypeFailed
            
            var errorDescription: String? {
                switch self {
                case .missingEmailOrPassword:
                    return "Email ve Parola Boş Olamaz!"
                case .passwordsDoNotMatch:
                    return "Şifreler Eşleşmiyor!"
                case .signInFailed:
                    return "Oturum açma başarısız oldu. Lütfen kimlik bilgilerinizi kontrol edin!"
                case .resetPasswordFailed:
                    return "Failed to reset password."
                case .fetchUserTypeFailed:
                    return "Failed to fetch user type."
                }
            }
        }
    
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthenticationError.missingEmailOrPassword
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
            // Kullanıcı türünü al
            try await fetchUserType()
        } catch {
            throw AuthenticationError.signInFailed // Herhangi bir hata oluşursa dışarıya fırlat
        }
    }

    
    func resetPassword() async throws {
        guard !email.isEmpty else {
            throw AuthenticationError.missingEmailOrPassword
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
