//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Madeline Darmawangsa on 27/05/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
