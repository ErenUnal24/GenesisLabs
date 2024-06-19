//
//  StatusUpdateView.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct StatusUpdateView: View {
    @StateObject private var vm = UpdateTestViewModel()
    
    @ObservedObject var dm: TestDataManager
    @State private var selectedStatus: Test.Status.StatusEnum = .numuneBekliyor
    @State var test: Test
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isAlertShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Durum Güncelleme")
                .font(.largeTitle)
            
            Text("Test Türü: \(test.testType.testType.rawValue)")
                .font(.headline)
            
            TextField("Hasta TC No", text: .constant(test.patient.general.tcNo))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .padding(.vertical, 5)
            
            TextField("Hasta Adı", text: .constant(test.patient.general.name))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .padding(.vertical, 5)
            
            Text("Durum: \(test.status.status.rawValue)")
                .font(.subheadline)
            
            Section(header: Text("Yeni Durum Atama")) {
                Picker("Test Durumu", selection: $selectedStatus) {
                    ForEach(Test.Status.StatusEnum.allCases.prefix(2), id: \.self) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Kaydet") {
                    isAlertShown.toggle()
                }
                .alert(isPresented: $isAlertShown) {
                    Alert(
                        title: Text("Emin misiniz?"),
                        message: Text("'\(test.patient.general.name)' adlı hastanın '\(test.testType.testType.rawValue)' testi '\(selectedStatus.rawValue)' olarak güncellensin mi?"),
                        primaryButton: .default(Text("Evet")) {
                            test.status.status = selectedStatus
                            dm.updateTest(test)
                            dismiss()
                        },
                        secondaryButton: .cancel(Text("Hayır"))
                    )
                }
                .disabled(!vm.isValid)
            }
        }
        .onAppear {
            // On initial load, set the view model's newTest to the current test
            vm.newTest = test
            vm.patientTCNo = test.patient.general.tcNo // Ensure patientTCNo is also set
        }
    }
}

struct StatusUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        let test = Test(
            id: UUID(),
            documentID: "docID",
            patient: Patient(
                id: UUID(),
                documentID: "patientID",
                general: Patient.General(
                    name: "John Doe",
                    gender: .Erkek,
                    birthdate: Date(),
                    tcNo: "12345678901"
                ),
                contact: Patient.Contact(
                    phoneNumber: "1234567890",
                    email: "test@example.com"
                ),
                emergency: Patient.Emergency(
                    isEmergency: false,
                    emergencyName: "Julia",
                    emergencyNo: "5435345346"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .ces),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )
        
        let dm = TestDataManager()
        
        NavigationView {
            StatusUpdateView(dm: dm, test: test)
        }
    }
}
