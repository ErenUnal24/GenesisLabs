//
//  SettingsView.swift
//  GeneSys
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOuted() async throws {
        // Burada AuthenticationManager'in doğru çalıştığından emin olun
        try await AuthenticationManager.shared.signOut()
    }

    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()

        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            List {
                Button("Çıkış Yap") {
                    // İlk olarak giriş ekranına yönlendir
                    showSignInView = true
               }
                Button("Şifre Değiştir") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            alertMessage = "Şifre sıfırlama e-postası gönderildi."
                            showingAlert = true
                        } catch {
                            alertMessage = "Şifre sıfırlanamadı: \(error.localizedDescription)"
                            showingAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Bilgi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
        .background(
            NavigationLink(destination: SignInEmailView(showSignInView: $showSignInView), isActive: $showSignInView) {
                EmptyView()
            }
        )
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
