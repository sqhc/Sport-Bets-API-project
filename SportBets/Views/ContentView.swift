//
//  ContentView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Playing events")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title)
                NavigationLink("Search races") {
                    InplayView()
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
