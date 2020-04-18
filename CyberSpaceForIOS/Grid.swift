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
    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    
    public init(data: Data,
                columns: Int,
                content: @escaping (Data.Element) -> Content) {
        self.data = data.map{$0}
        self.content = content
        self.columns = max(1, columns)
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach((0..<rows).map {GridIndex(id: $0)}){row in
                    HStack {
                        ForEach((0..<self.columns).map {GridIndex(id: $0)}) {
                            column in
                            self.content(self.data[row.id * self.columns + column.id])
                        }
                    }
                }
                if self.data.count % self.columns > 0 {
                    HStack {
                        ForEach((0..<(self.data.count % self.columns)).map {GridIndex(id: $0)}) {
                            column in
                            self.content(self.data[self.rows * self.columns + column.id])
                        }
                        ForEach((0..<(self.columns - self.data.count % self.columns)).map {GridIndex(id: $0)}) {
                            column in
                            self.content(self.data[0]).hidden()
                        }
                    }
                }
            }
        }
    }
}
