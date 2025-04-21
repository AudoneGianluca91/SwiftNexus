
import PyWrapRuntime
import RWrapRuntime

@pywrap(module:"numpy", name:"array")
struct NDArray {}

@rwrap(package:"stats", name:"lm")
struct lm {}

let a = NDArray.new([1.0,2.0,3.0,4.0])
print("mean =", try a.mean())

print("PyWrap and RWrap demo complete.")
