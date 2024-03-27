//
//  MachOFileParsingViewModel.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/22.
//

import Foundation
import SwiftUI

class MachOFileParsingViewModel: ObservableObject {
    
    // view
    @Published var details: [DetailModel] = []
    @Published var tableDetails: [DetailModel] = []
    
    @Published var macho: Dictionary<String, Any> = [:]
    
    @Published var mach_header: Array<MPRow> = []
    @Published var load_commands: Dictionary<String, Any> = [:]
    @Published var loadCommandDetails: Array<MPRow> = []
    
    // Segment
//    @Published var SEGMENT_PAGEZERO: Array<MPRow> = []
//    @Published var SEGMENT_TEXT: Array<MPRow> = []
//    @Published var SEGMENT_DATA: Array<MPRow> = []
//    @Published var SEGMENT_DATA_CONST: Array<MPRow> = []
//    @Published var SEGMENT_LINKEDIT: Array<MPRow> = []
    
    // Load Commands Array
    @Published var LOAD_COMMANDS_ARR: Array<String> = []
    
    // Sections Dictionary
    @Published var SECTION_OF_TEXT_DICT:Dictionary<String, Array<MPRow>> = [:]
    @Published var SECTION_OF_DATA_CONST_DICT:Dictionary<String, Array<MPRow>> = [:]
    @Published var SECTION_OF_DATA_DICT:Dictionary<String, Array<MPRow>> = [:]
    @Published var sectionDetails: Array<MPRow> = []
    
    // Sections Array
    @Published var SECTIONS_DICT: Dictionary<String, Array<String>> = [:]
    @Published var SECTION_OF_TEXT_ARR: Array<String> = []
    @Published var SECTION_OF_DATA_CONST_ARR: Array<String> = []
    @Published var SECTION_OF_DATA_ARR: Array<String> = []
    
    //
    @Published var symtab: Array<MPRow> = []
    @Published var dysymtab: Array<MPRow> = []

//    @Published var dylinker: Dictionary<String, Array<MPRow>> = [:]

    @Published var uuid: Array<MPRow> = []
    @Published var build: Array<MPRow> = []
    @Published var source: Array<MPRow> = []
    @Published var main: Array<MPRow> = []
    @Published var encryption: Array<MPRow> = []

//    @Published var dylib: Dictionary<String, Array<MPRow>> = [:]

    @Published var rpath: Array<MPRow> = []

//    @Published var linkedit: Dictionary<String, Array<MPRow>> = [:]
    
    // File Type
    @Published var filetype: String = ""
    // Base Information
    @Published var baseInfo: String = ""
    
    // Symbol Table
    @Published var symbolTables: Array<MPRow> = []
    
    // String Table
    @Published var stringTables: Array<MPRow> = []
    
    // Dysymbol Table
    @Published var dysymbolTables: Array<MPRow> = []
    
    // Function Starts Table
    @Published var functionStartsTables: Array<MPRow> = []
    
    // Mach64 Header
    @Published var first = [
        "Mach64 Header",
        "Load Commands"
    ]
    
    @Published var isShowSections = false
    @Published var isShowTable = false
    @Published var isShowSymbolTable = false
    @Published var isShowStringTable = false
    @Published var isShowDysymbolTable = false
    @Published var isShowFunctionStartsTable = false
    
    // Tips
    @Published var temporaryReminder = "Due to the large quantity, only 60 items are displayed."
    
    // start parsing
    @Published var parsing = MachOFileParsing()
    
    init() {
        
        macho = parsing.parsing() as! Dictionary<String, Any>
        
        // init all details
        initDetails()
        
        // init all tables
        initAllTables()
        
        // init file type
        filetype = parsing.getFileType()
        // init base info
        baseInfo = parsing.getBaseInfo()
        
        // init all load commands array for the selected index
        initLoadCommandArray()
        // init all sections array for the selected index
        initSectionsArray()
    }
    
    /**
        Init Details
     */
    func initDetails() {
        
//        let temp: Array<MPRow> = []
        mach_header = macho["MACH64 HEADER"] as! Array<MPRow>
        load_commands = macho["LOAD COMMANDS"] as! Dictionary<String, Any>
        
        // Get Segments Array
//        SEGMENT_PAGEZERO = load_commands["LC_SEGMENT_64(__PAGEZERO)"] as! Array<MPRow>
//        SEGMENT_TEXT = load_commands["LC_SEGMENT_64(__TEXT)"] as! Array<MPRow>
//        SEGMENT_DATA_CONST = load_commands["LC_SEGMENT_64(__DATA_CONST)"] as! Array<MPRow>
//        SEGMENT_DATA = load_commands["LC_SEGMENT_64(__DATA)"] as! Array<MPRow>
//        SEGMENT_LINKEDIT = load_commands["LC_SEGMENT_64(__LINKEDIT)"] as! Array<MPRow>
        
        // Get Sections Dictionary
        SECTION_OF_TEXT_DICT = load_commands["SEG_TEXT_SECTION"] as! Dictionary<String, Array<MPRow>>
        SECTION_OF_DATA_CONST_DICT = load_commands["SEG_DATA_CONST_SECTION"] as! Dictionary<String, Array<MPRow>>
        SECTION_OF_DATA_DICT = load_commands["SEG_DATA_SECTION"] as! Dictionary<String, Array<MPRow>>
    }
    
    /**
        Update Details
     */
    func updateDetails(item: String, group: String) {

        switch(group) {
        case "header":
            updateMachHeaderDetails(header: item)
            break
        case "command":
            updateLoadCommandDetails(command: item)
            break
        case "section":
            updateSectionDetails(section: item)
            break
        case "symbol":
            updateSymbolTables()
            break
        case "string":
            updateStringTables()
            break
        case "dysymbol":
            updateDysymbolTables()
            break
        case "function starts":
            updateFunctionStartsTables()
            break
        default:
            break
        }
        
//        print(details)
    }
    
    /**
        Mach Header
     */
    // Update Mach Header Details
    func updateMachHeaderDetails(header: String) {
        if header == "Mach64 Header" {
            update(items: mach_header)
        }
    }
    
    /**
        Load Commands
     */
    // init all load commands array for the selected index
    func initLoadCommandArray() {
        LOAD_COMMANDS_ARR = parsing.getCommands() as! Array<String>
    }
    
    // Get Load Command Details
    func getLoadCommandDetails(command: String) -> Array<MPRow> {
        
        if LOAD_COMMANDS_ARR.contains(command) {
            loadCommandDetails = load_commands[command] as! Array<MPRow>
        }
        
        return loadCommandDetails
    }
    
    // Update Load Command Details
    func updateLoadCommandDetails(command: String) {
        update(items: getLoadCommandDetails(command: command))
    }
    
    /**
        Sections
     */
    // init all sections array for the selected index
    func initSectionsArray() {
        SECTIONS_DICT = parsing.getSections() as! Dictionary<String, Array<String>>
        
        // empty array
        let temp: Array<String> = []
        
        SECTION_OF_TEXT_ARR = SECTIONS_DICT["SEG_TEXT_SECTION"] ?? temp
        SECTION_OF_DATA_CONST_ARR = SECTIONS_DICT["SEG_DATA_CONST_SECTION"] ?? temp
        SECTION_OF_DATA_ARR = SECTIONS_DICT["SEG_DATA_SECTION"] ?? temp
    }
    
    // Get Section Details
    func getSectionDetails(section: String) -> Array<MPRow> {
        
        let temp: Array<MPRow> = []
        
        if SECTION_OF_TEXT_DICT.keys.contains(section) {
            sectionDetails = SECTION_OF_TEXT_DICT[section] ?? temp
        } else if SECTION_OF_DATA_CONST_DICT.keys.contains(section) {
            sectionDetails = SECTION_OF_DATA_CONST_DICT[section] ?? temp
        } else if SECTION_OF_DATA_DICT.keys.contains(section) {
            sectionDetails = SECTION_OF_DATA_DICT[section] ?? temp
        }
        
        return sectionDetails
    }
    
    // Update Section Details
    func updateSectionDetails(section: String) {
        update(items: getSectionDetails(section: section))
    }
    
    // update
    func update(items: Array<MPRow>) {
        
        if !details.isEmpty {
            details.removeAll()
        }
        
        for item in items {
            details.append(DetailModel(offset: item.offset, data: item.data, description: item.descriptions, value: item.value))
        }
    }
    
    /**
        All Table
     */
    func initAllTables() {
        symbolTables = parsing.getSymbolTables() as! Array<MPRow>
        stringTables = parsing.getStringTables() as! Array<MPRow>
        dysymbolTables = parsing.getDysymbolTables() as! Array<MPRow>
        functionStartsTables = parsing.getFunctionStartsTables() as! Array<MPRow>
    }
    
    func updateSymbolTables() {
        updateTables(items: Array<MPRow>(symbolTables.prefix(60)))
    }
    
    func updateStringTables() {
        updateTables(items: Array<MPRow>(stringTables.prefix(60)))
    }
    
    func updateDysymbolTables() {
        updateTables(items: Array<MPRow>(dysymbolTables.prefix(60)))
    }
    
    func updateFunctionStartsTables() {
        updateTables(items: Array<MPRow>(functionStartsTables.prefix(60)))
    }
    
    func updateTables(items: Array<MPRow>) {
        
        if !tableDetails.isEmpty {
            tableDetails.removeAll()
        }
        
        for item in items {
            tableDetails.append(DetailModel(offset: item.offset, data: item.data, description: item.descriptions, value: item.value))
        }
    }
    
    @Published var showAlert: Bool = false
    @Published var contentAlert: String = ""
    
    // Alert
    func getAlert() -> Alert {

        return Alert(
            title: Text("Tips"),
            message: Text(contentAlert),
            dismissButton: .default(Text("OK")))
    }
    
    func isShowingAlert() {
        self.showAlert = true
    }
    
    func noShowingAlert() {
        self.showAlert = false
    }
}
