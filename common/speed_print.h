#ifndef PRINT_SPEED_H
#define PRINT_SPEED_H

#include <stddef.h>
#include <stdint.h>

void print_results(const char *s, uint64_t *t, size_t tlen);
uint64_t get_average(uint64_t *t, size_t tlen);
uint64_t get_median(uint64_t *t, size_t tlen);

#endif
