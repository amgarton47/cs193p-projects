//
//  SetApp.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: game)
        }
    }
}
