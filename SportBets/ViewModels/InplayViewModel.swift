//
//  InplayViewModel.swift
//  SportBets
//
//  Created by 沈清昊 on 4/26/23.
//

import Foundation
import Combine

class InplayViewModel: ObservableObject{
    
    @Published var inPlays: RapidInPlays?
    @Published var hasError: Bool = false
    @Published var error: LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    func fetchInplays(){
        let inPlayURLString = "https://betsapi2.p.rapidapi.com/v1/bet365/inplay_filter"
        let headers = [
            "content-type": "application/octet-stream",
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "betsapi2.p.rapidapi.com"
        ]
        
        guard let url = URL(string: inPlayURLString) else{
            hasError = true
            error = .optionalError
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({result in
                print(result.response)
                guard let resoponse = result.response as? HTTPURLResponse,
                      resoponse.statusCode >= 200 && resoponse.statusCode <= 300 else{
                          throw LoadError.inValidStatus
                      }
                let decoder = JSONDecoder()
                guard let inplays = try? decoder.decode(RapidInPlays.self, from: result.data) else{
                    throw LoadError.FailedToDecode
                }
                return inplays
            })
            .sink { [weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] inplays in
                self?.inPlays = inplays
            }
            .store(in: &bag)
    }
}

extension InplayViewModel{
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
