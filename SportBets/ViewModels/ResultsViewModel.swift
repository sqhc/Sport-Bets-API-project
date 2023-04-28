//
//  ResultsViewModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/27/23.
//

import Foundation
import Combine

class ResultsViewModel: ObservableObject{
    var id: String
    var resultsSearchURLString = "https://betsapi2.p.rapidapi.com/v1/bet365/result?event_id="
    let headers = [
        "content-type": "application/octet-stream",
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "betsapi2.p.rapidapi.com"
    ]
    
    @Published var results: RapidMatchResults?
    @Published var hasError: Bool = false
    @Published var error: LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(id: String){
        self.id = id
    }
    
    func fetchResults(){
        resultsSearchURLString += id
        guard let url = URL(string: resultsSearchURLString) else{
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
                guard let results = try? decoder.decode(RapidMatchResults.self, from: result.data) else{
                    throw LoadError.FailedToDecode
                }
                return results
            }
            .sink { [weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] results in
                self?.results = results
            }
            .store(in: &bag)

    }
}

extension ResultsViewModel{
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
