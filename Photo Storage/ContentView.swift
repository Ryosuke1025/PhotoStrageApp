//
//  ContentView.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var sampleModel = SampleModel()
    @FetchRequest(

        //データの取得方法を指定　下記は日付降順
        entity:AppData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \AppData.date, ascending: false)],
        animation: .default)
    private var samples: FetchedResults<AppData>

    var body: some View {
        VStack{
          //新規作成ボタン
          Button(action:
                    {sampleModel.isNewData.toggle()
                    }){
                Text("新規作成")
          }
            //タップするとシートが開く
            .sheet(isPresented: $sampleModel.isNewData,
                content: {
                SheetView(sampleModel: sampleModel)
            })
          //データを表示する
          List{
            ForEach(samples){samples in
                SampleCardView(sampleModel: sampleModel, samples: samples)
            }
         }
        }
}
}
//プレビュー用コード
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
