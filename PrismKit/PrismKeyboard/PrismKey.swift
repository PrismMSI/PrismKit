//
//  PrismKeys.swift
//  PrismKit
//
//  Created by Erik Bautista on 7/15/20.
//  Copyright © 2020 ErrorErrorError. All rights reserved.
//

import Foundation

public final class PrismKey: NSObject {
    public let region: UInt8
    public let keycode: UInt8
    public var effect: PrismEffect? {
        didSet {
            if let start = effect?.transitions.first?.color {
                main = start
            }
        }
    }
    public var duration: UInt16 = 0x012c
    public var main = PrismRGB(red: 1.0, green: 0.0, blue: 0.0)
    public var active = PrismRGB()
    public var mode: PrismDevicePerKeyModes = .steady {
        willSet(value) {
            self.effect = nil
            self.duration = 0x012c
            self.main = PrismRGB()
            self.active = PrismRGB()
        }
    }

    public init(region: UInt8, keycode: UInt8) {
        self.region = region
        self.keycode = keycode
    }
}

extension PrismKey: Codable {
    private enum CodingKeys: CodingKey {
        case region, keycode, effect, duration, main, active, mode
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let region = try container.decode(UInt8.self, forKey: .region)
        let keycode = try container.decode(UInt8.self, forKey: .keycode)
        self.init(region: region, keycode: keycode)
        mode = try container.decode(PrismDevicePerKeyModes.self, forKey: .mode)
        effect = try container.decodeIfPresent(PrismEffect.self, forKey: .effect)
        duration = try container.decode(UInt16.self, forKey: .duration)
        main = try container.decode(PrismRGB.self, forKey: .main)
        active = try container.decode(PrismRGB.self, forKey: .active)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(region, forKey: .region)
        try container.encode(keycode, forKey: .keycode)
        try container.encode(effect, forKey: .effect)
        try container.encode(duration, forKey: .duration)
        try container.encode(main, forKey: .main)
        try container.encode(active, forKey: .active)
        try container.encode(mode, forKey: .mode)
    }
}
