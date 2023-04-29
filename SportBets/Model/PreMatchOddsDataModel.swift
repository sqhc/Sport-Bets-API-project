//
//  PreMatchOddsDataModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/28/23.
//

import Foundation

struct PreMatchResults: Codable{
    let results: [PreMatchResult]?
}

struct PreMatchResult: Codable{
    let event_id: String?
    let main: MainPreMatchResult?
}

struct MainPreMatchResult: Codable{
    let updated_at: String?
    let sp: SPOdd?
}

struct SPOdd: Codable{
    let to_win_match: OddDescription?
    let first_set_winner: OddDescription?
    let first_set_score: OddDescription?
    let first_jeremy_jahn_service_game_winners: OddDescription?
    let first_jeremy_jahn_service_game_score: OddDescription?
    let first_jeremy_jahn_service_game_to_win_to: OddDescription?
    let first_deney_wassermann_service_game_winners: OddDescription?
    let first_deney_wassermann_service_game_score: OddDescription?
    let first_deney_wassermann_service_game_to_win_to: OddDescription?
}

struct OddDescription: Codable{
    let name: String?
    let odds: [Odd]?
}

struct Odd: Codable{
    let id: String?
    let odds: String?
    let header: String?
    let name: String?
}
