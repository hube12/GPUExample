#include <jrand.cl>


__kernel void start(ulong offset, ulong stride, __global ulong *seeds, __global ushort *ret) {
    size_t id = get_global_id(0);
    uchar max_count = 0;
    uchar max_last = 0;
    ulong seed_base = (offset + id) * stride;
    for (ulong i = 0; i < stride; i++) {
        ulong worldSeed = seed_base|i;
        int bound=3;
        Random random=get_random(worldSeed);
        int r = random_next(&random, 31);
        int m = bound - 1;
        int count=0;
        if ((bound & m) == 0) {
            r = (uint)((bound * (ulong)r) >> 31);
        } else {
            int u = r;
            while(u - (r = u % bound) + m < 0){
                u = random_next(&random, 31);
                count++;
            }
        }
     if (!count) continue;

        max_count++;
        seeds[id] = worldSeed;
    }
    ret[id] = (max_count << 8) | max_last;
}
