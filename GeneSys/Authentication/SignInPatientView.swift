import SwiftUI

struct SignInPatientView: View {
    
    @StateObject private var viewModel = SignInPatientViewModel()
    @Binding var showSignInView: Bool
    
    @State private var navigateToPDFView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.topColor, .centerColor, .bottomColor]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Sonuç Sorgulama")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                        
                        TextField("", text: $viewModel.tcNo)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                            .accentColor(.white)
                            .foregroundColor(.white)
                            .placeholder(when: viewModel.tcNo.isEmpty) {
                                Text("TC Kimlik No...")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        
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
                            Text("Sorgula")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
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
        }
    }
}

struct SignInPatientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInPatientView(showSignInView: .constant(false))
        }
    }
}

extension View {
    @ViewBuilder func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}
