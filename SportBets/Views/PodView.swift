//
//  PodView.swift
//  SportBets
//
//  Created by 沈清昊 on 4/28/23.
//

import SwiftUI

struct PodView: View {
    @ObservedObject var viewModel: PodViewModel
    @Environment(\.presentationMode) var presentMode
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color.cyan
                .edgesIgnoringSafeArea(.all)
            Button {
                presentMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
            }
            if let odds = viewModel.odds?.results{
                List{
                    ForEach(odds, id: \.event_id) { odd in
                        podItem(pod: odd)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Odds")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: viewModel.fetchOdds)
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct PodView_Previews: PreviewProvider {
    static var previews: some View {
        PodView(viewModel: PodViewModel(fi: ""))
    }
}

struct podItem: View{
    var pod: PreMatchResult
    var body: some View{
        VStack{
            Text(convertTime(time:(pod.main?.updated_at)!))
            Text(pod.main?.sp?.to_win_match?.name ?? "")
            if let ods = pod.main?.sp?.to_win_match?.odds{
                List{
                    ForEach(ods, id: \.id) { od in
                        HStack{
                            Text(od.name ?? "")
                            Spacer()
                            Text("Header: \(od.header ?? "")")
                            Spacer()
                            Text("Odd: \(od.odds ?? "")")
                        }
                    }
                }
            }
            
            Text(pod.main?.sp?.first_set_winner?.name ?? "")
            if let ods = pod.main?.sp?.first_set_winner?.odds{
                List{
                    ForEach(ods, id: \.id) { od in
                        HStack{
                            Text(od.name ?? "")
                            Spacer()
                            Text("Header: \(od.header ?? "")")
                            Spacer()
                            Text("Odd: \(od.odds ?? "")")
                        }
                    }
                }
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
