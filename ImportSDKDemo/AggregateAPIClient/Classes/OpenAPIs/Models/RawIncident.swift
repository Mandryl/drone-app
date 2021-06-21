//
// RawIncident.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Incidents API Model */
public struct RawIncident: Codable, Hashable {

    public var images: [String]
    public var region: String

    public init(images: [String], region: String) {
        self.images = images
        self.region = region
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case images
        case region
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(images, forKey: .images)
        try container.encode(region, forKey: .region)
    }
}
