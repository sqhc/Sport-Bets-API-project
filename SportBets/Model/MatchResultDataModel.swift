//
//  MatchResultDataModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/27/23.
//

import Foundation

struct RapidMatchResults: Codable{
    let results: [RapidMatchResult]?
}

struct RapidMatchResult: Codable{
    let time: String?
    let league: RapidLeague?
    let home: RapidHome?
    let away: RapidAway?
    let ss: String?
    let extra: MatchExtraInfo?
}

struct MatchExtraInfo: Codable{
    let away_manager: TeamManager?
    let home_manager: TeamManager?
    let referee: Referee?
    let stadium_data: Stadium?
}

struct TeamManager: Codable{
    let name: String?
}

struct Referee: Codable{
    let name: String?
}

struct Stadium: Codable{
    let name: String?
    let city: String?
    let country: String?
    let capacity: String?
}
