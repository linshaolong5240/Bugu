//
//  VisualEffectView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/4/14.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    let effect: UIBlurEffect

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    }
}
