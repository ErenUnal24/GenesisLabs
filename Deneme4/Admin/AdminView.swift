//
//  SampleTabView.swift
//  Deneme4
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct AdminView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Label("Danışma", systemImage: "info.circle.fill")
                }
            
            MenuViewSampleAccept()
                .tabItem {
                    Label("Numune", systemImage: "syringe.fill")
                }
            
            MenuViewLab()
                .tabItem {
                    Label("Lab", systemImage: "flask.fill")
                }
            
            MenuViewBiologist()
                .tabItem {
                    Label("Biyolog", systemImage: "list.clipboard.fill")
                }
            
            MenuViewExpert()
                .tabItem {
                    Label("Uzman", systemImage: "person.crop.circle.badge.checkmark")
                }
            
            AddUserView()
                .tabItem {
                    Label("Kullanıcı Ekle", systemImage: "person.badge.plus")
                }
            
            UpdatePasswordView()
                .tabItem {
                    Label("Şifre Güncelle", systemImage: "key.fill")
                }

            SettingsView(showSignInView: $showSignInView)
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape")
                }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

