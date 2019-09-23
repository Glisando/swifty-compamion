//
//  data.swift
//  Swifty-Companion
//
//  Created by Hnat DANYLEVYCH on 11/1/18.
//  Copyright © 2018 Hnat DANYLEVYCH. All rights reserved.
//

import Foundation

struct User : Decodable {
    let email: String?
    let phone: String?
    let displayname: String?
    let image_url: String?
    let correction_point: Int?
    let wallet: Int?
    let cursus_users: [curses]
    let projects_users: [projects_users]
}

struct curses : Decodable {
    let level: Double?
    let skills: [skill]
}

struct skill : Decodable {
    let id: Int?
    let name: String?
    let level: Double?
}

struct projects_users : Decodable {
    let final_mark: Int?
    let validated: Bool?
    let project: project
    

    enum CodingKeys: String, CodingKey {
        case validated = "validated?"
        case final_mark
        case project
    }
}

struct project : Decodable {
    let slug: String?
}
