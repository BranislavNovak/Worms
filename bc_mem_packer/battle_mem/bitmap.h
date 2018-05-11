
#ifndef _BITMAP_H
#define _BITMAP_H

#pragma pack( push, 1 )

typedef struct {
    unsigned short  f_type;
    unsigned long   f_size;
    unsigned short  reserved1;
    unsigned short  reserved2;
    unsigned long   offset;
} bitmap_file_header_t;

typedef struct {
    unsigned long   size;
    long            width;
    long            height;
    unsigned short  planes;
    unsigned short  bits_count;
    unsigned long   compression;
    unsigned long   bitmap_size;
    long            h_res;
    long            v_res;
    unsigned long   colors;
    unsigned long   important_colors;
	unsigned long   red_channel_bitmask;
	unsigned long   green_channel_bitmask;
	unsigned long   blue_channel_bitmask;
	unsigned long   alpha_channel_bitmask;
	unsigned long   color_space_type;
} bitmap_info_header_t;

#pragma pack( pop )

unsigned char * load_bitmap(
	const char * file,
	bitmap_file_header_t*    bmp_file_hdr,
	bitmap_info_header_t*    bmp_info_hdr
);

#endif // _BITMAP_H