//
//  AddPatientsView.swift
//  Deneme4
//
//  Created by Eren on 2.06.2024.
//

import SwiftUI

struct AddPatientView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddPatientViewModel()

    let action: (_ patient: Patient) -> Void

    var body: some View {
        NavigationView {
            Form {
                
                
                //GENERAL SECTION
                Section(header: Text("Genel")) {
                    TextField("İsim", text: $vm.newPatient.general.name)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                    
                    TextField("T.C. No", text: $vm.newPatient.general.tcNo)
                        .textContentType(.name)
                        .keyboardType(.namePhonePad)
                        .onChange(of: vm.newPatient.general.tcNo) { newValue in
                                      vm.newPatient.general.tcNo = formatTcNo(newValue)
                                                                }

                    Picker("Cinsiyet", selection: $vm.newPatient.general.gender) {
                        ForEach(Patient.General.Gender.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }

                    DatePicker("Doğum Tarihi", selection: $vm.newPatient.general.birthdate, displayedComponents: [.date])
                }
                
                
                //CONTACT SECTION
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
                    
                    //    .onChange(of: vm.newPatient.contact.email) { newValue in
                      //                vm.newPatient.contact.email = formatEmail(newValue)
               //                                 }
                }
                
               /*
                //TEST TYPE
                Section(header: Text("Test Türü")) {
                    Picker("Test Tipi", selection: $vm.newPatient.testType.testType) {
                        ForEach(Patient.TestType.TestTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                }
                */
                
                //EMERGENCY
                Section(header: Text("Önemli")) {
                    Toggle("Acil Durum Kişisi", isOn: $vm.newPatient.emergency.isEmergency)
                        .onChange(of: vm.newPatient.emergency.isEmergency) { newValue in
                            if !newValue {
                                vm.newPatient.emergency.notes = ""
                            }
                        }
                    TextEditor(text: $vm.newPatient.emergency.notes)
                }
                

                Button("Hepsini Temizle", role: .destructive) {
                    vm.clearAll()
                }
            }
            .navigationTitle("Hasta Kayıt")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        //action(vm.newPatient)
                        vm.savePatient()
                        dismiss()
                    }
                    .disabled(!vm.isValid)
                }
                /*
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal", role: .cancel) {
                        dismiss()
                    }
                }
                 */
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

private func formatTcNo(_ number: String) -> String {
    let filtered = number.filter { "0123456789".contains($0) }
    if filtered.isEmpty {
        return ""
    }

    var result = filtered
    if result.count > 11 {
        result = String(result.prefix(11))
    }
    
    return result
}

struct AddPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView { _ in }
    }
}
