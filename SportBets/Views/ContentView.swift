//
//  ContentView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    @State var sport_id = 1
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Playing events")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title)
                NavigationLink("Search races") {
                    InplayView()
                }
                Divider()
                Text("Upcoming events")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title)
                Stepper(value: $sport_id, in: 1...20) {
                    Text("Sport ID")
                }
                Text("The id you choose: \(sport_id)")
                NavigationLink("Upcoming matches") {
                    UpcomingView(viewModel: UpcomingViewModel(sport_id: "\(sport_id)"))
                }
            }
            .navigationTitle("Sport Bets")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
