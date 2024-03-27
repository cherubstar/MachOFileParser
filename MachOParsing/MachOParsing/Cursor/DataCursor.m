//
//  DataCursor.m
//  MachOParsing
//
//  Created by 小七 on 2023/11/27.
//

#import "DataCursor.h"

@implementation DataCursor

- (id)initWithDataHeader:(mach_header_t *)header current_offset:(NSUInteger)current_offset;
{
    if ((self = [super init])) {
        _header = header;
        _current_offset = current_offset;
        _offset = 0;
    }

    return self;
}

#pragma mark Little Endian

- (uint8_t)readByte;
{
    uint8_t result = OSReadLittleInt16(_header, _offset) & 0xFF;
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (uint16_t)readLittleInt16;
{
    uint16_t result = OSReadLittleInt16(_header, _offset);;
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (uint32_t)readLittleInt32;
{
    uint32_t result = OSReadLittleInt32(_header, _offset);
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (uint64_t)readLittleInt64;
{
    uint64_t result = OSReadLittleInt64(_header, _offset);
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

#pragma mark Big Endian
- (uint16_t)readBigInt16;
{
    uint32_t result = OSReadBigInt16(_header, _offset);
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (uint32_t)readBigInt32;
{
    uint32_t result = OSReadBigInt32(_header, _offset);
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (uint64_t)readBigInt64;
{
    uint64_t result = OSReadBigInt64(_header, _offset);
    _current_offset += sizeof(result);
    _offset += sizeof(result);

    return result;
}

- (NSString *)readBigInt128;
{
    NSUInteger data1 = [self readBigInt64];
    NSUInteger data2 = [self readBigInt64];
    
    return [NSString stringWithFormat:@"%.8lX%.8lX", data1, data2];
}

- (NSString *)readDataOfLength:(NSUInteger)length {

    NSString *data = @"";
    
    for (int i = 0; i < length; i++) {
        NSString *a_byte = [NSString stringWithFormat:@"%X", [self readByte]];
        data = [data stringByAppendingString:a_byte];
    }
    
    return data;
}

#pragma mark Float
- (float)readLittleFloat32;
{
    uint32_t val;

    val = [self readLittleInt32];
    return *(float *)&val;
}

- (float)readBigFloat32;
{
    uint32_t val;

    val = [self readBigInt32];
    return *(float *)&val;
}

- (double)readLittleFloat64;
{
    uint32_t v1, v2, *ptr;
    double dval;

    v1 = [self readLittleInt32];
    v2 = [self readLittleInt32];
    ptr = (uint32_t *)&dval;
    *ptr++ = v1;
    *ptr = v2;

    return dval;
}

- (NSString *)readStringOfLength:(NSUInteger)length encoding:(NSStringEncoding)encoding;
{
    NSString *str;

    if (encoding == NSASCIIStringEncoding) {
        char *buf;

        // Jump through some hoops if the length is padded with zero bytes, as in the case of 10.5's Property List Editor and iSync Plug-in Maker.
        buf = malloc(length + 1);
        if (buf == NULL) {
            NSLog(@"Error: malloc() failed.");
            return nil;
        }

        strncpy(buf, (const char *)_header + _offset, length);
        buf[length] = 0;

        str = [[NSString alloc] initWithBytes:buf length:strlen(buf) encoding:encoding];
//        _current_offset += length;
//        _offset += length;
        free(buf);
        return str;
    } else {
        str = [[NSString alloc] initWithBytes:(uint8_t *)_header + _offset length:length encoding:encoding];
//        _current_offset += length;
//        _offset += length;
        return str;
    }

    return nil;
}

@end
