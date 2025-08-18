import CoreGraphics
import Darwin
import Foundation
import IOKit
import IOKit.graphics

typealias DisplayID = UInt32

// MARK: - DisplayServices API (Apple Silicon)
typealias DisplayServicesGetBrightnessFunc = @convention(c) (DisplayID, UnsafeMutablePointer<Float>)
    -> Int32

func getBrightnessViaDisplayServices() -> Float? {
    guard
        let handle = dlopen(
            "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices", RTLD_NOW)
    else {
        return nil
    }
    defer { dlclose(handle) }

    guard let sym = dlsym(handle, "DisplayServicesGetBrightness") else {
        return nil
    }

    let fn = unsafeBitCast(sym, to: DisplayServicesGetBrightnessFunc.self)

    let displayID = CGMainDisplayID()
    var brightness: Float = 0.0
    let err = fn(displayID, &brightness)

    if err == 0 {
        return brightness
    } else {
        return nil
    }
}

// MARK: - IOKit API (Intel)
func getBrightnessViaIOKit() -> Float? {
    var iterator: io_iterator_t = 0
    let result = IOServiceGetMatchingServices(
        kIOMainPortDefault,
        IOServiceMatching("IODisplayConnect"),
        &iterator)
    if result != KERN_SUCCESS {
        return nil
    }

    var service = IOIteratorNext(iterator)
    var brightness: Float = 0.0

    while service != 0 {
        let err = IODisplayGetFloatParameter(
            service, 0, kIODisplayBrightnessKey as CFString, &brightness)
        IOObjectRelease(service)
        if err == KERN_SUCCESS {
            IOObjectRelease(iterator)
            return brightness
        }
        service = IOIteratorNext(iterator)
    }

    IOObjectRelease(iterator)
    return nil
}

// MARK: - Universal
func getMainDisplayBrightnessPercent() -> Int? {
    if let b = getBrightnessViaDisplayServices() {
        return Int(round(b * 100))
    } else if let b = getBrightnessViaIOKit() {
        return Int(round(b * 100))
    } else {
        return nil
    }
}

if let brightness = getMainDisplayBrightnessPercent() {
    print(brightness)
} else {
    print(0)
}
