//
//  DataCursor.h
//  MachOParsing
//
//  Created by 小七 on 2023/11/27.
//

#import <Foundation/Foundation.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataCursor : NSObject
{
    @public NSUInteger _offset;
    @public NSUInteger _current_offset;
    mach_header_t *_header;
}

- (id)initWithDataHeader:(mach_header_t *)header current_offset:(NSUInteger)current_offset;
- (uint8_t)readByte;
- (uint16_t)readLittleInt16;
- (uint32_t)readLittleInt32;
- (uint64_t)readLittleInt64;
- (uint32_t)readBigInt32;
- (uint64_t)readBigInt64;
- (NSString *)readBigInt128;
- (NSString *)readDataOfLength:(NSUInteger)length;
- (NSString *)readStringOfLength:(NSUInteger)length encoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
