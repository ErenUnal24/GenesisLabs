//
//  PatientsViewModel.swift
//  GeneSys
//
//  Created by Eren on 2.06.2024.
//


import SwiftUI
import Combine

class PatientViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    private var dataManager = DataManager()
    private var cancellables = Set<AnyCancellable>()
    
    //**
    @Published var searchText: String = ""
    @Published var searchType: SearchType = .tcNo

    init() {
        dataManager.$patients
            .receive(on: DispatchQueue.main)
            .assign(to: \.patients, on: self)
            .store(in: &cancellables)
        
        fetchPatients()
    }
    
    
    //**
    var filteredPatients: [Patient] {
            if searchText.isEmpty {
                return patients
            } else {
                switch searchType {
                case .tcNo:
                    return patients.filter { $0.general.tcNo.contains(searchText) }
                case .name:
                    return patients.filter { $0.general.name.lowercased().contains(searchText.lowercased()) }
                }
            }
        }
    
    
    func fetchPatients() {
        dataManager.fetchPatients()
    }
    
    func add(_ patient: Patient) {
        // Veritabanına ekleme işlemi burada yapılacak
        // Örnek olarak diziye ekleme işlemi:
        patients.append(patient)
    }
    
    func updatePatient(_ patient: Patient) {
            // Hasta güncelleme işlemleri
            if let index = patients.firstIndex(where: { $0.id == patient.id }) {
                patients[index] = patient
            }
        }
    
    
    
    func isValid(patient: Patient) -> Bool {
            !patient.general.name.isEmpty &&
            !patient.contact.phoneNumber.isEmpty &&
            patient.contact.phoneNumber.first == "5" && // Telefon numarası 5 ile başlamalı
            patient.contact.email.hasSuffix("@mail.com")
        }
    
    
    
    //**
    enum SearchType {
            case tcNo, name
        }
    
}

