@compute(CompileFor.deviceOnly)
module testkernel;

import ldc.dcompute;
import dcompute.std.index;

@kernel
void testKernel(GlobalPointer!float a, GlobalPointer!float b, GlobalPointer!float c) {
    const idx = GlobalIndex.x;
    c[idx] = a[idx] + b[idx];
}
