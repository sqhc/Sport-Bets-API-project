//
//  PodViewModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/28/23.
//

import Foundation
import Combine

class PodViewModel: ObservableObject{
    var fi : String
    
    var oddsSearchURLString = "https://betsapi2.p.rapidapi.com/v3/bet365/prematch?FI="
    let headers = [
        "content-type": "application/octet-stream",
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "betsapi2.p.rapidapi.com"
    ]
    
    @Published var odds: PreMatchResults?
    @Published var hasError: Bool = false
    @Published var error: LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(fi: String){
        self.fi = fi
    }
    
    func fetchOdds(){
        oddsSearchURLString += fi
        
        guard let url = URL(string: oddsSearchURLString) else{
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
                guard let odds = try? decoder.decode(PreMatchResults.self, from: result.data) else{
                    throw LoadError.FailedToDecode
                }
                return odds
            }
            .sink { [weak self] result in
                switch result{
                case .finished:
                    break
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                }
            } receiveValue: { [weak self] odds in
                self?.odds = odds
            }
            .store(in: &bag)
    }
    
}

extension PodViewModel{
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
