//
//  TableContentsView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

import SwiftUI

struct TableContentsView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    
    var body: some View {
        
        VStack {
            HStack {
                DetailTitleView()
            }
            .foregroundColor(.blue)
            .padding(.vertical)
            
            // detail
            List {
                ForEach(Array(mfpvm.tableDetails.enumerated()), id: \.element.id) { index, detail in
                    DetailRowView(detail: detail)
                        .listRowBackground(index % 2 == 0 ? Color.gray.opacity(0.1) : .none)
                }
            }
            .listStyle(PlainListStyle())
        }
        .frame(height: 260)
        
    }
    
}

struct TableContentsView_Previews: PreviewProvider {
    static var previews: some View {
        TableContentsView()
    }
}
