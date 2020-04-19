//
//  Grid.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/25.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI
struct GridIndex : Identifiable { var id: Int }
struct GridView<Data, Content>: View
where Data : RandomAccessCollection, Content : View, Data.Element : Identifiable{
    private let columns: Int
    private var rows: Int {
      data.count / self.columns
    }
    private var HSpacing: CGFloat

    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    
    public init(data: Data,
                columns: Int,
                hSpacing: CGFloat = 0,
                content: @escaping (Data.Element) -> Content) {
        self.data = data.map{$0}
        self.content = content
        self.columns = max(1, columns)
        self.HSpacing = hSpacing
    }
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach((0..<self.rows).map {GridIndex(id: $0)}){row in
                        HStack(spacing: self.HSpacing) {
                            ForEach((0..<self.columns).map {GridIndex(id: $0)}) {
                                column in
                                self.content(self.data[row.id * self.columns + column.id])
                                    .frame(width: self.contentWidth(geometry))
                            }
                        }
                    }
                    if self.data.count % self.columns > 0 {
                        HStack(spacing: self.HSpacing) {
                            ForEach((0..<(self.data.count % self.columns)).map {GridIndex(id: $0)}) {
                                column in
                                self.content(self.data[self.rows * self.columns + column.id])
                                .frame(width: self.contentWidth(geometry))
                            }
                            ForEach((0..<(self.columns - self.data.count % self.columns)).map {GridIndex(id: $0)}) {
                                column in
                                self.content(self.data[0])
                                    .frame(width: self.contentWidth(geometry))
                                    .hidden()
                            }
                        }
                    }
                    HStack {
                        Spacer()
                    }
                    .frame(height: 200)
                }
            }
        }
    }
    
    func contentWidth(_ geometryProxy: GeometryProxy) -> CGFloat{
        let frameWidth = (geometryProxy.size.width - CGFloat(columns - 1) * HSpacing) / CGFloat(columns)
        return frameWidth
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        .environmentObject(UserData())
//        .environmentObject(Player())
    }
}
