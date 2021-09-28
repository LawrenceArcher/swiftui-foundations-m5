//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Lawrence Archer on 28/09/2021.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
