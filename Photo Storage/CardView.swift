//
//  CardView.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

/*見た目を整えるコード*/
import SwiftUI

struct SampleCardView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var sampleModel : SampleModel
    @ObservedObject var samples : AppData

    var body: some View {
            HStack{
              //CoreDataに保存された画像データがある場合は表示する
              if samples.image1?.count ?? 0 != 0 {
                Image(uiImage: UIImage(data: samples.wrappedImg1)!)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 75, height: 75, alignment: .center)
                               .clipped()
                               .padding(.leading)
              }
              if samples.image2?.count ?? 0 != 0 {
                Image(uiImage: UIImage(data: samples.wrappedImg2)!)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 75, height: 75, alignment: .center)
                               .clipped()
              }
                VStack {
                    Text(samples.wrappedDate, formatter: itemFormatter)
                        .font(.title)
                    Text(samples.wrappedText)
                        .font(.body)
                }
            }
        //カードの形
        .frame(
            minWidth:UIScreen.main.bounds.size.width * 0.9,
            maxWidth: UIScreen.main.bounds.size.width * 0.9,
            minHeight:UIScreen.main.bounds.size.height * 0.2,
            maxHeight: UIScreen.main.bounds.size.height * 0.8
        )
            
            .contextMenu{
                Button(action: {
                    sampleModel.editItem(item: samples)}){
                       Image(systemName: "pencil")
                        .foregroundColor(Color.blue)
                        Text("編集")
                }
                Button(action: {
                    context.delete(samples)
                    try! context.save()}){
                       Image(systemName: "trash")
                        .foregroundColor(Color.blue)
                       Text("削除")
                }
            }
    }
  //日付表示のフォーマット
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy/M/d\n(EEEEE)"
        return formatter
    }()
}
