//
//  MPLCSymtab.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCSymtab.h"

@implementation MPLCSymtab

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                         symoff:(uint32_t)_symoff
                          nsyms:(uint32_t)_nsyms
                         stroff:(uint32_t)_stroff
                        strsize:(uint32_t)_strsize {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.symoff = _symoff;
        self.nsyms = _nsyms;
        self.stroff = _stroff;
        self.strsize = _strsize;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Symbol Table Offset",
                             @"Number of Symbols",
                             @"String Table Offset",
                             @"String of Symbols", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _symoff],
                       [NSString stringWithFormat:@"%d", _nsyms],
                       [NSString stringWithFormat:@"%d", _stroff],
                       [NSString stringWithFormat:@"%d", _strsize], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                          symoff:(uint32_t)_symoff
                           nsyms:(uint32_t)_nsyms
                          stroff:(uint32_t)_stroff
                         strsize:(uint32_t)_strsize {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                  symoff:_symoff
                                   nsyms:_nsyms
                                  stroff:_stroff
                                 strsize:_strsize];
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
//    cursor->_offset += self.cmdsize - sizeof(symtab_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(symtab_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, symoff: %x, nsyms: %d, stroff: %x, strsize: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.symoff, self.nsyms, self.stroff, self.strsize];
}

@end
