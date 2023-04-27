//
//  InplayDataModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/26/23.
//

import Foundation

struct RapidInPlays: Codable{
    let results: [RapidInPlay]?
}

struct RapidInPlay: Codable{
    let id: String?
    let sport_id: String?
    let time: String?
    let league: RapidLeague?
    let home: RapidHome?
    let away: RapidAway?
    let ss: String?
    let r_id: String?
}

struct RapidLeague: Codable{
    let id: String?
    let name: String?
}

struct RapidHome: Codable{
    let name: String?
}

struct RapidAway: Codable{
    let name: String?
}
