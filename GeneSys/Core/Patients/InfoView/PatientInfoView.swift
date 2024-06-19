//
//  PatientInfoView.swift
//  GeneSys
//
//  Created by Eren on 2.06.2024.
//

import SwiftUI

struct PatientInfoView: View {
    @State private var showEmergencyInfo: Bool = false
    @State private var navigateToEditView: Bool = false
    @State private var navigateToPDFView: Bool = false

    let item: Patient

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("**İsim**: \(item.general.name)")
                .font(.title3)
                .bold()
            Text("**T.C. No**: \(item.general.tcNo)")
            Text("**Cinsiyet**: \(item.general.gender.rawValue.uppercased())")
            Text("**Doğum Tarihi**: \(item.general.birthdate.formattedDate())")
            Divider()
            Text("**Telefon**: \(item.contact.phoneNumber)")
            Text("**Email**: \(item.contact.email)")
            
            Divider()
            
            HStack {
                Button(action: {
                    navigateToEditView = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .background(
                    NavigationLink(
                        destination: PatientEditView(patient: item) { updatedPatient in
                            // Güncellenmiş hastayı buradan işle
                        },
                        isActive: $navigateToEditView,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
                
                Button(action: {
                    navigateToPDFView = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                            .foregroundColor(.white)
                        Text("PDF")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .background(
                    NavigationLink(
                        destination: PatientPDFsView(patient: item),
                        isActive: $navigateToPDFView,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
            }
            
            if item.emergency.isEmergency {
                Divider()
                HStack {
                    Group {
                        Image(systemName: "exclamationmark.octagon")
                            .symbolVariant(.fill)
                            .font(.title)
                        Text("Acil Durum Kişisi")
                            .font(.title2)
                            .bold()
                    }
                    .foregroundStyle(.red)
                    Spacer()
                    Button {
                        withAnimation {
                            showEmergencyInfo.toggle()
                        }
                    } label: {
                        Image(systemName: showEmergencyInfo ? "chevron.up" : "chevron.down")
                            .symbolVariant(.circle.fill)
                    }
                    .font(.title)
                    .foregroundStyle(.gray.opacity(0.5))
                }
                
                if showEmergencyInfo {
                    Text(item.emergency.emergencyName)
                    Text(item.emergency.emergencyNo)

                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.18), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal)
    }
}

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}

struct PatientInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PatientInfoView(item: .emptyPatient)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
