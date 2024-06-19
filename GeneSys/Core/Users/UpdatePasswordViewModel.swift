//
//  UpdatePasswordViewModel.swift
//  GeneSys
//
//  Created by Eren on 17.06.2024.
//

// UpdatePasswordViewModel.swift

import Foundation
import FirebaseAuth

final class UpdatePasswordViewModel: ObservableObject {
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    var isValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        newPassword == confirmPassword
    }
    
    func updatePassword() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        
        try await user.reauthenticate(with: credential)
        try await user.updatePassword(to: newPassword)
    }
}
