import SwiftUI

struct SignInPatientView: View {
    
    @StateObject private var viewModel = SignInPatientViewModel()
    @Binding var showSignInView: Bool
    
    @State private var navigateToPDFView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("TC Kimlik No...", text: $viewModel.tcNo)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .accentColor(.white)
                    .foregroundStyle(.white)
       
                
                
                // GİRİŞ BUTONU
                Button {
                    Task {
                        do {
                            try await viewModel.fetchPatientInfo()
                            navigateToPDFView = true // Burada navigasyonu tetikliyoruz
                        } catch {
                            print("Fetch Patient Info Error: \(error)")
                        }
                    }
                } label: {
                    Text("Giriş")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Sonuç Sorgulama")
            .padding(10)
            .background(
                NavigationLink(
                    destination: viewModel.fetchedPatient.map { PatientPDFsView(patient: $0) },
                    isActive: $navigateToPDFView,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                           startPoint: .topLeading,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct SignInPatientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInPatientView(showSignInView: .constant(false))
        }
    }
}
