//
//  UpcomingViewModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/29/23.
//

import Foundation
import Combine

class UpcomingViewModel: ObservableObject{
    var sport_id: String
    
    var upcomingSearchURLString = "https://betsapi2.p.rapidapi.com/v1/bet365/upcoming?sport_id="
    let headers = [
        "content-type": "application/octet-stream",
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "betsapi2.p.rapidapi.com"
    ]
    
    @Published var upcoming: RapidInPlays?
    @Published var hasError: Bool = false
    @Published var error: LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(sport_id: String){
        self.sport_id = sport_id
    }
    
    func fetchUpcomings(){
        upcomingSearchURLString += sport_id
        
        guard let url = URL(string: upcomingSearchURLString) else{
            hasError = true
            error = .optionalError
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.inValidStatus
                      }
                let decoder = JSONDecoder()
                guard let upcoming = try? decoder.decode(RapidInPlays.self, from: result.data) else{
                    throw LoadError.FailedToDecode
                }
                return upcoming
            }
            .sink { [weak self] result in
                switch result{
                case .finished:
                    break
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                }
            } receiveValue: { [weak self] upcoming in
                self?.upcoming = upcoming
            }
            .store(in: &bag)
    }
}

extension UpcomingViewModel{
    enum LoadError: LocalizedError{
        case custom(error: Error)
        case FailedToDecode
        case inValidStatus
        case optionalError
        
        var errorDescription: String?{
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .FailedToDecode:
                return "Faild to decode response."
            case .inValidStatus:
                return "The request failed due to an invalid status range."
            case .optionalError:
                return "Failed to unwarp the optional value."
            }
        }
    }
}
