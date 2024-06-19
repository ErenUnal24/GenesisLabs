//
//  AddUserView.swift
//  GeneSys
//
//  Created by Eren on 11.06.2024.
//

// AddUserView.swift

import SwiftUI

struct AddUserView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isAlertShown: Bool = false
    @StateObject private var vm = AddUserViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // General section
                Section(header: Text("Genel")) {
                    TextField("İsim", text: $vm.newUser.general.name)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                    
                    TextField("Email", text: $vm.newUser.general.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none) // Sadece küçük harflerle yazılmasını sağlar
                }
                
                // User type section
                Section(header: Text("User Türü")) {
                    Picker("User Tipi", selection: $vm.newUser.userType.userType) {
                        ForEach(User.UserType.UserTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                }
                
                // Password section
                Section(header: Text("Şifre")) {
                    SecureField("Şifre", text: $vm.password)
                        .textContentType(.newPassword)
                }
                
                Button("Hepsini Temizle", role: .destructive) {
                    vm.clearAll()
                }
            }
            .navigationTitle("User Kayıt")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        isAlertShown.toggle()
                    }
                    .alert(isPresented: $isAlertShown, content: {
                        Alert(
                            title: Text("'\(vm.newUser.general.name)' Adlı '\(vm.newUser.userType.userType.rawValue)' Personeli Kaydedilsin Mi?"),
                            primaryButton: .default(Text("Evet")) {
                                vm.saveUser()
                                dismiss()
                            },
                            secondaryButton: .cancel(Text("Hayır"))
                        )
                    })
                    .disabled(!vm.isValid)
                }
            }
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}


