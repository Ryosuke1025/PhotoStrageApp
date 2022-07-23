//
//  PhotoPicker.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

/*PHPickerをSwiftUIで使えるようにするためのコード*/
import PhotosUI
import SwiftUI

public typealias PhotoPickerviewCompletionHandler = (([PHPickerResult]) -> Void)

struct ImagePicker: UIViewControllerRepresentable {
    
    let configuration: PHPickerConfiguration
    let completion: PhotoPickerviewCompletionHandler
    //カメラロールの開閉用のBool値isPickingと複数写真保存用の配列imagesをBinding
    @Binding var isPicking: Bool
    @Binding var images: [Data]
    
    var itemProviders: [NSItemProvider] = []
   
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController,context : Context){}
    
    func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
    
    class Coordinator: NSObject,PHPickerViewControllerDelegate,UINavigationControllerDelegate {
        private var parent: ImagePicker
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]){
            
 
            if !results.isEmpty {
                parent.itemProviders = []
                parent.images = []
            }
            parent.itemProviders = results.map(\.itemProvider)
            displayNextImage()
            
            parent.isPicking.toggle()
            self.parent.completion(results)
            
            }

        private func displayNextImage(){
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self){
                    itemProvider.loadObject(ofClass: UIImage.self){(newImage,error) in if let error = error{
                        print("画像取得失敗",error)
                        return
                    }
                    DispatchQueue.main.async {
                    guard let image = newImage as? UIImage else {return}
                    
                    //選択した画像をData型のjpegデータに変換してimagesの配列に保存
                    let data = image.jpegData(compressionQuality: 0.7)
                    self.parent.images.append(data!)
                    print("画像\(self.parent.images.count)枚取得")
                    return
                    }
                    }
                }
        }
    }
}
}
