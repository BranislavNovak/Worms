#include "battle_city.h"
#include "map.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xio.h"
#include <math.h>
#include "obstacle_detect.h"

/*
 * GENERATED BY BC_MEM_PACKER
 * DATE: Wed Jul 08 21:00:48 2015
 */

// ***** 16x16 IMAGES *****
#define IMG_16x16_cigle			0x00FF //2				// treba izmenjati lepo i uklopiti sta je sta
#define IMG_16x16_coin			0x013F //5				// bilo bi kul da izmenimo sva imena, pa umesto cigle, da je lepo blato, crv i sve
#define IMG_16x16_crno			0x017F //0
#define IMG_16x16_enemi1		0x01BF //4
#define IMG_16x16_mario			0x01FF //1
#define IMG_16x16_plavacigla	0x023F //3
#define IMG_16x16_tobla3		0x027F //6
// ***** MAP *****

#define MAP_BASE_ADDRESS				703 // MAP_OFFSET in battle_city.vhd
#define MAP_X							0
#define MAP_X2							640
#define MAP_Y							4
#define MAP_W							64
#define MAP_H							56

#define REGS_BASE_ADDRESS               (4096)

#define BTN_DOWN( b )                   ( !( b & 0x01 ) )
#define BTN_UP( b )                     ( !( b & 0x10 ) )
#define BTN_LEFT( b )                   ( !( b & 0x02 ) )
#define BTN_RIGHT( b )                  ( !( b & 0x08 ) )
#define BTN_SHOOT( b )                  ( !( b & 0x04 ) )

#define TANK1_REG_L                     8
#define TANK1_REG_H                     9
#define TANK_AI_REG_L                   4
#define TANK_AI_REG_H                   5
#define TANK_AI_REG_L2                  6
#define TANK_AI_REG_H2                  7
#define TANK_AI_REG_L3                  2
#define TANK_AI_REG_H3                  3
#define TANK_AI_REG_L4                  10
#define TANK_AI_REG_H4                  11
#define TANK_AI_REG_L5                  12
#define TANK_AI_REG_H5                  13
#define TANK_AI_REG_L6                  14
#define TANK_AI_REG_H6                  15
#define TANK_AI_REG_L7                  16
#define TANK_AI_REG_H7                  17
#define BASE_REG_L						0
#define BASE_REG_H	                    1

#define MAX_JUMP	                    70

int lives = 0;
int score = 0;
int mapPart = 1;
int udario_glavom_skok = 0;
int map_move = 0;
int brojac = 0;
int udario_u_blok = 0;
int nivo = 1;
int start_jump = 0;
int start_fall = 0;
int jump_cnt = 0;

typedef enum {
	b_false, b_true
} bool_t;

typedef enum {
	DIR_LEFT, DIR_RIGHT, DIR_UP, DIR_DOWN, DIR_STILL, DIR_UP_LEFT, DIR_UP_RIGHT
} direction_t;

typedef struct {
	unsigned int x;
	unsigned int y;
	direction_t dir;
	unsigned int type;

	bool_t destroyed;

	unsigned int reg_l;
	unsigned int reg_h;
} characters;

characters mario = { 10,	                        // x
		431, 		                     // y
		DIR_RIGHT,              		// dir
		IMG_16x16_mario,  			// type

		b_false,                		// destroyed

		TANK1_REG_L,            		// reg_l
		TANK1_REG_H             		// reg_h
		};

characters enemie1 = { 331,						// x
		431,						// y
		DIR_LEFT,              		// dir
		IMG_16x16_enemi1,  		// type

		b_false,                		// destroyed

		TANK_AI_REG_L,            		// reg_l
		TANK_AI_REG_H             		// reg_h
		};

characters enemie2 = { 450,						// x
		431,						// y
		DIR_LEFT,              		// dir
		IMG_16x16_enemi1,  		// type

		b_false,                		// destroyed

		TANK_AI_REG_L2,            		// reg_l
		TANK_AI_REG_H2             		// reg_h
		};

characters enemie3 = { 330,						// x
		272,						// y
		DIR_LEFT,              		// dir
		IMG_16x16_enemi1,  		// type

		b_false,                		// destroyed

		TANK_AI_REG_L3,            		// reg_l
		TANK_AI_REG_H3             		// reg_h
		};

characters enemie4 = { 635,						// x
		431,						// y
		DIR_LEFT,              		// dir
		IMG_16x16_enemi1,  		// type

		b_false,                		// destroyed

		TANK_AI_REG_L4,            		// reg_l
		TANK_AI_REG_H4             		// reg_h
		};

unsigned int rand_lfsr113(void) {
	static unsigned int z1 = 12345, z2 = 12345;
	unsigned int b;

	b = ((z1 << 6) ^ z1) >> 13;
	z1 = ((z1 & 4294967294U) << 18) ^ b;
	b = ((z2 << 2) ^ z2) >> 27;
	z2 = ((z2 & 4294967288U) << 2) ^ b;

	return (z1 ^ z2);
}

static void chhar_spawn(characters * chhar) {
	Xil_Out32(
			XPAR_BATTLE_CITY_PERIPH_0_BASEADDR + 4 * ( REGS_BASE_ADDRESS + chhar->reg_l ),
			(unsigned int )0x8F000000 | (unsigned int )chhar->type);
	Xil_Out32(
			XPAR_BATTLE_CITY_PERIPH_0_BASEADDR + 4 * ( REGS_BASE_ADDRESS + chhar->reg_h ),
			(chhar->y << 16) | chhar->x);
}

static void map_update(characters * mario) {
	int x, y;
	long int addr;

	if (mario->x >= 620 && nivo==1) {
			nivo=2;
			if (udario_u_blok <= 0) {
				map_move+=620;
				//chhar_spawn(mario);
			}
			if (mario->x == 2560) {
				map_move = 2520;
			}
		}

	for (y = 0; y < MAP_HEIGHT; y++) {
		for (x = 0; x < MAP_WIDTH; x++) {
			addr = XPAR_BATTLE_CITY_PERIPH_0_BASEADDR
					+ 4 * (MAP_BASE_ADDRESS + y * MAP_WIDTH + x);
			switch (map1[y][x + map_move]) {
			case 0:
				Xil_Out32(addr, IMG_16x16_crno);
				break;
			case 1:
				Xil_Out32(addr, IMG_16x16_mario);
				break;
			case 2:
				Xil_Out32(addr, IMG_16x16_cigle);
				break;
			case 3:
				Xil_Out32(addr, IMG_16x16_plavacigla);
				break;
			case 4:
				Xil_Out32(addr, IMG_16x16_enemi1);
				break;
			case 5:
				Xil_Out32(addr, IMG_16x16_coin);
				break;
			case 6:
				Xil_Out32(addr, IMG_16x16_tobla3);
				break;
			default:
				Xil_Out32(addr, IMG_16x16_crno);
				break;
			}
		}
	}
}

static void map_reset(unsigned char * map) {

	unsigned int i;

	for (i = 0; i <= 20; i += 2) {
		Xil_Out32(
				XPAR_BATTLE_CITY_PERIPH_0_BASEADDR + 4 * ( REGS_BASE_ADDRESS + i ),
				(unsigned int )0x0F000000);
	}

}

static bool_t mario_move(unsigned char * map, characters * mario,
		direction_t dir, int start_jump) {
	unsigned int x;
	unsigned int y;
	int i, j;

	float Xx;
	float Yy;
	int roundX = 0;
	int roundY = 0;

	int obstackle = 0;

	if (mario->x > ((MAP_X + MAP_WIDTH) * 16 - 16)
			|| mario->y > (MAP_Y + MAP_HEIGHT) * 16 - 16) {
		return b_false;
	}

	x = mario->x;
	y = mario->y;

	if (dir == DIR_LEFT) {
			if (x > MAP_X * 16) {
				obstackle = obstackles_detection(x, y, mapPart, map, 2, &start_jump, &start_fall, &jump_cnt);

										switch (obstackle) {
											case 0:{
												udario_u_blok = 0;
											}
											break;
											case 2: {
												udario_u_blok = 1;
											}
												break;
											case 3: {
												udario_u_blok = 1;
											}
												break;
											case 5: {
												score++;
												map1[roundY + 1][roundX + 1] = 0;
												//map_update(&mario);
											}
												break;
											default:
												udario_u_blok = 0;
											}
						if(udario_u_blok!=1)
				x--;
	}
	} else if (dir == DIR_RIGHT) {

		obstackle = obstackles_detection(x, y, mapPart, map, 1, &start_jump, &start_fall, &jump_cnt);

						switch (obstackle) {
							case 0:{
								udario_u_blok = 0;
							}
							break;
							case 2: {
								udario_u_blok = 1;
							}
								break;
							case 3: {
								udario_u_blok = 1;
							}
								break;
							case 5: {
								score++;
								map1[roundY + 1][roundX + 1] = 0;
								//map_update(&mario);
							}
								break;
							default:
								udario_u_blok = 0;
							}
		if(udario_u_blok!=1)
		x++;
	}

	if(jump_cnt == MAX_JUMP){
				start_jump=0;
				start_fall=1;

			}

	if(jump_cnt == 0){
			start_fall=0;
		}

	if (start_jump == 1 && jump_cnt < MAX_JUMP) {
			if (y > MAP_Y * 16) {
				y--;
				//mario->y = y;
				jump_cnt++;
				for (j = 0; j < 45000; j++) {
									}

			}
		}

	if (start_fall == 1) {
				/*if (y < MAP_Y * 16) {*/
					y++;
					//mario->y = y;
					jump_cnt--;
					for (j = 0; j < 45000; j++) {
										}
				/*}*/
	}

	Xx = x;
	Yy = y;

	/*if (dir == DIR_LEFT) {
		obstackle = obstackles_detection(x, y, mapPart, map, 2, &start_jump, &start_fall, &jump_cnt);
	} else if (dir == DIR_RIGHT) {
		obstackle = obstackles_detection(x, y, mapPart, map, 1, &start_jump, &start_fall, &jump_cnt);
	}*/

	roundX = floor(Xx / 16);
	roundY = floor(Yy / 16);



	mario->x = x;
	mario->y = y;

	Xil_Out32(
			XPAR_BATTLE_CITY_PERIPH_0_BASEADDR + 4 * ( REGS_BASE_ADDRESS + mario->reg_h ),
			(mario->y << 16) | mario->x);

	return b_false;
}

void battle_city() {

	unsigned int buttons; /*, tmpBtn = 0, tmpUp = 0;*/
	int i;/*, change = 0, jumpFlag = 0;*/
	/*int block;*/

	map_reset(map1);
	map_update(&mario);

	//chhar_spawn(&enemie1);
	//chhar_spawn(&enemie2);
	//chhar_spawn(&enemie3);
	//chhar_spawn(&enemie4);
	chhar_spawn(&mario);

	while (1) {

		buttons = XIo_In32( XPAR_IO_PERIPH_BASEADDR );

		direction_t d = DIR_STILL;
		if (BTN_LEFT(buttons)) {
			d = DIR_LEFT;
		} else if (BTN_RIGHT(buttons)) {
			d = DIR_RIGHT;
		}


		if (BTN_UP (buttons) && jump_cnt == 0) {
			start_jump = 1;
		}

		mario_move(map1, &mario, d, start_jump);

		map_update(&mario);

		for (i = 0; i < 100000; i++) {
		}

	}
}
