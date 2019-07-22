#include <jrand.cl>

static inline Random get_random_with_structure_seed (long world_seed, int x, int z, int salt) {
  return get_random(x * 341873128712L + z * 132897987541L + world_seed + salt);
}

static inline int temple_at(ulong world_seed, int salt, int x, int z) {
  int rSize = 32;
  int rSep = 8;
  int int_7 = x + rSize * 0;
  int int_8 = z + rSize * 0;
  int int_9 = int_7 < 0 ? int_7 - rSize + 1 : int_7;
  int int_10 = int_8 < 0 ? int_8 - rSize + 1 : int_8;
  int rx = int_9 / rSize;
  int rz = int_10 / rSize;
  Random r = get_random_with_structure_seed(world_seed, rx, rz, salt);
  if (random_next_int(&r, rSize - rSep) != x - rx * rSize) return 0;
  if (random_next_int(&r, rSize - rSep) != z - rz * rSize) return 0;
  return 1;
}

static inline int monument_at(ulong world_seed, int x, int z) {
  int rSize = 32;
  int rSep = 5;
  int int_7 = x + rSize * 0;
  int int_8 = z + rSize * 0;
  int int_9 = int_7 < 0 ? int_7 - rSize + 1 : int_7;
  int int_10 = int_8 < 0 ? int_8 - rSize + 1 : int_8;
  int rx = int_9 / rSize;
  int rz = int_10 / rSize;
  Random r = get_random_with_structure_seed(world_seed, rx, rz, 10387313);
  if ((random_next_int(&r, rSize - rSep) + random_next_int(&r, rSize - rSep)) / 2 != x - rx * rSize) return 0;
  if ((random_next_int(&r, rSize - rSep) + random_next_int(&r, rSize - rSep)) / 2 != z - rz * rSize) return 0;
  return 1;
}

static inline int buried_treasure_at(long world_seed, int x, int z) {
  Random r = get_random_with_structure_seed(world_seed, x, z, 10387320);
  return random_next(&r, 24) < 167773;
}

__kernel void main(ulong offset, ulong stride, __global __write_only ulong *seeds, __global __write_only ushort *ret) {
  size_t id = get_global_id(0);
  uchar max_count = 0;
  uchar max_last = 0;
  ulong seed_base = (offset + id) * stride;
  for (ulong i = 0; i < stride; i++) {
    uchar count = 0;
    uchar last = 0;
    ulong worldSeed = seed_base | i;
    //to modify
   /* if (!buried_treasure_at(worldSeed, 0, 0)) continue;
    if (!temple_at(worldSeed, 14357617, 0, 0)) continue;
    if (!monument_at(worldSeed, 0, 0)) continue;*/
    max_count++;
    seeds[id] = worldSeed;
  }
  ret[id] = (max_count << 8) | max_last;
}
