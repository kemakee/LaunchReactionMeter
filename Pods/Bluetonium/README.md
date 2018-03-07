![Bluetonium: Bluetooth library in Swift](https://raw.githubusercontent.com/e-sites/Bluetonium/assets/Bluetonium.png)

Bluetonium is a Swift Library that makes it easy to communicate with Bluetooth devices.

[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/fo-real.svg)](http://forthebadge.com)

[![Build Status](https://travis-ci.org/e-sites/Bluetonium.svg)](https://travis-ci.org/e-sites/Bluetonium)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Bluetonium.svg)](https://img.shields.io/cocoapods/v/Bluetonium.svg)
[![codecov](https://codecov.io/gh/e-sites/Bluetonium/branch/master/graph/badge.svg)](https://codecov.io/gh/e-sites/Bluetonium)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/Bluetonium.svg?style=flat)](http://cocoadocs.org/docsets/Bluetonium)
[![Quality](https://apps.e-sites.nl/cocoapodsquality/Bluetonium/badge.svg?003)](https://cocoapods.org/pods/Bluetonium/quality)

## Features

- [x] 🎲 Services and characteristics mapping
- [x] 👓 Default data transformers
- [x] 🔧 Reading & writing to peripherals
- [x] 🌔 Background mode
- [x] 📻 Scanning and connecting to peripherals
- [x] 🦅 Swift 3 & 4

## Requirements

- iOS 8.0+
- Xcode 7.2+

## Installation
### [CocoaPods](http://cocoapods.org/)
Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```rb
pod 'Bluetonium'
```

Make sure that you are integrating your dependencies using frameworks: add `use_frameworks!` to your Podfile. Then run `pod install`.

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "e-sites/Bluetonium"
```

Run `carthage update` and follow the steps as described in Carthage's [README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).


## Usage

### Get devices

The `Manager` will handle searching for devices and connecting to them.
```swift
import Bluetonium

let manager = Manager()
manager.delegate = self
manager.startScanForDevices()
```

If a device is found you will get notified by the `func manager(_ manager: Manager, didFindDevice device: Device)` delegate call. You can also get all found devices in the `foundDevices` array of your manager.

### Connect to a device

Connecting to a device is simple.

```swift
manager.connect(with: device)
```

The `device` is a device form the `foundDevices` array.

### Create and register a ServiceModel

A `ServiceModel` subclass will represents a Service, all the properties represent the Characteristics.

This example represents the [Battery Service](https://developer.bluetooth.org/gatt/services/Pages/ServiceViewer.aspx?u=org.bluetooth.service.battery_service.xml)

```swift
class BatteryServiceModel: ServiceModel {
	enum Characteristic : String {
		case batteryLevel = "2A19"
	}

	var batteryLevel: UInt8 = 0
	
	override var serviceUUID:String {
		return "180F"
	}
	
	override func mapping(_ map: Map) {
		batteryLevel <- map[Characteristic.batteryLevel.rawValue]
	}
	
}
```

Register a `ServiceModel` subclass. Make sure you do this before the device is actualy connected.

```swift
let batteryServiceModel = BatteryServiceModel()

func manager(_ manager: Manager, willConnectToDevice device: Device) {
	device.register(serviceModel: batteryServiceModel)
}
```

---

### ServiceModel subclass

A `ServiceModel` subclass will represents a Service, all the properties represent the Characteristics.
Interacting with the peripheral is only possible once the characteristic did became available through the `func characteristicBecameAvailable(withUUID UUID: String)` function.  
Or when the `serviceReady` boolean is set to `true`.

It's recommended to create a struct containing static properties of the UUID's along with your `ServiceModel` this way your app doesn't have to hardcode the UUID in different places and prevents errors. (See example: HeartRateServiceModel in project)

#### Reading
```swift
batteryServiceModel.readValue(withUUID: "2A19")

// Or with completion
batteryServiceModel.readValue(withUUID: "2A19") { value in
	print(value)
}
```

#### Writing
```swift
batteryServiceModel.batteryLevel = 10
batteryServiceModel.writeValue(withUUID: "2A19")
```

#### Custom DataTransformers

It is possible that your characteristic has a custom data format or has a data format not yet supported. Then you can create your own custom DataTransformer for that property.

The custom DataTransformer needs to conform to the `DataTransformer` protocol which has two functions.

```swift
class HeartRateDataTransformer: DataTransformer {
    
    func transform(dataToValue data: Data?) -> MapValue {
    	// Used when reading from the characteristic.
    	// Transform Data to your property MapValue.
    }
    
    func transform(valueToData value: MapValue?) -> Data {
    	// Used when writing to the characteristic.
    	// Transform your property MapValue to Data.
    }
    
}
```

To register your custom DataTransform you can add it to the mapping function:

```swift
func mapping(_ map: Map) {
	heartRate <- (map["2A37"], HeartRateDataTransformer())
}
```

#### Set notifications for a characteristic

The `ServiceModel` has a function that will let you register for value changes on the peripheral. When you return `true` for one of you characteristics it will automatically update the property.

```swift
func registerNotifyForCharacteristic(withUUID UUID: String) -> Bool
```

## Contributions

Feedback is appreciated and pull requests are always welcome. Let's make [this list](https://github.com/e-sites/Bluetonium/graphs/contributors) longer!

## License

Bluetonium is released under the MIT license. See LICENSE for details.

