//
//  MachOFileParsing.h
//  MachOParsing
//
//  Created by 小七 on 2023/11/27.
//

#import <Foundation/Foundation.h>

#import "Prefix.h"
#import "MPSymbolTable.h"
#import "MPDysymbolTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MachOFileParsing : NSObject
{
    DataCursor          *_cursor;
    MPMachHeader        *_header;
    MPLCSegment         *_segment;
    MPLCSymtab          *_symtab;
    MPLCDysymtab        *_dysymtab;
    MPLCDylinker        *_dylinker;
    MPLCUuid            *_uuid;
    MPLCBuildVersion    *_build;
    MPLCSourceVersion   *_source;
    MPLCMain            *_main;
    MPLCEncryptionInfo  *_encryption;
    MPLCDyldInfo        *_dyld;
    MPLCLoadDylib       *_dylib;
    MPLCRpath           *_rpath;
    MPLCLinkeditData    *_linkedit;
    
    MPSection           *_section;
    
    MPSymbolTable       *_symbolTable;
    MPDysymbolTable     *_dysymbolTable;
    
    intptr_t _slide;
    NSUInteger _current_offset;
    NSUInteger _start_address;
    // [+] Get linkedit segment
    segment_command_t *_linkedit_segment;
    // [+] Get function starts
    linkedit_data_command_t *_function_starts;

    // [+] Get symbol table
    NSMutableArray *_symbol_tables;
    // [+] Get string table
    NSMutableArray *_string_tables;
    // [+] Get dysymbol table
    NSMutableArray *_dysymbol_tables;
    // [+] Get function starts table
    NSMutableArray *_function_starts_tables;
    
    // [+] Get this array
    NSMutableArray *_commands;
    NSMutableDictionary *_sections;
    
    // [+] Get all sections details
    NSMutableArray *_section_details;
    
    // [+] Get symbol table details
    NSMutableDictionary *_symbol_table_details;
    
    // [+] To get entry point
    uint64_t __TEXT_VMAddr;

}

- (NSMutableDictionary *)parsing;
- (NSMutableArray *)getSymbolTables;
- (NSMutableArray *)getStringTables;
- (NSMutableArray *)getDysymbolTables;
- (NSMutableArray *)getFunctionStartsTables;
- (NSString *)getFileType;
- (NSString *)getBaseInfo;
- (NSMutableArray *)getCommands;
- (NSMutableDictionary *)getSections;

@end

NS_ASSUME_NONNULL_END
