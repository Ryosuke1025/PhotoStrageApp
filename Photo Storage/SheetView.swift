//
//  SheetView.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

/*入力画面からカメラロールを開けるようにする*/
import SwiftUI
import PhotosUI

struct SheetView: View {
    @ObservedObject var sampleModel : SampleModel
    @Environment(\.managedObjectContext)private var context
    //カメラロールを開閉スイッチにするBool値
    @State private var isPicking: Bool = false
    //選択した写真を入れる配列
    @State private var images: [Data] = []
    //PHPickerの設定
    var pickerConfig: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images//静止画写真のみ選択
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 2//選択する枚数の上限
        
        //config.selection = .ordered
        return config
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Button("Cansel", action:{
                    sampleModel.isNewData = false
                }).foregroundColor(.blue)
                Spacer()
                Button("Save", action:
                        {
                            sampleModel.writeData(context: context)
                            
                        }
                ).foregroundColor(.blue)
                
            }
            .padding(.bottom, 20.0)
            
            HStack {
                DatePicker("", selection: $sampleModel.date, displayedComponents: .date)
                    .labelsHidden()
                    .padding()
                //isPickingをtoggleしてモダールでカメラロールを開く
                Button(action: {self.isPicking.toggle()}){
                    Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40.0, height: 40.0)
                    .foregroundColor(.blue)
                }
                .padding()
                .fullScreenCover(isPresented: $isPicking){ImagePicker(
                          configuration: pickerConfig,
                          completion: {result in },
                          isPicking: $isPicking,
                          images: $images)
                }
            }
            
            TextField("タイトル", text: $sampleModel.text).textFieldStyle(RoundedBorderTextFieldStyle())
            /*カメラロールから選択されたimages配列の中の写真を表示する
            images配列の写真データの枚数によって表示を切り替えます*/
                switch images.count {
                //1枚の場合
                    case 1:
                        HStack {
                            Image(uiImage: UIImage(data: images[0]) ?? UIImage(systemName: "photo")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height:150, alignment: .center)
                                .border(Color.gray)
                                .clipped()
                            
                            Spacer()
                        }
                        //選択した画像が表示された時点でCoreDataモデルに代入する
                        .onAppear(){
                            sampleModel.image1 = images[0]
                            sampleModel.image2 = Data.init()
                        }
                    //2枚の場合
                    case 2:
                        HStack{
                            Image(uiImage: UIImage(data: images[0]) ?? UIImage(systemName: "photo")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150, alignment: .center)
                                .border(Color.gray)
                                .clipped()
                            Image(uiImage: UIImage(data: images[1]) ?? UIImage(systemName: "photo")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150, alignment: .center)
                                .border(Color.gray)
                                .clipped()
                            Spacer()
                        }.onAppear(){
                            sampleModel.image1 = images[0]
                            sampleModel.image2 = images[1]
                        }
                //0枚の場合か,編集で開いたシートの場合
                    default:
                        HStack{
                            Image(uiImage: UIImage(data: sampleModel.image1) ?? UIImage(systemName: "person.crop.square")!)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 150, height: 150, alignment: .center)
                               .clipped()
                               .opacity(0.5)
                            Image(uiImage: UIImage(data: sampleModel.image2) ?? UIImage(systemName: "person.crop.square")!)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 150, height: 150, alignment: .center)
                               .clipped()
                               .opacity(0.5)
                            Spacer()
                        }
                }
        Spacer()
        }.padding()
    }
}
//プレビュー用コード
struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(sampleModel: SampleModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
