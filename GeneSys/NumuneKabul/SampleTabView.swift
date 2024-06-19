//
//  SampleTabView.swift
//  GeneSys
//
//  Created by Eren on 18.06.2024.
//

import SwiftUI

struct SampleTabView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        TabView {
            MenuViewSampleAccept()
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

struct SampleTabView_Previews: PreviewProvider {
    static var previews: some View {
        SampleTabView()
    }
}

