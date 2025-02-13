#include <sys/time.h>
#include <stdint.h>
#include <stdio.h>

extern void mars_rover_demo_task(void);
extern void Mars_Roverinit(void);
extern void Mars_Roverfinal(void);

uint64_t mars_rover_clock(void) {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return tv.tv_sec*(uint64_t)1000000+tv.tv_usec;
}

void mars_rover_delay_microseconds (uint16_t us) {
  const uint64_t deadline = mars_rover_clock() + us;

  while (mars_rover_clock() < deadline) {
    continue;
  }
}

void mars_rover_delay_milliseconds (uint16_t ms) {
  mars_rover_delay_microseconds (ms * 1000);
}

uint32_t mars_rover_sonar_distance (void) {
  return 0;
}

void mars_rover_set_mast_angle (int8_t a) {
  printf("set mast angle: %d\n", a);
}

void mars_rover_set_wheel_angle (uint8_t wheel, uint8_t side, int8_t a) {
  printf("set wheel angle %d %d %d\n", wheel, side, a);
}

void mars_rover_set_power (uint8_t side, int8_t power) {
  printf("set power %d %d\n", side, power);
}

void main(void) {
  Mars_Roverinit();
  mars_rover_demo_task();
  Mars_Roverfinal();
}
