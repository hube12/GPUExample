#ifndef __JRAND_CL
#define __JRAND_CL

#undef JRAND_DOUBLE

#define RANDOM_MULTIPLIER_LONG 0x5DEECE66DUL

#ifdef JRAND_DOUBLE
#define Random double
#define RANDOM_MULTIPLIER 0x5DEECE66Dp-48
#define RANDOM_ADDEND 0xBp-48
#define RANDOM_SCALE 0x1p-48

inline uint random_next (Random *random, int bits) {
  *random = trunc((*random * RANDOM_MULTIPLIER + RANDOM_ADDEND) * RANDOM_SCALE);
  return (uint)((ulong)(*random / RANDOM_SCALE) >> (48 - bits));
}

#else

#define Random ulong
#define RANDOM_MULTIPLIER RANDOM_MULTIPLIER_LONG
#define RANDOM_ADDEND 0xBUL
#define RANDOM_MASK (1UL << 48) - 1
#define RANDOM_SCALE 1

// Random::next(bits)
inline uint random_next (Random *random, int bits) {
  *random = (*random * RANDOM_MULTIPLIER + RANDOM_ADDEND) & RANDOM_MASK;
  return (uint)(*random >> (48 - bits));
}
#endif // ~JRAND_DOUBLE

// new Random(seed)
#define get_random(seed) ((Random)((seed ^ RANDOM_MULTIPLIER_LONG) & RANDOM_MASK))
#define get_random_unseeded(state) ((Random) ((state) * RANDOM_SCALE))

// Random::nextInt(bound)
inline uint random_next_int (Random *random, uint bound) {
  int r = random_next(random, 31);
  int m = bound - 1;
  if ((bound & m) == 0) {
      r = (uint)((bound * (ulong)r) >> 31);
  } else {
      for (int u = r;
           u - (r = u % bound) + m < 0;
           u = random_next(random, 31));
  }
  return r;
}

inline long random_next_long (Random *random) {
  return (((long)random_next(random, 32)) << 32) + random_next(random, 32);
}

#endif
