//
//  InplayView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/26/23.
//

import SwiftUI

struct InplayView: View {
    @ObservedObject var viewModel = InplayViewModel()
    
    var body: some View {
        ZStack{
            if let inPlays = viewModel.inPlays?.results{
                List{
                    ForEach(inPlays, id: \.id) { inPlay in
                        playItem(inPlay: inPlay)
                    }
                }
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: viewModel.fetchInplays)
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct InplayView_Previews: PreviewProvider {
    static var previews: some View {
        InplayView()
    }
}

struct playItem: View{
    var inPlay: RapidInPlay
    
    var body: some View{
        VStack{
            Text(inPlay.league?.name ?? "Unknown")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title)
            Text(convertTime(time: inPlay.time!))
            HStack{
                Text("Home")
                Spacer()
                Text("Away")
            }
            HStack{
                Text(inPlay.home?.name ?? "Unknown")
                Spacer()
                Text(inPlay.ss ?? "Unknown")
                Spacer()
                Text(inPlay.away?.name ?? "Unknown")
            }
            NavigationLink("Results?") {
                ResultsView(vm: ResultsViewModel(id: inPlay.id!))
            }
        }
    }
    
    func convertTime(time: String)->String{
        let t = Int(time)!
        let formatter = DateComponentsFormatter()
        return formatter.string(from: TimeInterval(t))!
    }
}
