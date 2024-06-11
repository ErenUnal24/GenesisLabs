//
//  StatusUpdateView.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct StatusUpdateView: View {
    //@State private var dm = TestDataManager()
    @StateObject private var vm = UpdateTestViewModel()
    
    @ObservedObject var dm: TestDataManager
    @State private var selectedStatus: Test.Status.StatusEnum = .numuneBekliyor
    @State var test: Test

    
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
                    }   //PREFİX KULLANIMI ----> prefix(2).dropFirst(1) Kullanımı işime yarayacak
                    
                }
            }
            Button(action: {
                test.status.status = selectedStatus
                dm.updateTest(test)
            }) {
                Text("Güncelle")
                    
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 365, height: 50)
                    
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    selectedStatus = test.status.status
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
                    notes: ""
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
