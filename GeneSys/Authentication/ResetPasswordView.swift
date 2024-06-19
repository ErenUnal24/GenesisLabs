//
//  ResetPasswordView.swift
//  GeneSys
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
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Text("Şifremi Unuttum")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    
                    
                    TextField("", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .placeholder(when: viewModel.email.isEmpty) {
                            Text("  Mail Adresinizi Giriniz..")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    
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
    
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(viewModel: SignInEmailViewModel())
    }
}

