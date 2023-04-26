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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct InplayView_Previews: PreviewProvider {
    static var previews: some View {
        InplayView()
    }
}
