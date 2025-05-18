//
//  SearchResult.swift
//  acl2
//
//  Created by Saurish Tripathi on 5/17/25.
//

import Foundation

struct SearchResult: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let timestamp: String
    let keywords: [String]
    let location: Location?
    let media: Media?
    //let people: [Person]
    //let tags: [String]
    
    struct Location: Codable {
        let name: String
        let coordinates: Coordinates
        
        struct Coordinates: Codable {
            let lat: Double
            let lng: Double
        }
    }
    
    struct Media: Codable {
        let images: [String] // assuming images are represented as URLs or file names
    }
    
    //struct Person: Codable {
    //    let name: String
    //    let relation: String
    //}
}
