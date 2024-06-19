//
//  LabTabView.swift
//  GeneSys
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct LabTabView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        TabView {
            MenuViewLab()
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

struct LabTabView_Previews: PreviewProvider {
    static var previews: some View {
        LabTabView()
    }
}
