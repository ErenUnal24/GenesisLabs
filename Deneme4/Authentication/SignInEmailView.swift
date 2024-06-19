//
//  SignInEmailView.swift
//  Deneme4
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showSheet: Bool = false
    @State private var resetPasswordSheet: Bool = false
    @State private var isSendPasswordAlertShown: Bool = false
    @State private var isUserSignedIn: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                           startPoint: .topLeading,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 50)
                
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 220)
                    
                    Text("GeneSys")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    TextField("Mail Adresi...", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Şifre...", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                // GİRİŞ
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            isUserSignedIn = true
                        } catch {
                            print("Sign In Error: \(error)")
                        }
                    }
                } label: {
                    Text("Giriş")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                // Şifremi Unuttum Butonu
                Button(action: {
                    resetPasswordSheet.toggle()
                }, label: {
                    Text("Şifremi Unuttum")
                        .font(.headline)
                        .foregroundColor(.blue)
                })
                .sheet(isPresented: $resetPasswordSheet, content: {
                    ResetPasswordView(viewModel: viewModel)
                })
                
                Spacer()
                
                // Hasta Girişi Butonu
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    Text("Hasta Girişi")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                })
                .sheet(isPresented: $showSheet, content: {
                    SignInPatientView(showSignInView: $showSignInView, item: .emptyPatient)
                })
                
                Spacer()
                
                // WhatsApp
                HStack {
                    Image("wp")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("İletişim: +90 555 555 5555")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                    .frame(height: 20)
            }
            .padding(20)
            .background(
                NavigationLink(destination: destinationView(), isActive: $isUserSignedIn) {
                    EmptyView()
                }
            )
        }
        .navigationBarHidden(true) // Navigation Bar'ı gizle
        .background(
            LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                           startPoint: .topLeading,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if let userType = viewModel.userType {
            switch userType {
            case .danisma:
                MainTabView()
            case .numuneKabul:
                SampleTabView()
            case .laborant:
                LabTabView()
            case .biyolog:
                BiologTabView()
            case .uzman:
                ExpertTabView()
            case .admin:
                AdminView()
            }
        } else {
            Text("Kullanıcı türü belirlenemedi.")
                .foregroundColor(.red)
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
