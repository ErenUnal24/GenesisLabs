//
//  SignUpView.swift
//  Deneme4
//
//  Created by Eren on 17.06.2024.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel: SignInEmailViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Mail Adresi...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .autocapitalization(.none) // Sadece küçük harflerle yazılmasını sağlar

            
            SecureField("Şifre...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Yeniden Şifre...", text: $viewModel.confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Kayıt")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignInEmailViewModel(), showSignInView: .constant(false))
    }
}
