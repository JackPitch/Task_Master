//
//  CompletedView.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    var body: some View {
        VStack {
            LottieView(fileName: "done")
                .frame(width: 200, height: 200)
            
            Text("Task Added!")
                .font(.system(.body, design: .rounded))
                .foregroundColor(Color.black.opacity(0.6))
        }.padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 22)
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView()
    }
}
