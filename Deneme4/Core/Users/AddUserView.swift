//
//  AddUserView.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct AddUserView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddUserViewModel()

    
    
    
    var body: some View {
        NavigationView {
            Form {
                
                
                //GENERAL SECTION
                Section(header: Text("Genel")) {
                    TextField("İsim", text: $vm.newUser.general.name)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                    


                    TextField("Email", text: $vm.newUser.general.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    
                }
                
                
                //USER TYPE
                Section(header: Text("User Türü")) {
                    Picker("User Tipi", selection: $vm.newUser.userType.userType) {
                        ForEach(Users.UserType.UserTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                }
                
                
                
                Button("Hepsini Temizle", role: .destructive) {
                    vm.clearAll()
                }
            }
            .navigationTitle("User Kayıt")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        //action(vm.newPatient)
                        vm.saveUser()
                        dismiss()
                    }
                    .disabled(!vm.isValid)
                }
             
            }
        }
    }
}

#Preview {
    AddUserView()
}
