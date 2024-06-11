//
//  AddUserViewModel.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation

final class AddUserViewModel: ObservableObject {
    
    var dataManager = UserDataManager()
    
    @Published var newUser: Users = .emptyUser
    
    var isValid: Bool {
        !newUser.general.name.isEmpty &&
        !newUser.general.email.isEmpty &&
        !newUser.userType.userType.rawValue.isEmpty
    }
    
    func clearAll() {
        self.newUser = .emptyUser
    }
    
    
    func saveUser() {
        dataManager.addUser(newUser)
    }
    
   
    
    func deleteUser() {
            dataManager.deleteUser(newUser)
            
        }

}
