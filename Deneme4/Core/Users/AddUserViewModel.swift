//
//  AddUserViewModel.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

// AddUserViewModel.swift

import Foundation

final class AddUserViewModel: ObservableObject {
    
    var dataManager = UserDataManager()
    
    @Published var newUser: User = .emptyUser
    @Published var password: String = ""
    
    var isValid: Bool {
        !newUser.general.name.isEmpty &&
        !newUser.general.email.isEmpty &&
        !newUser.userType.userType.rawValue.isEmpty &&
        !password.isEmpty
    }
    
    func clearAll() {
        self.newUser = .emptyUser
        self.password = ""
    }
    
    func saveUser() {
        Task {
            do {
                try await dataManager.addUserWithEmailPassword(newUser, password: password)
            } catch {
                print("Error creating user: \(error)")
            }
        }
    }
    
    func deleteUser() {
        dataManager.deleteUser(newUser)
    }
}
