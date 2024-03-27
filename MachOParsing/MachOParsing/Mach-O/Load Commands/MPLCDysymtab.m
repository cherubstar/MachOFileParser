//
//  MPLCDysymtab.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCDysymtab.h"

@implementation MPLCDysymtab

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                      ilocalsym:(uint32_t)_ilocalsym
                      nlocalsym:(uint32_t)_nlocalsym
                     iextdefsym:(uint32_t)_iextdefsym
                     nextdefsym:(uint32_t)_nextdefsym
                      iundefsym:(uint32_t)_iundefsym
                      nundefsym:(uint32_t)_nundefsym
                         tocoff:(uint32_t)_tocoff
                           ntoc:(uint32_t)_ntoc
                      modtaboff:(uint32_t)_modtaboff
                        nmodtab:(uint32_t)_nmodtab
                   extrefsymoff:(uint32_t)_extrefsymoff
                    nextrefsyms:(uint32_t)_nextrefsyms
                 indirectsymoff:(uint32_t)_indirectsymoff
                  nindirectsyms:(uint32_t)_nindirectsyms
                      extreloff:(uint32_t)_extreloff
                        nextrel:(uint32_t)_nextrel
                      locreloff:(uint32_t)_locreloff
                        nlocrel:(uint32_t)_nlocrel {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.ilocalsym = _ilocalsym;
        self.nlocalsym = _nlocalsym;
        self.iextdefsym = _iextdefsym;
        self.nextdefsym = _nextdefsym;
        self.iundefsym = _iundefsym;
        self.nundefsym = _nundefsym;
        self.tocoff = _tocoff;
        self.ntoc = _ntoc;
        self.modtaboff = _modtaboff;
        self.nmodtab = _nmodtab;
        self.extrefsymoff = _extrefsymoff;
        self.nextrefsyms = _nextrefsyms;
        self.indirectsymoff = _indirectsymoff;
        self.nindirectsyms = _nindirectsyms;
        self.extreloff = _extreloff;
        self.nextrel = _nextrel;
        self.locreloff = _locreloff;
        self.nlocrel = _nlocrel;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Local Symbol Index",
                             @"Local Symbol Number",
                             @"Defined ExtSymbol Index",
                             @"Defined ExtSymbol Number",
                             @"Undef ExtSymbol Index",
                             @"Undef ExtSymbol Number",
                             @"TOC Offset",
                             @"TOC Entries",
                             @"Module Table Offset",
                             @"Module Table Entries",
                             @"ExtRef Table Offset",
                             @"ExtRef Table Entries",
                             @"IndSym Table Offset",
                             @"IndSym Table Entries",
                             @"ExtReloc Table Offset",
                             @"ExtReloc Table Entries",
                             @"LocReloc Table Offset",
                             @"LocReloc Table Entries", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _ilocalsym],
                       [NSString stringWithFormat:@"%d", _nlocalsym],
                       [NSString stringWithFormat:@"%d", _iextdefsym],
                       [NSString stringWithFormat:@"%d", _nextdefsym],
                       [NSString stringWithFormat:@"%d", _iundefsym],
                       [NSString stringWithFormat:@"%d", _nundefsym],
                       [NSString stringWithFormat:@"%d", _tocoff],
                       [NSString stringWithFormat:@"%d", _ntoc],
                       [NSString stringWithFormat:@"%d", _modtaboff],
                       [NSString stringWithFormat:@"%d", _nmodtab],
                       [NSString stringWithFormat:@"%d", _extrefsymoff],
                       [NSString stringWithFormat:@"%d", _nextrefsyms],
                       [NSString stringWithFormat:@"%d", _indirectsymoff],
                       [NSString stringWithFormat:@"%d", _nindirectsyms],
                       [NSString stringWithFormat:@"%d", _extreloff],
                       [NSString stringWithFormat:@"%d", _nextrel],
                       [NSString stringWithFormat:@"%d", _locreloff],
                       [NSString stringWithFormat:@"%d", _nlocrel], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                       ilocalsym:(uint32_t)_ilocalsym
                       nlocalsym:(uint32_t)_nlocalsym
                      iextdefsym:(uint32_t)_iextdefsym
                      nextdefsym:(uint32_t)_nextdefsym
                       iundefsym:(uint32_t)_iundefsym
                       nundefsym:(uint32_t)_nundefsym
                          tocoff:(uint32_t)_tocoff
                            ntoc:(uint32_t)_ntoc
                       modtaboff:(uint32_t)_modtaboff
                         nmodtab:(uint32_t)_nmodtab
                    extrefsymoff:(uint32_t)_extrefsymoff
                     nextrefsyms:(uint32_t)_nextrefsyms
                  indirectsymoff:(uint32_t)_indirectsymoff
                   nindirectsyms:(uint32_t)_nindirectsyms
                       extreloff:(uint32_t)_extreloff
                         nextrel:(uint32_t)_nextrel
                       locreloff:(uint32_t)_locreloff
                         nlocrel:(uint32_t)_nlocrel {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                               ilocalsym:_ilocalsym
                               nlocalsym:_nlocalsym
                              iextdefsym:_iextdefsym
                              nextdefsym:_nextdefsym
                               iundefsym:_iundefsym
                               nundefsym:_nundefsym
                                  tocoff:_tocoff
                                    ntoc:_ntoc
                               modtaboff:_modtaboff
                                 nmodtab:_nmodtab
                            extrefsymoff:_extrefsymoff
                             nextrefsyms:_nextrefsyms
                          indirectsymoff:_indirectsymoff
                           nindirectsyms:_nindirectsyms
                               extreloff:_extreloff
                                 nextrel:_nextrel
                               locreloff:_locreloff
                                 nlocrel:_nlocrel];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = [cursor readLittleInt32];
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(dysymtab_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(dysymtab_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, ilocalsym: %x, nlocalsym: %d, iextdefsym: %x, nextdefsym: %d, iundefsym: %d, nundefsym: %d, tocoff: %d, ntoc: %d, modtaboff: %d, nmodtab: %d, extrefsymoff: %d, nextrefsyms: %d, indirectsymoff: %d, nindirectsyms: %d, extreloff: %d, nextrel: %d, locreloff: %d, nlocrel: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.ilocalsym, self.nlocalsym, self.iextdefsym, self.nextdefsym, self.iundefsym, self.nundefsym, self.tocoff, self.ntoc, self.modtaboff, self.nmodtab, self.extrefsymoff, self.nextrefsyms, self.indirectsymoff, self.nindirectsyms, self.extreloff, self.nextrel, self.locreloff, self.nlocrel];
}

@end
