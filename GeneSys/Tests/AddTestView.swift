//
//  AddTestView.swift
//  GeneSys
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct AddTestView: View {
    
    @StateObject private var vm = AddTestViewModel()
   // @StateObject private var dm = TestDataManager()

    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State var isUserSaveAlertShown: Bool = false
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false

    
    var body: some View {
        NavigationStack {
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
                            Toggle("Acil Durum Kişisi", isOn: $vm.newTest.patient.emergency.isEmergency).foregroundStyle(.red).bold()
                                .disabled(true)
                            TextField("İsim", text: $vm.newTest.patient.emergency.emergencyName).foregroundStyle(.red)
                                .disabled(true)
                            TextField("Tel No", text: $vm.newTest.patient.emergency.emergencyNo).foregroundStyle(.red)
                                .disabled(true)
                        }
                    } else {
                        Text("Kayıt bulunamadı. Aramak için TC girin.")
                            .foregroundColor(.red)
                    }
                }
                
                //NUMUNE TÜRÜ
                Section(header: Text("Numune Türü")) {
                    Picker("Numune Tipi", selection: $vm.newTest.sampleType.sampleType) {
                        ForEach(Test.SampleType.SampleTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    
                }
                
                //TEST TYPE
                Section(header: Text("Test Türü")) {
                    Picker("Test Tipi", selection: $vm.newTest.testType.testType) {
                        ForEach(Test.TestType.TestTypeEnum.allCases) { item in
                            Text(item.rawValue.uppercased())
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Divider()
                    
                }
                
                
                //                Section {
                //                    Button(action: {
                //                        if vm.isValid {
                //                            vm.saveTest()
                //                            //dm.addTest(Test.emptyTest)
                //                            isUserSaveAlertShown.toggle()
                //                        } else {
                //                            print("Error")
                //                        }
                //                    }
                //
                //                    ) {
                //                        Text("Kaydet")
                //                    }
                //                }
                //            }
                //            .navigationBarTitle("Yeni Test Ekle", displayMode: .inline)
                //            .alert("Test kaydedildi", isPresented: $isUserSaveAlertShown) {
                //                Button("Tamam", role: .cancel) { dismiss() }
                //            }
            }
                .navigationBarTitle("Yeni Test Ekle", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        NavigationLink(destination: MenuView(), isActive: $navigateToMenu) {
                            Button("Kaydet") {
                                isAlertShown.toggle()
                            }
                            .alert(isPresented: $isAlertShown, content: {
                                Alert(
                                    title: Text("'\(vm.newTest.patient.general.name)' Adlı Kullanıcı için '\(vm.newTest.testType.testType.rawValue)' Testi Oluşturulsun Mu?"),
                                    primaryButton: .default(Text("Evet")) {
                                        vm.saveTest()
                                        dismiss()
                                    },
                                    secondaryButton: .cancel(Text("Hayır"))
                                )
                            })
                           // .disabled(!vm.isValid)
                        }
                    }
                }
                
                
                
                
                
                
        }
    }
        
    }


#Preview {
    AddTestView()
}


