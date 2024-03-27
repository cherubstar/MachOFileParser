//
//  MachOFileParsing.m
//  MachOParsing
//
//  Created by 小七 on 2023/11/27.
//

#import "MachOFileParsing.h"

@implementation MachOFileParsing

- (NSMutableDictionary *)parsing {
    
    // main image
    mach_header_t *_header = _dyld_get_image_header(0);
    
    NSMutableDictionary *macho = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *mach_header = [self getMachHeader:_header];
    NSMutableDictionary *load_commands = [self getLoadCommands];

    [macho setValue:mach_header forKey:@"MACH64 HEADER"];
    [macho setValue:load_commands forKey:@"LOAD COMMANDS"];
    
//    NSLog(@"[+] MachO File Parsing: %@", macho);
    
    return macho;
}

- (NSMutableArray *)getMachHeader:(mach_header_t *)_header {
    
    // slide
    intptr_t slide = _dyld_get_image_vmaddr_slide(0);
    NSUInteger current_offset = 0x100000000 + slide;        // image start offset
    
    // Get current slide
    self->_slide = slide;
    
    // Get start address
    self->_start_address = current_offset;
    
    // Initialize cursor, current offset
    self->_cursor = [[DataCursor alloc] initWithDataHeader:_header current_offset:current_offset];
    
    // To obtain the number of load commands
    self->_header = [MPMachHeader _initWithDataMagic:_header->magic
                                             cputype:_header->cputype
                                          cpusubtype:_header->cpusubtype
                                            filetype:_header->filetype
                                               ncmds:_header->ncmds
                                          sizeofcmds:_header->sizeofcmds
                                               flags:_header->flags
                                            reserved:_header->reserved];
    
    NSMutableArray *details = [self->_header getDetailsFromCursor:self->_cursor];
    
    // Obtain current offset after passing through the header
    self->_current_offset = self->_cursor->_current_offset;
    
    return details;
}

- (NSMutableDictionary *)getLoadCommands {
    
    // load command
    segment_command_t           *segment;
    symtab_command_t            *symtab;
    dysymtab_command_t          *dysymtab;
    dylinker_command_t          *dylinker;
    uuid_command_t              *uuid;
    build_version_command_t     *build;
    source_version_command_t    *source;
    entry_point_command_t       *main;
    encryption_info_command_t   *encryption;
//    dyld_info_command_t         *dyld;
    dylib_command_t             *dylib;
    rpath_command_t             *rpath;
    linkedit_data_command_t     *linkedit;
    // section
    section_t                   *section;
    
    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *segment_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *symtab_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dysymtab_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dylinker_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *uuid_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *build_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *source_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *main_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *encryption_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dylib_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *rpath_details = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *linkedit_details = [[NSMutableDictionary alloc] init];
    
    // Store command name for selected index
    self->_commands = [[NSMutableArray alloc] init];
    // Store section name for selected index
    self->_sections = [[NSMutableDictionary alloc] init];
    // Store all sections
    self->_section_details = [[NSMutableArray alloc] init];
    // first is 0
    [self->_section_details addObject:[[MPSection alloc] init]];
    
    for (int i = 0; i < self->_header.ncmds; i++, self->_current_offset += segment->cmdsize) {
        
        segment = (segment_command_t *)(self->_current_offset);
        
        switch (segment->cmd) {
            case LC_SEGMENT:
            {
                // not used?
                break;
            }
            case LC_SEGMENT_64:
            {
                self->_segment = [MPLCSegment _initWithDataCmd:segment->cmd
                                                       cmdsize:segment->cmdsize
                                                       segname:segment->segname
                                                        vmaddr:segment->vmaddr
                                                        vmsize:segment->vmsize
                                                       fileoff:segment->fileoff
                                                      filesize:segment->filesize
                                                       maxprot:segment->maxprot
                                                      initprot:segment->initprot
                                                        nsects:segment->nsects
                                                         flags:segment->flags];
                
                // current_segment
                NSMutableArray *segment_details = [self->_segment getDetailsFromCursor:self->_cursor];
                
                NSMutableDictionary *section_details = [[NSMutableDictionary alloc] init];
                // store current section name
                NSMutableArray *current_sectnames = [[NSMutableArray alloc] init];
                // Analyze the section in the current segment
                // point++，这里是指针+1
                for (int j = 0; j < segment->nsects; j++) {
                    section = (section_t *)(self->_current_offset + sizeof(segment_command_t)) + j;
                    self->_section = [MPSection _initWithDataSectname:section->sectname
                                                              segname:section->segname
                                                                 addr:section->addr
                                                                 size:section->size
                                                               offset:section->offset
                                                                algin:section->align
                                                               reloff:section->reloff
                                                               nreloc:section->nreloc
                                                                flags:section->flags
                                                            reserved1:section->reserved1
                                                            reserved2:section->reserved2
                                                            reserved3:section->reserved3];
                    
                    NSMutableArray *current_section = [self->_section getDetailsFromCursor:self->_cursor];
                    // 因为读取满 16 字节的 sectname 时，会连着将 segname 也读取到一块，所以需要进行截断
                    NSString *current_sectname = [NSString stringWithFormat:@"%s", section->sectname];
                    if ([current_sectname length] > 16) {
                        current_sectname = [current_sectname substringToIndex:16];
                    }
                    [section_details setValue:current_section forKey:current_sectname];
                    // Store current section name
                    [current_sectnames addObject:current_sectname];
                    // Store all sections
                    [self->_section_details addObject:self->_section];
                }
                
//                NSLog(@"[+] section_details: %@", section_details);
                
                if (strcmp(segment->segname, SEG_PAGEZERO) == 0) {
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__PAGEZERO)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__PAGEZERO)"];
                } else if (strcmp(segment->segname, SEG_TEXT) == 0) {
                    [details setValue:section_details forKey:@"SEG_TEXT_SECTION"];
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__TEXT)"];
                    
                    // [+] To get entry point
                    self->__TEXT_VMAddr = segment->vmaddr;
                    // [+] To get entry point
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__TEXT)"];
                    // store section name for selected index
                    [self->_sections setValue:current_sectnames forKey:@"SEG_TEXT_SECTION"];
                } else if (strcmp(segment->segname, SEG_DATA_CONST) == 0) {
                    [details setValue:section_details forKey:@"SEG_DATA_CONST_SECTION"];
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__DATA_CONST)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__DATA_CONST)"];
                    // store section name for selected index
                    [self->_sections setValue:current_sectnames forKey:@"SEG_DATA_CONST_SECTION"];
                } else if (strcmp(segment->segname, SEG_DATA) == 0) {
                    [details setValue:section_details forKey:@"SEG_DATA_SECTION"];
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__DATA)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__DATA)"];
                    // store section name for selected index
                    [self->_sections setValue:current_sectnames forKey:@"SEG_DATA_SECTION"];
                } else if (strcmp(segment->segname, SEG_OBJC) == 0) {
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__OBJC)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__OBJC)"];
                } else if (strcmp(segment->segname, SEG_ICON) == 0) {
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__ICON)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__ICON)"];
                } else if (strcmp(segment->segname, SEG_LINKEDIT) == 0) {
                    
                    // [+] Get linkedit segment
                    self->_linkedit_segment = segment;
                    // [+] Get linkedit segment
                    
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__LINKEDIT)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__LINKEDIT)"];
                } else if (strcmp(segment->segname, SEG_UNIXSTACK) == 0) {
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__UNIXSTACK)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__UNIXSTACK)"];
                } else if (strcmp(segment->segname, SEG_IMPORT) == 0) {
                    [details setValue:segment_details forKey:@"LC_SEGMENT_64(__IMPORT)"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_64(__IMPORT)"];
                }
                
//                [details setValue:segment_details forKey:@"LC_SEGMENT_64"];
                
                break;
            }
            case LC_SYMTAB:
            {
                symtab = (symtab_command_t *)segment;
                
                self->_symtab = [MPLCSymtab _initWithDataCmd:symtab->cmd
                                                     cmdsize:symtab->cmdsize
                                                      symoff:symtab->symoff
                                                       nsyms:symtab->nsyms
                                                      stroff:symtab->stroff
                                                     strsize:symtab->strsize];
                
                NSMutableArray *symtab_details = [self->_symtab getDetailsFromCursor:self->_cursor];
                [details setValue:symtab_details forKey:@"LC_SYMTAB"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_SYMTAB"];
                break;
            }
            case LC_DYSYMTAB:
            {
                dysymtab = (dysymtab_command_t *)segment;
                self->_dysymtab = [MPLCDysymtab _initWithDataCmd:dysymtab->cmd
                                                         cmdsize:dysymtab->cmdsize
                                                       ilocalsym:dysymtab->ilocalsym
                                                       nlocalsym:dysymtab->nlocalsym
                                                      iextdefsym:dysymtab->iextdefsym
                                                      nextdefsym:dysymtab->nextdefsym
                                                       iundefsym:dysymtab->iundefsym
                                                       nundefsym:dysymtab->nundefsym
                                                          tocoff:dysymtab->tocoff
                                                            ntoc:dysymtab->ntoc
                                                       modtaboff:dysymtab->modtaboff
                                                         nmodtab:dysymtab->nmodtab
                                                    extrefsymoff:dysymtab->extrefsymoff
                                                     nextrefsyms:dysymtab->nextrefsyms
                                                  indirectsymoff:dysymtab->indirectsymoff
                                                   nindirectsyms:dysymtab->nindirectsyms
                                                       extreloff:dysymtab->extreloff
                                                         nextrel:dysymtab->nextrel
                                                       locreloff:dysymtab->locreloff
                                                         nlocrel:dysymtab->nlocrel];
                
                NSMutableArray *dysymtab_details = [self->_dysymtab getDetailsFromCursor:self->_cursor];
                [details setValue:dysymtab_details forKey:@"LC_DYSYMTAB"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_DYSYMTAB"];
                break;
            }
            case LC_LOAD_DYLINKER:
            case LC_ID_DYLINKER:
            case LC_DYLD_ENVIRONMENT:
            {
                dylinker = (dylinker_command_t *)segment;
                self->_dylinker = [MPLCDylinker _initWithDataCmd:dylinker->cmd
                                                         cmdsize:dylinker->cmdsize
                                                          offset:dylinker->name.offset];
                
                // current_dylinker
                NSMutableArray *dylinker_details = [self->_dylinker getDetailsFromCursor:self->_cursor];
                
                if (dylinker->cmd == LC_LOAD_DYLINKER) {
                    [details setValue:dylinker_details forKey:@"LC_LOAD_DYLINKER"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_LOAD_DYLINKER"];
                } else if (dylinker->cmd == LC_ID_DYLINKER) {
                    [details setValue:dylinker_details forKey:@"LC_ID_DYLINKER"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_ID_DYLINKER"];
                }  else if (dylinker->cmd == LC_DYLD_ENVIRONMENT) {
                    [details setValue:dylinker_details forKey:@"LC_DYLD_ENVIRONMENT"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_DYLD_ENVIRONMENT"];
                }
                
//                [details setValue:dylinker_details forKey:@"LC_DYLINKER"];
                break;
            }
            case LC_UUID:
            {
                uuid = (uuid_command_t *)segment;
                self->_uuid = [MPLCUuid _initWithDataCmd:uuid->cmd
                                                 cmdsize:uuid->cmdsize
                                                    uuid:uuid->uuid];
                
                NSMutableArray *uuid_details = [self->_uuid getDetailsFromCursor:self->_cursor];
                [details setValue:uuid_details forKey:@"LC_UUID"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_UUID"];
                break;
            }
            case LC_BUILD_VERSION:
            {
                build = (build_version_command_t *)segment;
                self->_build = [MPLCBuildVersion _initWithDataCmd:build->cmd
                                                          cmdsize:build->cmdsize
                                                         platform:build->platform
                                                            minos:build->minos
                                                              sdk:build->sdk
                                                           ntools:build->ntools];
                
                NSMutableArray *build_details = [self->_build getDetailsFromCursor:self->_cursor];
                [details setValue:build_details forKey:@"LC_BUILD_VERSION"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_BUILD_VERSION"];
                break;
            }
            case LC_SOURCE_VERSION:
            {
                source = (source_version_command_t *)segment;
                self->_source = [MPLCSourceVersion _initWithDataCmd:source->cmd
                                                            cmdsize:source->cmdsize
                                                            version:source->version];
                
                NSMutableArray *source_details = [self->_source getDetailsFromCursor:self->_cursor];
                [details setValue:source_details forKey:@"LC_SOURCE_VERSION"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_SOURCE_VERSION"];
                break;
            }
            case LC_MAIN:
            {
                main = (entry_point_command_t *)segment;
                // [+] To get entry point
                uint64_t entrypoint = self->__TEXT_VMAddr + main->entryoff;
                self->_main = [MPLCMain _initWithDataCmd:main->cmd
                                                 cmdsize:main->cmdsize
                                                entryoff:main->entryoff
                                               stacksize:main->stacksize
                                              entrypoint:entrypoint];
                
                NSMutableArray *main_details = [self->_main getDetailsFromCursor:self->_cursor];
                [details setValue:main_details forKey:@"LC_MAIN"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_MAIN"];
                break;
            }
            case LC_ENCRYPTION_INFO:
            {
                // not used?
                break;
            }
            case LC_ENCRYPTION_INFO_64:
            {
                encryption = (encryption_info_command_t *)segment;
                self->_encryption = [MPLCEncryptionInfo _initWithDataCmd:encryption->cmd
                                                                 cmdsize:encryption->cmdsize
                                                                cryptoff:encryption->cryptoff
                                                               cryptsize:encryption->cryptsize
                                                                 cryptid:encryption->cryptid
                                                                     pad:encryption->pad];
                
                NSMutableArray *encryption_details = [self->_encryption getDetailsFromCursor:self->_cursor];
                [details setValue:encryption_details forKey:@"LC_ENCRYPTION_INFO_64"];
                
                // store command name for selected index
                [self->_commands addObject:@"LC_ENCRYPTION_INFO_64"];
                break;
            }
            case LC_LOAD_DYLIB:
            case LC_ID_DYLIB:
            case LC_LOAD_WEAK_DYLIB:
            case LC_REEXPORT_DYLIB:
//            case LC_LAZY_LOAD_DYLIB:
//            case LC_LOAD_UPWARD_DYLIB:
            {
                dylib = (dylib_command_t *)segment;
                self->_dylib = [MPLCLoadDylib _initWithDataCmd:dylib->cmd
                                                       cmdsize:dylib->cmdsize
                                                        offset:dylib->dylib.name.offset
                                                     timestamp:dylib->dylib.timestamp
                                               current_version:dylib->dylib.current_version
                                         compatibility_version:dylib->dylib.compatibility_version];
                
                // current_dylib
                NSMutableArray *dylib_details = [self->_dylib getDetailsFromCursor:self->_cursor];
                
                NSString *current_key = @"";
                
                if (dylib->cmd == LC_LOAD_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_LOAD_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                } else if (dylib->cmd == LC_ID_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_ID_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                } else if (dylib->cmd == LC_LOAD_WEAK_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_LOAD_WEAK_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                } else if (dylib->cmd == LC_REEXPORT_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_REEXPORT_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                } else if (dylib->cmd == LC_LAZY_LOAD_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_LAZY_LOAD_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                } else if (dylib->cmd == LC_LOAD_UPWARD_DYLIB) {
                    current_key = [NSString stringWithFormat:@"LC_LOAD_UPWARD_DYLIB(%@)", self->_dylib.name];
                    [details setValue:dylib_details forKey:current_key];
                    
                    // store command name for selected index
                    [self->_commands addObject:current_key];
                }
                
//                [details setValue:dylib_details forKey:@"LC_DYLIB"];
                break;
            }
            case LC_RPATH:
            {
                rpath = (rpath_command_t *)segment;
                self->_rpath = [MPLCRpath _initWithDataCmd:rpath->cmd
                                                   cmdsize:rpath->cmdsize
                                                    offset:rpath->path.offset];
                
                NSMutableArray *rpath_details = [self->_rpath getDetailsFromCursor:self->_cursor];
                NSString *cuurent_key = [NSString stringWithFormat:@"LC_RPATH(%@)", self->_rpath.path];
                [details setValue:rpath_details forKey:cuurent_key];
                
                // store command name for selected index
                [self->_commands addObject:cuurent_key];
                break;
            }
            case LC_CODE_SIGNATURE:
            case LC_SEGMENT_SPLIT_INFO:
            case LC_FUNCTION_STARTS:
            case LC_DATA_IN_CODE:
            case LC_DYLIB_CODE_SIGN_DRS:
            case LC_LINKER_OPTIMIZATION_HINT:
            case LC_DYLD_EXPORTS_TRIE:
            case LC_DYLD_CHAINED_FIXUPS:
            {
                linkedit = (linkedit_data_command_t *)segment;
                self->_linkedit = [MPLCLinkeditData _initWithDataCmd:linkedit->cmd
                                                             cmdsize:linkedit->cmdsize
                                                             dataoff:linkedit->dataoff
                                                            datasize:linkedit->datasize];
                
                // current_linkedit
                NSMutableArray *linkedit_details = [self->_linkedit getDetailsFromCursor:self->_cursor];
                
                if (linkedit->cmd == LC_CODE_SIGNATURE) {
                    [details setValue:linkedit_details forKey:@"LC_CODE_SIGNATURE"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_CODE_SIGNATURE"];
                } else if (linkedit->cmd == LC_SEGMENT_SPLIT_INFO) {
                    [details setValue:linkedit_details forKey:@"LC_SEGMENT_SPLIT_INFO"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_SEGMENT_SPLIT_INFO"];
                } else if (linkedit->cmd == LC_FUNCTION_STARTS) {
                    [details setValue:linkedit_details forKey:@"LC_FUNCTION_STARTS"];
                    
                    // [+] Get function starts
                    self->_function_starts = linkedit;
                    // [+] Get function starts
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_FUNCTION_STARTS"];
                } else if (linkedit->cmd == LC_DATA_IN_CODE) {
                    [details setValue:linkedit_details forKey:@"LC_DATA_IN_CODE"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_DATA_IN_CODE"];
                } else if (linkedit->cmd == LC_DYLIB_CODE_SIGN_DRS) {
                    [details setValue:linkedit_details forKey:@"LC_DYLIB_CODE_SIGN_DRS"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_DYLIB_CODE_SIGN_DRS"];
                } else if (linkedit->cmd == LC_LINKER_OPTIMIZATION_HINT) {
                    [details setValue:linkedit_details forKey:@"LC_LINKER_OPTIMIZATION_HINT"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_LINKER_OPTIMIZATION_HINT"];
                } else if (linkedit->cmd == LC_DYLD_EXPORTS_TRIE) {
                    [details setValue:linkedit_details forKey:@"LC_DYLD_EXPORTS_TRIE"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_DYLD_EXPORTS_TRIE"];
                } else if (linkedit->cmd == LC_DYLD_CHAINED_FIXUPS) {
                    [details setValue:linkedit_details forKey:@"LC_DYLD_CHAINED_FIXUPS"];
                    
                    // store command name for selected index
                    [self->_commands addObject:@"LC_DYLD_CHAINED_FIXUPS"];
                }
                
//                [details setValue:linkedit_details forKey:@"LC_LINKEDIT"];
                
                break;
            }
            default:
            {
                NSLog(@"[+] Not Found!");
                break;
            }
        }
    }
    
//    NSLog(@"[+] details: %@", details);
    
    return details;
}

- (NSMutableArray *)getSymbolTables {
    
    self->_symbol_tables = [[NSMutableArray alloc] init];
    self->_string_tables = [[NSMutableArray alloc] init];
    self->_symbol_table_details = [[NSMutableDictionary alloc] init];

    // [+] Get linkedit base address
    uintptr_t linkedit_base = self->_slide + self->_linkedit_segment->vmaddr - self->_linkedit_segment->fileoff;
    
    // [+] Get symbol table address
    uint32_t *symtab = (uint32_t *)(linkedit_base + self->_symtab.symoff);
    
    // [+] Get string table address
    char *strtab = (char *)(self->_start_address + self->_symtab.stroff);
    
    // [+] Set current offset
    self->_cursor->_current_offset = (NSUInteger)symtab;
    self->_cursor->_offset = (NSUInteger)symtab - self->_start_address;
    
    nlist_t *nlist = (nlist_t *)symtab;
    
    // [+] Get symbol table
    for (int i = 0; i < self->_symtab.nsyms; i++) {
    
        self->_symbolTable = [MPSymbolTable _initWithDataN_strx:nlist->n_un.n_strx
                                                         n_type:nlist->n_type
                                                         n_sect:nlist->n_sect
                                                         n_desc:nlist->n_desc
                                                        n_value:nlist->n_value];
        
        MPSection *section = [self->_section_details objectAtIndex:nlist->n_sect];
        NSMutableArray *symbol_table = [self->_symbolTable getDetailsFromCursor:self->_cursor strtab:strtab section:section];

        // [+] Get symbol table array
        [self->_symbol_tables addObjectsFromArray:symbol_table];
        
        // [+] Get symbol table details
        [self->_symbol_table_details setValue:self->_symbolTable forKey:[NSString stringWithFormat:@"%d", i]];
        
        nlist++;
    }
    
    // [+] Set current offset
    self->_cursor->_current_offset = (NSUInteger)strtab;
    self->_cursor->_offset = (NSUInteger)self->_symtab.stroff;
    
    // [+] Get string table
    while (strlen(strtab) != 0) {
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", strtab]
                                           data:[NSString stringWithFormat:@"%@0", [self->_cursor readDataOfLength:strlen(strtab) + 1]]
                                    description:[NSString stringWithFormat:@"CString (length: %lu)", strlen(strtab)]
                                          value:[NSString stringWithFormat:@"%s", strtab]];
        
        strtab += strlen(strtab) + 1;
        
        [self->_string_tables addObject:row];
    }
    
//    NSLog(@"[+] _symbol_tables: %@", self->_symbol_tables);
    return self->_symbol_tables;
}

- (NSMutableArray *)getStringTables {
    
//    NSLog(@"[+] _string_tables: %@", self->_string_tables);
    return self->_string_tables;
}

- (NSMutableArray *)getDysymbolTables {
    
    self->_dysymbol_tables = [[NSMutableArray alloc] init];
    
    // [+] Get linkedit base address
    uintptr_t linkedit_base = self->_slide + self->_linkedit_segment->vmaddr - self->_linkedit_segment->fileoff;
    
    // [+] Get string table address
    char *strtab = (char *)(self->_start_address + self->_symtab.stroff);
    
    // [+] Get dysymbol table address, Symbol index
    uint32_t *indirect_symtab = (uint32_t *)(linkedit_base + self->_dysymtab.indirectsymoff);
    
    // [+] Set current offset
    self->_cursor->_current_offset = (NSUInteger)indirect_symtab;
    self->_cursor->_offset = (NSUInteger)indirect_symtab - self->_start_address;
    
    // [+] symbol table loop
    for (uint32_t indirect_symtab_index = 0; indirect_symtab_index < self->_dysymtab.nindirectsyms; indirect_symtab_index++) {

        uint32_t nsect = (uint32_t)self->_section_details.count;
        // [+] section loop
        while (--nsect > 0) {
            
            MPSection *section = [self->_section_details objectAtIndex:nsect];
            
            if (((section.flags & SECTION_TYPE) != S_SYMBOL_STUBS &&
                 (section.flags & SECTION_TYPE) != S_LAZY_SYMBOL_POINTERS &&
                 (section.flags & SECTION_TYPE) != S_LAZY_DYLIB_SYMBOL_POINTERS &&
                 (section.flags & SECTION_TYPE) != S_NON_LAZY_SYMBOL_POINTERS) ||
                section.reserved1 > indirect_symtab_index) {
                
                // section type or indirect symbol index mismatch
                continue;
            }
            
            // calculate stub or pointer length
            uint32_t length = (section.reserved2 > 0 ? section.reserved2 : sizeof(uint64_t));
              
            // calculate indirect value location
            uint64_t indirectAddress = section.addr + (indirect_symtab_index - section.reserved1) * length;
            
            // read indirect symbol index
            uint32_t indirectIndex = *indirect_symtab;
            
            if ((indirectIndex & (INDIRECT_SYMBOL_LOCAL | INDIRECT_SYMBOL_ABS)) == 0) {
                
                if (indirectIndex >= self->_symbol_table_details.count)
                {
                    [NSException raise:@"Symbol Table Index"
                                format:@"index is out of range %u", indirectIndex];
                }
                
                // Get symbol table details by indirect index
                MPSymbolTable *symtab = [self->_symbol_table_details objectForKey:[NSString stringWithFormat:@"%d", indirectIndex]];
                
                // func_ptr
                const char *func_ptr = strtab + symtab.n_strx;
                
                // symbol_table (func_name)
                NSString *symbolTable = [[NSString alloc] initWithBytes:func_ptr length:strlen(func_ptr) encoding:NSASCIIStringEncoding];

                // section index
                NSString *sectionIndex = [NSString stringWithFormat:@"(%s, %s)", section.segname, section.sectname];
                
                self->_dysymbolTable = [MPDysymbolTable _initWithDataIndirectIndex:indirectIndex
                                                                       symbolTable:symbolTable
                                                                      sectionIndex:sectionIndex
                                                                   indirectAddress:indirectAddress];
                
                NSMutableArray *dysymbol_table = [self->_dysymbolTable getDetailsFromCursor:self->_cursor];
                
                // [+] Get dysymbol table array
                [self->_dysymbol_tables addObjectsFromArray:dysymbol_table];
                
            } else {
                NSLog(@"[+] -------------------");
            }
            
            break;  // [+] end the section loop
        }

        indirect_symtab++;
    }
    
//    NSLog(@"[+] _dysymbol_tables : %@", self->_dysymbol_tables);
    return self->_dysymbol_tables;
}

- (NSMutableArray *)getFunctionStartsTables {
    
    self->_function_starts_tables = [[NSMutableArray alloc] init];
    
    // [+] Set current offset
    self->_cursor->_current_offset = (NSUInteger)(self->_function_starts);
    self->_cursor->_offset = (NSUInteger)(self->_function_starts - self->_start_address);
    
    //
    NSLog(@"[+] dataoff: %d", self->_function_starts->dataoff);
    
    return self->_function_starts_tables;
}

# pragma mark Specific information
- (NSMutableArray *)getCommands {
    
//    NSLog(@"[+] commands: %@", self->commands);
    return self->_commands;
}

- (NSMutableDictionary *)getSections {
    
//    NSLog(@"[+] sections: %@", self->sections);
    return self->_sections;
}

- (NSString *)getFileType {
    
//    NSLog(@"[+] filetype: %@", [self->_header getFileType:self->_header.filetype]);
    return [self->_header getFileTypeDetail:self->_header.filetype];
}

- (NSString *)getBaseInfo {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];

    NSString *baseInfo = [NSString stringWithFormat:@"%s, %@ %@, %@ %@", systemInfo.machine, device.model, device.systemVersion, info[@"CFBundleName"], info[@"CFBundleShortVersionString"]];
    
//    NSLog(@"[+] baseInfo: %@", baseInfo);
    
    return baseInfo;
}

@end
