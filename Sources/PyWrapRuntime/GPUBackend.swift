
import Foundation

#if canImport(Metal)
import Metal
#endif

public enum GPUBackend {
    case metal(device: MTLDevice)
    case cuda(context: OpaquePointer)
    case vulkan(instance: OpaquePointer)
}

public protocol GPUBufferProvider {
    func gpuBuffer(backend: GPUBackend) -> UnsafeRawPointer?
}
