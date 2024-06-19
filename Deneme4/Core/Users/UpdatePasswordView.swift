//
//  UpdatePasswordView.swift
//  Deneme4
//
//  Created by Eren on 17.06.2024.
//

// UpdatePasswordView.swift

import SwiftUI

struct UpdatePasswordView: View {
    
    @StateObject private var vm = UpdatePasswordViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                SecureField("Mevcut Şifre", text: $vm.currentPassword)
                    .textContentType(.password)
                
                SecureField("Yeni Şifre", text: $vm.newPassword)
                    .textContentType(.newPassword)
                
                SecureField("Yeni Şifreyi Onayla", text: $vm.confirmPassword)
                    .textContentType(.newPassword)
                
                Button("Şifreyi Güncelle") {
                    Task {
                        do {
                            try await vm.updatePassword()
                            print("Password updated successfully")
                        } catch {
                            print("Error updating password: \(error)")
                        }
                    }
                }
                .disabled(!vm.isValid)
            }
            .navigationTitle("Şifreyi Güncelle")
        }
    }
}

#Preview {
    UpdatePasswordView()
}
