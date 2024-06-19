//
//  ContentView.swift
//  Deneme4
//
//  Created by Eren on 22.05.2024.
//


import SwiftUI


struct ContentView: View {
    
   
    @State private var searchText: String = ""
    
    var body: some View {
       
        SignInEmailView(showSignInView: .constant(true))
        
        
    }
}

#Preview {
    ContentView()
}

