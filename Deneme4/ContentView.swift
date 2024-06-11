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


 //KULLANICI GİRİŞİ VE ROL TABANLI GÖRÜNÜM İÇİN ***********************************
/*
 import SwiftUI

 struct ContentView: View {
     @ObservedObject var usersVM = UsersViewModel()
     @State private var loggedInUser: User?

     var body: some View {
         VStack {
             if let user = loggedInUser {
                 switch user.role {
                 case .danışma:
                     DanışmaView()
                 case .numuneKabul:
                     NumuneKabulView()
                 case .laborant:
                     LaborantView()
                 case .laborantSonuç:
                     LaborantSonuçView()
                 case .biyolog:
                     BiyologView()
                 }
             } else {
                 LoginView(loggedInUser: $loggedInUser)
             }
         }
         .onAppear {
             usersVM.fetchUsers()
         }
     }
 }

 struct LoginView: View {
     @Binding var loggedInUser: User?

     var body: some View {
         // Giriş formu ve giriş işlemleri burada olacak
         // Giriş başarılı olursa loggedInUser değişkeni atanacak
     }
 }

 // Diğer kullanıcı rolü görünümleri (DanışmaView, NumuneKabulView, vb.) burada tanımlanacak

 */
