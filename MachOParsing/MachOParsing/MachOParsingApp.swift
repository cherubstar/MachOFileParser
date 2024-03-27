//
//  MachOParsingApp.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/22.
//

import SwiftUI

@main
struct MachOParsingApp: App {
    
    @ObservedObject var mfpvm: MachOFileParsingViewModel = MachOFileParsingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mfpvm)
        }
    }
}
