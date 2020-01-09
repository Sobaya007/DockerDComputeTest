import dcompute.driver.cuda;
import std.experimental.allocator : theAllocator;
import std;
import testkernel;

void main() {
    /*  各種初期化 */
    Platform.initialise();

    auto ctx = Context(Platform.getDevices(theAllocator)[0]);
    scope (exit) ctx.detach();

    Program.globalProgram = Program.fromFile("./.dub/obj/kernels_cuda210_64.ptx");

    /* データの準備 */
    auto bufA = Buffer!float(iota(100).map!(_ => uniform(0.0f, 1.0f)).array);
    auto bufB = Buffer!float(iota(100).map!(_ => uniform(0.0f, 1.0f)).array);
    auto bufC = Buffer!float(new float[100]);
    scope (exit) bufA.release();
    scope (exit) bufB.release();
    scope (exit) bufC.release();

    bufA.copy!(Copy.hostToDevice);
    bufB.copy!(Copy.hostToDevice);

    /* カーネル起動 */
    auto q = Queue(/* async = */false);
    q.enqueue!(testKernel)
        ([100, 1, 1], [1,1,1])
        (bufA, bufB, bufC);

    /* 計算結果の確認 */
    bufC.copy!(Copy.deviceToHost);

    foreach (a,b,c; zip(bufA.hostMemory, bufB.hostMemory, bufC.hostMemory)) {
        assert(a + b == c);
    }
    writeln("Success!");
}
