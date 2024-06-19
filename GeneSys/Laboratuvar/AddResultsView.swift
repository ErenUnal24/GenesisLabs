//
//  TestResultsView.swift
//  GeneSys
//
//  Created by Eren on 12.06.2024.
//

import SwiftUI

struct AddResultsView: View {
    @ObservedObject private var testResultsViewModel: TestResultsViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false

    


    init(test: Test, dataManager: TestDataManager) {
        self.testResultsViewModel = TestResultsViewModel(test: test, dataManager: dataManager)
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Test Sonuç Girişi")
                    .font(.largeTitle)
                    .padding()

                Form {
                    Section(header: Text("Hasta Bilgileri")) {
                        Text("Test Türü: \(testResultsViewModel.test.testType.testType.rawValue)")
                            .font(.headline)

                        Text("Hasta İsmi: \(testResultsViewModel.test.patient.general.name)")
                            .font(.headline)

                        Text("Hasta TC No: \(testResultsViewModel.test.patient.general.tcNo)")
                            .font(.subheadline)

                        Text("Numune Türü: \(testResultsViewModel.test.sampleType.sampleType.rawValue)")
                            .font(.subheadline)
                    }

                    Section(header: Text("Test Sonuçları")) {
                        ForEach(testResultsViewModel.parameterValues.keys.sorted(), id: \.self) { key in
                            HStack {
                                Text("\(key):")
                                TextField("Değer girin", text: Binding(
                                    get: { testResultsViewModel.parameterValues[key] ?? "" },
                                    set: { testResultsViewModel.parameterValues[key] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }

//                    Button(action: {
//                        testResultsViewModel.saveTestResults()
//                    }) {
//                        Text("Sonuçları Kaydet")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
                    
                  //  .navigationBarTitle("Sonuç Girişi", displayMode: .inline)
                 //   .toolbar {
                 //       ToolbarItem(placement: .confirmationAction) {
                     //       NavigationLink(destination: MenuView(), isActive: $navigateToMenu) {
                                Button("Kaydet") {
                                    isAlertShown.toggle()
                                }
                                .alert(isPresented: $isAlertShown, content: {
                                    Alert(
                                        title: Text("Sonuçlar Kaydedilsin Mi?"),
                                        primaryButton: .default(Text("Evet")) {
                                            testResultsViewModel.saveTestResults()
                                            dismiss()
                                        },
                                        secondaryButton: .cancel(Text("Hayır"))
                                    )
                                })
                               // .disabled(!testResultsViewModel.isValid)
                       //     }
                  //      }
           //         }
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
}

struct AddResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let test = Test(
            id: UUID(),
            documentID: "sampleDocID",
            patient: Patient(
                id: UUID(),
                documentID: "patientDocID",
                general: Patient.General(
                    name: "John Doe",
                    gender: .Erkek,
                    birthdate: Date(),
                    tcNo: "12345678901"
                ),
                contact: Patient.Contact(
                    phoneNumber: "1234567890",
                    email: "john.doe@example.com"
                ),
                emergency: Patient.Emergency(
                    isEmergency: false,
                    emergencyName: "Julia", emergencyNo: "243534534"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .tekgen),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )

        return NavigationView {
            AddResultsView(test: test, dataManager: TestDataManager())
        }
    }
}
