//
//  MenuView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/12/7.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    @Binding var current_menu: Array<String>
    @Binding var selected_index: Int
    var header: String
    var isMachHeader: Bool
    var group: String
    
    var body: some View {
        Section {

            if isMachHeader {
                Picker("\(current_menu[selected_index])", selection: $selected_index) {
                    ForEach(current_menu.indices, id: \.self) { index in
                        Text(current_menu[index])
                    }
                }
                .pickerStyle(.segmented)
            } else {
                Picker("\(current_menu[selected_index])", selection: $selected_index) {
                    ForEach(current_menu.indices, id: \.self) { index in
                        Text(current_menu[index])
                    }
                }
                .pickerStyle(.menu)
            }
            
        } header: {
            
            if header == "Section64 Header" {
                
                Toggle(isOn: $mfpvm.isShowSections){
                    Text(header)
                }
                
            } else {
                Text(header)
            }
            
        }
    }
}
