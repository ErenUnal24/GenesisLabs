//
//  ResetPasswordView.swift
//  Deneme4
//
//  Created by Eren on 17.06.2024.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @ObservedObject var viewModel: SignInEmailViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var isSendPasswordAlertShown: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                
                
                TextField("Mail Adresinizi Giriniz", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            isSendPasswordAlertShown.toggle()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Yeni Şifre Gönder")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .alert(isPresented: $isSendPasswordAlertShown, content: {
                    Alert(title: Text("Mail adresinize şifre yenileme maili gönderildi."), dismissButton: .cancel(Text("Done"), action: {
                        dismiss()
                    }))
                })
                
            }
        }
        
    }
    
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(viewModel: SignInEmailViewModel())
    }
}

