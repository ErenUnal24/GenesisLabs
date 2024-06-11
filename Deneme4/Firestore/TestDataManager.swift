//
//  TestDataManager.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//


import Foundation
import Firebase

class TestDataManager: ObservableObject {
    @Published var tests: [Test] = []
    
    func fetchTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                    //**
                    let testTypeString     = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                            status: Test.Status(status: status),
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    //******
    func fetchSampleWaitingTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Numune Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                            status: Test.Status(status: status),
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    func fetchSampleAcceptedTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Test Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status(status: Test.Status.StatusEnum(rawValue: statusString) ?? .analizBekliyor)
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                           // status: Test.Status(status: status),
                            status: status,
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
        
        //******
    
    
    func updateTest(_ test: Test) {
            guard let documentID = test.documentID else {
                print("Document ID is nil")
                return
            }
            
            let db = Firestore.firestore()
            let ref = db.collection("Tests").document(documentID)
            
            ref.updateData([
                "patientID": test.patient.documentID ?? "",
                "testType": test.testType.testType.rawValue,
                "status": test.status.status.rawValue,
                "sampleType": test.sampleType.sampleType.rawValue
            ]) { error in
                if let error = error {
                    print("Error updating test: \(error)")
                } else {
                    print("Test updated successfully")
                    
                    // Yerel test verilerini de güncelle
                    if let index = self.tests.firstIndex(where: { $0.documentID == test.documentID }) {
                        self.tests[index] = test
                    }
                }
            }
        }
    
        
        
        
        
        func addTest(_ test: Test) {
            let db = Firestore.firestore()
            db.collection("Tests").addDocument(data: [
                "patientID": test.patient.documentID ?? "",
                "testType": test.testType.testType.rawValue,
                "status": test.status.status.rawValue,
                "sampleType": test.sampleType.sampleType.rawValue
                
            ])
        }
        
        func deleteTest(_ test: Test) {
            guard let documentID = test.documentID else {
                print("Document ID is nil")
                return
            }
            let db = Firestore.firestore()
            db.collection("Tests").document(documentID).delete { error in
                if let error = error {
                    print("Error deleting test: \(error)")
                } else {
                    print("Test deleted successfully")
                }
            }
        }
    }
    

