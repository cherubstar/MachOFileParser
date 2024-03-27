//
//  ContentView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/10.
//

import SwiftUI

struct ContentsView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    
    var body: some View {
        VStack {
            HStack {
                DetailTitleView()
            }
            .foregroundColor(.blue)
            .padding(.vertical)
            
//            Divider()
            
            // detail
            List {
                ForEach(Array(mfpvm.details.enumerated()), id: \.element.id) { index, detail in
                    DetailRowView(detail: detail)
                        .listRowBackground(index % 2 == 0 ? Color.gray.opacity(0.1) : .none)
                }
            }
            .listStyle(PlainListStyle())
        }
        .frame(height: 260)
    }
}
