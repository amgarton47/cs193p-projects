//
//  SetApp.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = SetGameModelView()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
