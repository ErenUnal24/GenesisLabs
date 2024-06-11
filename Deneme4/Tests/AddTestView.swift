//
//  AddTestView.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct AddTestView: View {
    
    @StateObject private var vm = AddTestViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State var isUserSaveAlertShown: Bool = false

    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Hasta Bilgisi")) {
                                    TextField("TC No", text: $vm.patientTCNo)
                                        .keyboardType(.numberPad)
                                        .onChange(of: vm.patientTCNo, perform: { value in
                                            vm.fetchPatientByTCNo()
                                        })
                                    
                                    if vm.patientExists {
                                        TextField("Name", text: $vm.newTest.patient.general.name)
                                            .disabled(true)
                                        TextField("Gender", text: Binding(
                                            get: { vm.newTest.patient.general.gender.rawValue },
                                            set: { _ in }
                                        ))
                                        .disabled(true)
                                        DatePicker("Birthdate", selection: $vm.newTest.patient.general.birthdate, displayedComponents: .date)
                                            .disabled(true)
                                        TextField("Phone Number", text: $vm.newTest.patient.contact.phoneNumber)
                                            .disabled(true)
                                        TextField("Email", text: $vm.newTest.patient.contact.email)
                                            .disabled(true)
                                        
                                        Section(header: Text("").bold().foregroundStyle(.red)) {
                                            Toggle("Emergency", isOn: $vm.newTest.patient.emergency.isEmergency).foregroundStyle(.red).bold()
                                                .disabled(true)
                                            TextField("Emergency Notes", text: $vm.newTest.patient.emergency.notes).foregroundStyle(.red)
                                                .disabled(true)
                                        }
                                    } else {
                                        Text("Kayıt bulunamadı. Aramak için TC girin.")
                                            .foregroundColor(.red)
                                    }
                                }
                
                //TEST TYPE
                Section(header: Text("Test Türü")) {
                    Picker("Test Tipi", selection: $vm.newTest.testType.testType) {
                        ForEach(Test.TestType.TestTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                }
                 //NUMUNE TÜRÜ
                Section(header: Text("Numune Türü")) {
                    Picker("Numune Tipi", selection: $vm.newTest.sampleType.sampleType) {
                        ForEach(Test.SampleType.SampleTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                }
                               
                                
                                Button(action: {
                                    if vm.isValid {
                                       // vm.saveTest()
                                       // presentationMode.wrappedValue.dismiss()
                                        isUserSaveAlertShown.toggle()
                                    }
                                }) {
                                    Text("TEST OLUŞTUR")
                                }
                                .alert(isPresented: $isUserSaveAlertShown, content: {
                                Alert(
                                    title: Text("\(vm.newTest.patient.general.name) Adlı ve \(vm.newTest.patient.general.tcNo) T.C. No'lu hasta için test oluşturmak istediğinize emin misiniz?"),
                                    primaryButton: .default(Text("Evet")) {
                                        vm.saveTest()
                                        dismiss()
                                    },
                                    secondaryButton: .cancel(Text("Hayır"))
                                )
                                })
                                .disabled(!vm.isValid)
                            }
                            .navigationBarTitle("Add New Test", displayMode: .inline)
                            .navigationBarItems(trailing: Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                            })
        }
        
    }
}

#Preview {
    AddTestView()
}


