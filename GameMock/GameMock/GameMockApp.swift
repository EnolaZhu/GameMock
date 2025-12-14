//
//  GameMockApp.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import SwiftUI

@main
struct GameMockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MatchListViewModel())
        }
    }
}
