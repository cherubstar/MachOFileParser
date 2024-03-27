//
//  DetailsView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/7.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    @Binding var current_menu: Array<String>
    @Binding var selected_index: Int
    var header: String
    var isMachHeader: Bool
    var group: String
    
    var body: some View {
        
        Section(content: {
            ContentsView()
        }, header: {
            
            if current_menu[selected_index] == "LC_SEGMENT_64(__TEXT)" ||
                current_menu[selected_index] == "LC_SEGMENT_64(__DATA_CONST)" ||
                current_menu[selected_index] == "LC_SEGMENT_64(__DATA)" {
                
                Toggle(isOn: $mfpvm.isShowSections){
                    detailNavigation
                }
                
            } else if current_menu[selected_index] == "LC_SYMTAB" {
                
                Toggle(isOn: $mfpvm.isShowTable){
                    detailNavigation
                }
                .sheet(isPresented: $mfpvm.isShowTable) {
                    SymbolTableView()
                }
                
            } else if current_menu[selected_index] == "LC_DYSYMTAB" {
                
                Toggle(isOn: $mfpvm.isShowTable){
                    detailNavigation
                }
                .sheet(isPresented: $mfpvm.isShowTable) {
                    DysymbolTableView()
                }
                
            } else if current_menu[selected_index] == "LC_CODE_SIGNATURE" ||
                        current_menu[selected_index] == "LC_SEGMENT_SPLIT_INFO" ||
                        current_menu[selected_index] == "LC_FUNCTION_STARTS" ||
                        current_menu[selected_index] == "LC_DATA_IN_CODE" ||
                        current_menu[selected_index] == "LC_DYLIB_CODE_SIGN_DRS" ||
                        current_menu[selected_index] == "LC_LINKER_OPTIMIZATION_HINT" ||
                        current_menu[selected_index] == "LC_DYLD_EXPORTS_TRIE" ||
                        current_menu[selected_index] == "LC_DYLD_CHAINED_FIXUPS" ||
                        current_menu[selected_index] == "__text" ||
                        current_menu[selected_index] == "__stubs" ||
                        current_menu[selected_index] == "__objc_methname" ||
                        current_menu[selected_index] == "__cstring" ||
                        current_menu[selected_index] == "__objc_classname" ||
                        current_menu[selected_index] == "__objc_methtype" ||
                        current_menu[selected_index] == "__eh_frame" ||
                        current_menu[selected_index] == "__got" ||
                        current_menu[selected_index] == "__cfstring" {
                
                Toggle(isOn: $mfpvm.isShowTable){
                    detailNavigation
                }
                .sheet(isPresented: $mfpvm.isShowTable) {
//                    FunctionStartsTableView()
                    Text(current_menu[selected_index])
                }
                
            } else {
                detailNavigation
            }
        })
        .textCase(nil)
    }
}

extension DetailsView {
    
    private var detailNavigation: some View {
        
        HStack {
            Text(isMachHeader ? "MACH64 HEADER" : current_menu[selected_index])
                .onAppear {
                    mfpvm.updateDetails(item: current_menu[selected_index], group: group)
                }
            
            Button {
                mfpvm.updateDetails(item: current_menu[selected_index], group: group)
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
        }
    }
}
