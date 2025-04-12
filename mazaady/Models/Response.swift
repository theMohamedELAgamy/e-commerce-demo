//
//  TagsResponse.swift
//  mazaady
//
//  Created by Mohamed on 11/04/2025.
//


import Foundation

// Response structure for products - The actual API returns a direct array of products
typealias ProductsResponse = [Product]

// Response structure for tags
struct TagsResponse: Codable {
    let data: [Tag]
    
    
    enum CodingKeys: String, CodingKey {
        case data="tags"
    }
}

// Response structure for advertisements
struct AdvertisementsResponse: Codable {
    let advertisements: [Advertisement]
}

// API Response wrapper
//typealias UserResponse = User

