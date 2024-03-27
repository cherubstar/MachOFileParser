//
//  MPDysymbolTable.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

#import "MPDysymbolTable.h"

@implementation MPDysymbolTable

- (instancetype)initWithDataIndirectIndex:(uint32_t)_indirectIndex
                              symbolTable:(NSString *)_symbolTable
                             sectionIndex:(NSString *)_sectionIndex
                          indirectAddress:(uint64_t)_indirectAddress {
    
    if (self = [super init]) {
        
        self.indirectIndex = _indirectIndex;
        self.symbolTable = _symbolTable;
        self.sectionIndex = _sectionIndex;
        self.indirectAddress = _indirectAddress;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             [NSString stringWithFormat:@"Symbol Table Index, #%d", _indirectIndex],
                             @"Section Index",
                             @"Indirect Address", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       _symbolTable,
                       _sectionIndex,
                       [NSString stringWithFormat:@"%llX", _indirectAddress], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataIndirectIndex:(uint32_t)_indirectIndex
                               symbolTable:(NSString *)_symbolTable
                              sectionIndex:(NSString *)_sectionIndex
                           indirectAddress:(uint64_t)_indirectAddress {
    
    return [[self alloc] initWithDataIndirectIndex:_indirectIndex
                                       symbolTable:_symbolTable
                                      sectionIndex:_sectionIndex
                                   indirectAddress:_indirectAddress];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self->_values[i];
        
        if ( [self.descriptions[i] isEqualToString:[NSString stringWithFormat:@"Symbol Table Index, #%d", self->_indirectIndex]] ) {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:data == 0 ? @"-" : [NSString stringWithFormat:@"%.8lX", offset]
                                           data:data == 0 ? @"-" : [NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    return details;
}

@end
