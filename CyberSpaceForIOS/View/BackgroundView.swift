//
//  BackgroundView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/30.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    enum BackgroundStyle {
        case Altas
        case Timber
    }
    var backgroundStyle: BackgroundStyle = .Altas
    
    var body: some View {
        VStack {
            if backgroundStyle == .Altas {
                AltasView()
            }else if backgroundStyle == .Timber {
                TimberView()
            }
        }
    }
}
struct AltasView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9960784314, green: 0.6745098039, blue: 0.368627451, alpha: 1)),Color(#colorLiteral(red: 0.7803921569, green: 0.4745098039, blue: 0.8156862745, alpha: 1)),Color(#colorLiteral(red: 0.2941176471, green: 0.7529411765, blue: 0.7843137255, alpha: 1))]),
                       startPoint: .top,
                       endPoint: .bottom)
    }
}
struct TimberView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color("TimberColor2"),Color("TimberColor1")]),
                       startPoint: .top,
                       endPoint: .bottom)
    }
}
