//
//  DysymbolTableView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

import SwiftUI

struct DysymbolTableView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Color.white.ignoresSafeArea()
            
            List {
                Section {
                    Toggle(isOn: $mfpvm.isShowDysymbolTable){
                        VStack(alignment: .leading) {
                            Text("Dysymbol Table")
                            Text(mfpvm.temporaryReminder)
                                .font(.caption)
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                    }
                }
                .font(.headline)
                .padding()
                
                if mfpvm.isShowDysymbolTable {
                    Section {
                        TableContentsView()
                            .onAppear {
                                mfpvm.updateDetails(item: "", group: "dysymbol")
                            }
                    } header: {
                        Text("Dysymbol Table")
                    }
                }
                
                // Tips
                TipsView()
                
            }   // List
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct DysymbolTableView_Previews: PreviewProvider {
    static var previews: some View {
        DysymbolTableView()
    }
}
