//
//  SignInEmailView.swift
//  Deneme4
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
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
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthenticationError.missingEmailOrPassword
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }

    
    func resetPassword() async {
        guard !email.isEmpty else {
            print("Email adresinizi giriniz.")
            return  // Burada fonksiyondan çıkış yapıyoruz
        }
        
        do {
            try await AuthenticationManager.shared.resetPassword(email: email)
            print("Password reset email sent")
        } catch {
            print("Failed to send password reset email: \(error)")
        }
    }


}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    @State var showSheet: Bool = false
    @State var resetPasswordSheet: Bool = false
    
    @State var isSendPasswordAlertShown: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("Mail Adresi...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Şifre...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
           
            
            //GİRİŞ BUTONU
           
            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                        
                        showSignInView = false
                    } catch {
                        print("Sign In Error: \(error)")
                    }
                }
                
            } label: {
                Text("Giriş")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
          
            
            //******* KAYIT BUTONU SHEET AÇAR
            Button(action: {
                showSheet.toggle()
            }, label: {
                Text("Kayıt")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                
            })
            .sheet(isPresented: $showSheet, content: {
                TextField("Mail Adresi...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
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
                            return
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
                
            })
            
              //*******
                
                //*******Şifremi Unuttum Butonu Sheet Açar
                  Button(action: {
                  resetPasswordSheet.toggle()
                  }, label: {
                  Text("Şifremi Unuttum")
                  .font(.headline)
                  .foregroundStyle(.white)
                  .frame(height: 30)
                  .frame(width: 150)
                  // .frame(maxWidth: .infinity)
                  .background(Color.blue)
                  .cornerRadius(10)
                  
                  })
                  .sheet(isPresented: $resetPasswordSheet, content: {
                  TextField("Mail Adresinizi Giriniz", text: $viewModel.email)
                  .padding()
                  .background(Color.gray.opacity(0.4))
                  .cornerRadius(10)
                  
                  Button {
                  Task {
                  do {
                  try await AuthenticationManager.shared.resetPassword(email: viewModel.email)
                  isSendPasswordAlertShown.toggle()
                  return
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
                  Alert(title: Text("Mail adresinize şifre yenileme maili gönderildi."), dismissButton: Alert.Button.cancel(Text("Done"), action: {
                  dismiss()
                  }))
                  })
                  
                  })
                  //*******
                    
                    
                    Spacer()
                    
                    }
                    .navigationTitle("Giriş Yap / Kayıt Ol")
                    .padding(10)
                    }
                    }
                    
                    
                    
                    
                    struct SignInEmailView_Previews: PreviewProvider {
                    static var previews: some View {
                        NavigationStack{
                            SignInEmailView(showSignInView: .constant(false))
                        }
                      }
                    }
                    

