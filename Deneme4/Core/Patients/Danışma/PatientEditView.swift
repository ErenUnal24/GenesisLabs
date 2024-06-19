//
//  PatientEditView.swift
//  Deneme4
//
//  Created by Eren on 5.06.2024.
//

import SwiftUI

import SwiftUI

struct PatientEditView: View {
    var patient: Patient
    var updatePatient: (Patient) -> Void

    //let action: (_ patient: NewPatient) -> Void
    @StateObject private var vm = AddPatientViewModel()
    @Environment(\.dismiss) var dismiss
    @State var isUserDeleteAlertShown: Bool = false


    var body: some View {
        Form {
            
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
  
            
            Section(header: Text("İletişim")) {
                Section {
                    TextField("Telefon No", text: $vm.newPatient.contact.phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .onChange(of: vm.newPatient.contact.phoneNumber) { newValue in
                            vm.newPatient.contact.phoneNumber = formatPhoneNumber(newValue)
                        }
                    
                    TextField("Email", text: $vm.newPatient.contact.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }
            }
            /*
            Section {
                Picker("Test Tipi", selection: $vm.newPatient.testType.testType) {
                    ForEach(Patient.TestType.TestTypeEnum.allCases) { item in
                        Text(item.rawValue.uppercased())
                    }
                }
            }
             */
             
            Section {
                Toggle("Acil Durum Kişisi", isOn: $vm.newPatient.emergency.isEmergency)
                TextEditor(text: $vm.newPatient.emergency.emergencyName)
            }

            Button("Hepsini Temizle", role: .destructive) {
                vm.clearAll()
            }
            
            Button("Kaydı Sil", role: .destructive) {
                isUserDeleteAlertShown.toggle()
                //vm.deletePatient()
                //dismiss()
            }
            .alert(isPresented: $isUserDeleteAlertShown, content: {
            Alert(
                title: Text("\(vm.newPatient.general.name) Adlı ve \(vm.newPatient.general.tcNo) T.C. No'lu Kaydı Silmek İstediğinize Emin Misiniz?"),
                primaryButton: .default(Text("Evet")) {
                    vm.deletePatient()
                    dismiss()
                },
                secondaryButton: .cancel(Text("Hayır"))
            )
            })
        }
        .onAppear {
            vm.newPatient = patient
        }

        .navigationTitle("Hasta Düzenle")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Kaydet") {
                    //updatePatient(patient)
                    vm.editPatient()
                    dismiss()
                }
                .disabled(!vm.isValid)
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









struct PatientEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PatientEditView(patient: Patient.emptyPatient) { _ in }
        }
    }
}
