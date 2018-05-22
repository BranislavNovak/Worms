/*
 * obstacle_detect.c
 *
 *  Created on: 09.05.2018.
 *      Author: student
 */
#include "obstacle_detect.h"

#include "map.h"

//int obstackles_detection(int x, int y, int deoMape, unsigned char * map,int dir, int* start_jump, int* start_fall, int* jump_cnt)
int obstackles_detection(int x, int y, int deoMape, unsigned char * map, int dir, int previous_dir) {
	unsigned char crv_position_right;
	unsigned char crv_position_left;
	unsigned char crv_position_up;
	unsigned char crv_position_down;

	float Xx = x;
	float Yy = y;

	int roundX = 0;
	int roundY = 0;

	roundX = floor(Xx / 16);
	roundY = floor(Yy / 16);

	crv_position_right = map1[roundY][roundX + 1];
	crv_position_left = map1[roundY][roundX];
	crv_position_up = map1[roundY][roundX];
	crv_position_down = map1[roundY + 1][roundX];

	if (dir == 1) {
		//crv_position_down = map1[roundY + 1][roundX + 1];
		switch (crv_position_right) {
		case 0:
			return 0;
			break;
		case 1:
			return 1;
			break;
		case 2:
			return 2;
			break;
		case 3:
			return 3;
			break;
		case 4:
			return 4;
			break;
		case 5:
			return 5;
			break;
		case 6:
			return 6;
			break;

		}
	} else if (dir == 2) {
		//crv_position_down = map1[roundY + 1][roundX];
		switch (crv_position_left) {
		case 0:
			return 0;
			break;
		case 1:
			return 1;
			break;
		case 2:
			return 2;
			break;
		case 3:
			return 3;
			break;
		case 4:
			return 4;
			break;
		case 5:
			return 5;
			break;
		case 6:
			return 6;
			break;
		}
	} else if (dir == 3) {
		switch (crv_position_up) {
		case 0:
			return 0;
			break;
		case 1:
			return 1;
			break;
		case 2:
			return 2;
			break;
		case 3:
			return 3;
			break;
		case 4:
			return 4;
			break;
		case 5:
			return 5;
			break;
		case 6:
			return 6;
			break;

		}
	} else if (dir == 4) {
		switch (crv_position_down) {
		case 0:
			return 0;
			break;
		case 1:
			return 1;
			break;
		case 2:
			return 2;
			break;
		case 3:
			return 3;
			break;
		case 4:
			return 4;
			break;
		case 5:
			return 5;
			break;
		case 6:
			return 6;
			break;

		}
	}

}

