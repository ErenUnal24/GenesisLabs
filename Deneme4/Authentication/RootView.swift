//
//  RootView.swift
//  Deneme4
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                            if showSignInView {
                                AuthenticationView(showSignInView: $showSignInView)
                            } else {
                                MenuView()
                                
                            }
                        }
                    }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil 
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
        }
        
        }
    }
}

#Preview {
    RootView()
}
