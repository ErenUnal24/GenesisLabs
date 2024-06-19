//
//  SignInPatientView.swift
//  Deneme4
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct SignInPatientView: View {
    
    @StateObject private var viewModel = SignInPatientViewModel()
    @Binding var showSignInView: Bool
    
    @State private var isUserSignedIn: Bool = false
    
    
    let item: Patient
    @State private var navigateToPDFView: Bool = false


    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("TC Kimlik No...", text: $viewModel.tcNo)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                
                // GİRİŞ BUTONU
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
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Hasta Girişi")
            .padding(10)
            .background(
                NavigationLink(
                    destination: PatientPDFsView(patient: item),
                    isActive: $navigateToPDFView,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
        .background(
 //            Image("backgroundImage")
 //                .resizable()
 //                .aspectRatio(contentMode: .fill)
 //                .edgesIgnoringSafeArea(.all)
 //                .opacity(0.3)
         
         LinearGradient(gradient: Gradient(colors: [.topColor,.centerColor,.bottomColor]),
                                    startPoint: .topLeading,
                                    endPoint: .bottom)
                         .edgesIgnoringSafeArea(.all)
         )
    }
}

struct SignInPatientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInPatientView(showSignInView: .constant(false), item: .emptyPatient)
        }
    }
}
