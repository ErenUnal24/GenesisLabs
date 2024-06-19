//
//  MainTabView.swift
//  GeneSys
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct MainTabView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Label("Menü", systemImage: "list.dash")
                }

            SettingsView(showSignInView: $showSignInView)
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
