//  SignInEmailView.swift
//  GeneSys
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI

struct SignInEmailView: View {

    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool

    @State private var resetPasswordSheet: Bool = false
    @State private var isUserSignedIn: Bool = false

    @Environment(\.dismiss) var dismiss

    @State private var destination: DestinationType?
    @State private var showSheet: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false



    enum DestinationType {
        case mainTabView
        case sampleTabView
        case labTabView
        case biologTabView
        case expertTabView
        case adminView
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 10)
                    
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
                        .frame(height: 10)
                    
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
                                
                                // YÖNLENDİRME BURADA
                                setDestination()
                                
                            } catch {
                                print("Sign In Error: \(error)")
                                
                                 errorMessage = "\(error.localizedDescription)"
                                showErrorAlert = true

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
                    .navigationDestination(isPresented: $isUserSignedIn) {
                        destinationView()
                            .navigationBarBackButtonHidden(true)
                    }
                    .alert(isPresented: $showErrorAlert){
                        Alert(title: Text("Hata"), message: Text(errorMessage),dismissButton: .default(Text("Tamam")))
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
                        .frame(height: 1)
                    
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
                        SignInPatientView(showSignInView: $showSignInView)
                    })
                    
                    Spacer()
                    
                    //Whatsapp İletişin
                    HStack {
                        Image("wp")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("İletişim: +90 555 555 5555")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                        .frame(height: 10)
                    
                }
                .padding(10)
            }
            .navigationBarHidden(true) // Navigation Bar'ı gizle
            .background(
                LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }

    private func setDestination() {
        if let userType = viewModel.userType {
            switch userType {
            case .danisma:
                destination = .mainTabView
            case .numuneKabul:
                destination = .sampleTabView
            case .laborant:
                destination = .labTabView
            case .biyolog:
                destination = .biologTabView
            case .uzman:
                destination = .expertTabView
            case .admin:
                destination = .adminView
            }
        } else {
            // Handle nil userType if needed
            destination = nil
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        if let destination = destination {
            switch destination {
            case .mainTabView:
                MainTabView()
            case .sampleTabView:
                SampleTabView()
            case .labTabView:
                LabTabView()
            case .biologTabView:
                BiologTabView()
            case .expertTabView:
                ExpertTabView()
            case .adminView:
                AdminView()
            }
        } else {
            // DefaultView or any other fallback view if destination is nil
            Text("Kullanıcı türü belirlenemedi.")
                .foregroundColor(.red) // Adjust appearance as needed
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
