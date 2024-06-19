//
//  AddPatientsView.swift
//  GeneSys
//
//  Created by Eren on 2.06.2024.
//

import SwiftUI

struct AddPatientView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddPatientViewModel()
    
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false
    
    let action: (_ patient: Patient) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                
                // GENERAL SECTION
                Section(header: Text("Genel")) {
                    TextField("İsim", text: $vm.newPatient.general.name)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                    
                    VStack(alignment: .leading) {
                        TextField("T.C. No", text: $vm.newPatient.general.tcNo)
                            .textContentType(.name)
                            .keyboardType(.numberPad)
                            .foregroundColor(vm.isTcValid ? .primary : .red)
                            .onChange(of: vm.newPatient.general.tcNo) { newValue in
                                vm.checkAndFormatTCNo(tcNo: newValue)
                            }
                        
                        if let errorMessage = vm.tcErrorMessage, !vm.isTcValid {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    Picker("Cinsiyet", selection: $vm.newPatient.general.gender) {
                        ForEach(Patient.General.Gender.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                    
                    DatePicker("Doğum Tarihi", selection: $vm.newPatient.general.birthdate, displayedComponents: [.date])
                }
                
                // CONTACT SECTION
                Section(header: Text("İletişim")) {
                    TextField("Telefon No", text: $vm.newPatient.contact.phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .onChange(of: vm.newPatient.contact.phoneNumber) { newValue in
                            vm.newPatient.contact.phoneNumber = formatPhoneNumber(newValue)
                        }
                    
                    TextField("Email", text: $vm.newPatient.contact.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // EMERGENCY
                Section(header: Text("Önemli")) {
                    Toggle("Acil Durum Kişisi", isOn: $vm.newPatient.emergency.isEmergency)
                        .onChange(of: vm.newPatient.emergency.isEmergency) { newValue in
                            if !newValue {
                                vm.newPatient.emergency.emergencyName = ""
                                vm.newPatient.emergency.emergencyNo = ""
                                
                            }
                            
                            
                        }
                    
                    TextField("İsim", text: $vm.newPatient.emergency.emergencyName)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                        
                    TextField("No", text: $vm.newPatient.emergency.emergencyNo)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                    

                        

                }
                
                Button("Hepsini Temizle", role: .destructive) {
                    vm.clearAll()
                }
            }
            .navigationTitle("Hasta Kayıt")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: MenuView(), isActive: $navigateToMenu) {
                        Button("Kaydet") {
                            isAlertShown.toggle()
                        }
                        .alert(isPresented: $isAlertShown, content: {
                            Alert(
                                title: Text("'\(vm.newPatient.general.name)' Adlı ve '\(vm.newPatient.general.tcNo)' T.C. No'lu Hasta Kaydedilsin Mi?"),
                                primaryButton: .default(Text("Evet")) {
                                    vm.savePatient()
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
    
    private func formatPhoneNumber(_ number: String) -> String {
        let filtered = number.filter { "0123456789".contains($0) }
        if filtered.isEmpty {
            return ""
        }
        
        var result = filtered
        if !result.hasPrefix("5") {
            result = "5" + result
        }
        
        if result.count > 10 {
            result = String(result.prefix(10))
        }
        
        return result
    }
}

struct AddPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView { _ in }
    }
}
