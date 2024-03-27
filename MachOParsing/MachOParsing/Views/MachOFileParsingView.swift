//
//  MachOFileParsingView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/22.
//

import SwiftUI

struct MachOFileParsingView: View {
    
    @EnvironmentObject private var mfpvm: MachOFileParsingViewModel
    @State private var first_selected_index = 0
    @State private var load_commands_selected_index = 0
    @State private var section_of_TEXT_selected_index = 0
    @State private var section_of_DATA_CONST_selected_index = 0
    @State private var section_of_DATA_selected_index = 0
    
    @State var showNewScreen: Bool = false
    
    var body: some View {
        
        NavigationView {
            Form {
                // Mach64 Header
                MenuView(current_menu: $mfpvm.first, selected_index: $first_selected_index, header: mfpvm.filetype, isMachHeader: true, group: "header")
                
                if mfpvm.first[first_selected_index] == "Mach64 Header" {
              
                    DetailsView(current_menu: $mfpvm.first, selected_index: $first_selected_index, header: "Mach64 Header",  isMachHeader: true, group: "header")
                    
                    // base info
                    baseInfo
                }
                
                if mfpvm.first[first_selected_index] == "Load Commands" {
                    
                    // Load Commands
                    MenuView(current_menu: $mfpvm.LOAD_COMMANDS_ARR, selected_index: $load_commands_selected_index, header: "Load Commands", isMachHeader: false, group: "command")
                    
                    // Segment's sections
                    if mfpvm.LOAD_COMMANDS_ARR[load_commands_selected_index] == "LC_SEGMENT_64(__TEXT)" && mfpvm.isShowSections {
                        
                        MenuView(current_menu: $mfpvm.SECTION_OF_TEXT_ARR, selected_index: $section_of_TEXT_selected_index, header: "Section64 Header", isMachHeader: false, group: "section")
                        // Section of __TEXT's details
                        DetailsView(current_menu: $mfpvm.SECTION_OF_TEXT_ARR, selected_index: $section_of_TEXT_selected_index, header: "Section64 Header",  isMachHeader: false, group: "section")
                        
                    } else if mfpvm.LOAD_COMMANDS_ARR[load_commands_selected_index] == "LC_SEGMENT_64(__DATA_CONST)" && mfpvm.isShowSections {
                        
                        MenuView(current_menu: $mfpvm.SECTION_OF_DATA_CONST_ARR, selected_index: $section_of_DATA_CONST_selected_index, header: "Section64 Header", isMachHeader: false, group: "section")
                        // Section of __DATA_CONST's details
                        DetailsView(current_menu: $mfpvm.SECTION_OF_DATA_CONST_ARR, selected_index: $section_of_DATA_CONST_selected_index, header: "Section64 Header", isMachHeader: false, group: "section")
                        
                    } else if mfpvm.LOAD_COMMANDS_ARR[load_commands_selected_index] == "LC_SEGMENT_64(__DATA)" && mfpvm.isShowSections {
                        
                        MenuView(current_menu: $mfpvm.SECTION_OF_DATA_ARR, selected_index: $section_of_DATA_selected_index, header: "Section64 Header", isMachHeader: false, group: "section")
                        // Section of __DATA's details
                        DetailsView(current_menu: $mfpvm.SECTION_OF_DATA_ARR, selected_index: $section_of_DATA_selected_index, header: "Section64 Header", isMachHeader: false, group: "section")
                        
                    } else {
                        // Load Commands's details
                        DetailsView(current_menu: $mfpvm.LOAD_COMMANDS_ARR, selected_index: $load_commands_selected_index, header: "Load Commands", isMachHeader: false, group: "command")
                    }
                }   // if
            }  // Form
            .navigationTitle(Text("MachO File Parsing"))
        }
    }
}

struct MachOFileParsingView_Previews: PreviewProvider {
    static var previews: some View {
        MachOFileParsingView()
    }
}

// extension
extension MachOFileParsingView {
    
    private var baseInfo: some View {

        Section(content: {
            VStack {
                HStack {
                    Spacer()
                    Text(mfpvm.baseInfo)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Written By 小七.")
                    Spacer()
                }
            }
            .font(.caption)
            .foregroundColor(Color.gray.opacity(0.8))
        })
    }
}
