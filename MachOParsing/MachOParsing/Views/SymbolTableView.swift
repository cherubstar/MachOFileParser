//
//  SymbolTableView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

import SwiftUI

struct SymbolTableView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Color.white.ignoresSafeArea()
            
            List {
                Section {
                    Toggle(isOn: $mfpvm.isShowSymbolTable){
                        VStack(alignment: .leading) {
                            Text("Symbol Table")
                            Text(mfpvm.temporaryReminder)
                                .font(.caption)
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                    }
                    Toggle(isOn: $mfpvm.isShowStringTable){
                        VStack(alignment: .leading) {
                            Text("String Table")
                            Text(mfpvm.temporaryReminder)
                                .font(.caption)
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                    }
                }
                .font(.headline)
                .padding()
                .alert(isPresented: $mfpvm.showAlert) {
                    mfpvm.getAlert()
                }
                
                // Check both options simultaneously
                if mfpvm.isShowSymbolTable && !mfpvm.isShowStringTable {
                    Section {
                        TableContentsView()
                            .onAppear {
                                mfpvm.updateDetails(item: "", group: "symbol")
                                mfpvm.noShowingAlert()
                            }
                    } header: {
                        Text("Symbol Table")
                    }
                } else if !mfpvm.isShowSymbolTable && mfpvm.isShowStringTable {
                    Section {
                        TableContentsView()
                            .onAppear {
                                mfpvm.updateDetails(item: "", group: "string")
                                mfpvm.noShowingAlert()
                            }
                    } header: {
                        Text("String Table")
                    }
                } else if mfpvm.isShowSymbolTable && mfpvm.isShowStringTable {
                    Section {
                        Text("Please cancel your selection!")
                            .font(.caption)
                            .foregroundColor(Color.gray.opacity(0.8))
                            .onAppear {
                                mfpvm.contentAlert = "How can you check all the options above. 😱"
                                mfpvm.isShowingAlert()
                            }
                    } header: {
                        Text("IMPOSSIBLE")
                    }
                }
                
                // Tips
                TipsView()
                
            }   // List
            .listStyle(InsetGroupedListStyle())
        }   // ZStack
        
    }
}

struct SymbolTableView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolTableView()
    }
}
