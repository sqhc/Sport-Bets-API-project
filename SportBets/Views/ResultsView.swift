//
//  ResultsView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/27/23.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var vm: ResultsViewModel
    
    var body: some View {
        ZStack{
            if let results = vm.results?.results{
                List{
                    ForEach(results, id: \.time) { result in
                        ResultItem(result: result)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Result")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchResults)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(vm: ResultsViewModel(id: ""))
    }
}

struct ResultItem: View{
    var result: RapidMatchResult
    var body: some View{
        VStack{
            Text(result.league?.name ?? "Unknown")
                .frame(maxWidth: .infinity,  alignment: .center)
                .font(.title)
            Text(convertTime(time:result.time!))
            HStack{
                Text("Home")
                Spacer()
                Text("Away")
            }
            HStack{
                Text(result.home?.name ?? "Unknown")
                Spacer()
                Text(result.ss ?? "Unknown")
                Spacer()
                Text(result.away?.name ?? "Unknown")
            }
            HStack{
                Text("Referee:")
                Text(result.extra?.referee?.name ?? "Unknonw")
            }
            HStack{
                Text("Manager:")
                Text(result.extra?.home_manager?.name ?? "Unknown")
                Spacer()
                Text(result.extra?.away_manager?.name ?? "Unknown")
            }
            Text(result.extra?.stadium_data?.name ?? "Unknown")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack{
                Text(result.extra?.stadium_data?.country ?? "Unknown")
                Text(", \(result.extra?.stadium_data?.city ?? "Unknown")")
            }
            Text("Capacity: \(result.extra?.stadium_data?.capacity ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func convertTime(time: String)->String{
        let t = Int64(time)!
        let date = Date(timeIntervalSince1970: TimeInterval(t))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH: mm"
        return dateFormatter.string(from: date)
    }
}
