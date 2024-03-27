//
//  FunctionStartsTableView.swift
//  MachOParsing
//
//  Created by 小七 on 2024/3/18.
//

import SwiftUI

struct FunctionStartsTableView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Color.white.ignoresSafeArea()
            
            List {
                Section {
                    Toggle(isOn: $mfpvm.isShowFunctionStartsTable){
                        VStack(alignment: .leading) {
                            Text("Function Starts Table")
                            Text(mfpvm.temporaryReminder)
                                .font(.caption)
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                    }
                }
                .font(.headline)
                .padding()
                
                if mfpvm.isShowFunctionStartsTable {
                    Section {
                        TableContentsView()
                            .onAppear {
                                mfpvm.updateDetails(item: "", group: "function starts")
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

struct FunctionStartsTableView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionStartsTableView()
    }
}
