//
//  ExpertTabView.swift
//  Deneme4
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct ExpertTabView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        TabView {
            MenuViewExpert()
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

struct ExpertTabView_Previews: PreviewProvider {
    static var previews: some View {
        ExpertTabView()
    }
}
