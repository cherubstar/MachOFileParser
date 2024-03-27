//
//  TipsView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

import SwiftUI

struct TipsView: View {
    
    var body: some View {
        
        Section(content: {
            VStack {
                HStack {
                    Spacer()
                    Text("Don't worry, the loading time will be quite long.")
                    Spacer()
                }
            }
            .font(.caption)
            .foregroundColor(Color.gray.opacity(0.8))
        }, header: {
            Text("TIPS")
        })
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
