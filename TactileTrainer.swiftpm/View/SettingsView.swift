//
//  SettingsView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("정보") {
                    Text("Tactile Trainer v1.0.0")
                    Text("저시력 및 시각장애인을 위한 촉지 훈련 도구")
                }
            }
            .navigationTitle("설정")
        }
    }
}
