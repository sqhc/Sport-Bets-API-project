//
//  UpcomingView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/29/23.
//

import SwiftUI

struct UpcomingView: View {
    @ObservedObject var viewModel: UpcomingViewModel
    
    var body: some View {
        ZStack{
            if let upcoming = viewModel.upcoming?.results{
                List{
                    ForEach(upcoming, id: \.id) { up in
                        upcomingItem(upcoming: up)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Upcoming matches")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: viewModel.fetchUpcomings)
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView(viewModel: UpcomingViewModel(sport_id: ""))
    }
}

struct upcomingItem: View{
    var upcoming: RapidInPlay
    
    var body: some View{
        VStack{
            Text(upcoming.league?.name ?? "Unknown")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title)
            Text(convertTime(time: upcoming.time!))
            HStack{
                Text("Home")
                Spacer()
                Text("Away")
            }
            HStack{
                Text(upcoming.home?.name ?? "Unknown")
                Spacer()
                Text(upcoming.ss ?? "Unknown")
                Spacer()
                Text(upcoming.away?.name ?? "Unknown")
            }
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
