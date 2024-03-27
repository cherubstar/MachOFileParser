//
//  MPSymbolTable.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/10.
//

#import "MPSymbolTable.h"

@implementation MPSymbolTable

- (instancetype)initWithDataN_strx:(uint32_t)_n_strx
                            n_type:(uint8_t)_n_type
                            n_sect:(uint8_t)_n_sect
                            n_desc:(uint16_t)_n_desc
                           n_value:(uint64_t)_n_value {
    
    if (self = [super init]) {
        self.n_strx = _n_strx;
        self.n_type = _n_type;
        self.n_sect = _n_sect;
        self.n_desc = _n_desc;
        self.n_value = _n_value;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"String Table Index",
                             @"Type",
                             @"Section Index",
                             @"Description",
                             @"Value", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [NSString stringWithFormat:@"%d", _n_strx],
                       [NSString stringWithFormat:@"%d", _n_type],
                       [NSString stringWithFormat:@"%d", _n_sect],
                       [NSString stringWithFormat:@"%d", _n_desc],
                       [NSString stringWithFormat:@"%lld", _n_value], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataN_strx:(uint32_t)_n_strx
                             n_type:(uint8_t)_n_type
                             n_sect:(uint8_t)_n_sect
                             n_desc:(uint16_t)_n_desc
                            n_value:(uint64_t)_n_value {
    
    return [[self alloc] initWithDataN_strx:_n_strx
                                     n_type:_n_type
                                     n_sect:_n_sect
                                     n_desc:_n_desc
                                    n_value:_n_value];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor strtab:(char *)strtab section:(MPSection *)section {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        if ( [self.descriptions[i] isEqualToString:@"String Table Index"] ) {
            
            data = [cursor readLittleInt32];
            
            description = [NSString stringWithFormat:@"%@, #%d", description, self->_n_strx];
            
            if (self->_n_strx == 1) {
                value = @"None";
            } else {
                const char *func_ptr = strtab + self.n_strx;
                // func_name
                value = [[NSString alloc] initWithBytes:func_ptr length:strlen(func_ptr) encoding:NSASCIIStringEncoding];
            }
            
        } else if ( [self.descriptions[i] isEqualToString:@"Type"] ) {
            data = [cursor readByte];
            // value
            
        } else if ( [self.descriptions[i] isEqualToString:@"Section Index"] ) {
            
            data = [cursor readByte];
            
            // value
            if (self->_n_sect == 0) {
                value = @"NO_SECT";
            } else {
                value = [NSString stringWithFormat:@"%u (%s, %s)", self->_n_sect, section.segname, section.sectname];
            }
            
        }  else if ( [self.descriptions[i] isEqualToString:@"Description"] ) {
            data = [cursor readLittleInt16];
            
        } else if ( [self.descriptions[i] isEqualToString:@"Value"] ) {
            data = [cursor readLittleInt64];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> n_strx: 0x%08x, n_type: %d, n_sect: %d, n_desc: %d, n_value: %lld",
            NSStringFromClass([self class]), self,
            self.n_strx, self.n_type, self.n_sect, self.n_desc, self.n_value];
}

@end
