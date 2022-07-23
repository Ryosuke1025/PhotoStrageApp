//
//  Model.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

import Foundation
import SwiftUI
import CoreData

class SampleModel : ObservableObject{
    @Published var date = Date()
    @Published var id = UUID()
    @Published var bool = false
    @Published var image1: Data = Data.init()
    @Published var image2: Data = Data.init()
    @Published var text = ""
    @Published var isNewData = false
    @Published var updateItem : AppData!
    
    func writeData(context :NSManagedObjectContext){
        //データが新規か編集かで処理を分ける
        if updateItem != nil {
            
            updateItem.date = date
            updateItem.bool = bool
            updateItem.image1 = image1
            updateItem.image2 = image2
            updateItem.text = text
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            
            date = Date()
            bool = false
            image1 = Data.init()
            image2 = Data.init()
            text = ""
 
            return
        }
        //データ新規作成
        let newAppData = AppData(context: context)
        newAppData.date = date
        newAppData.id = UUID()
        newAppData.bool = bool
        newAppData.image1 = image1
        newAppData.image2 = image2
        newAppData.text = text
        
        do{
            try context.save()
            isNewData.toggle()
            date = Date()
            bool = false
            image1 = Data.init()
            image2 = Data.init()
            text = ""
        }catch {
            print(error.localizedDescription)
        }
    }
    //編集の時は既存データを利用する
    func editItem(item: AppData){
        updateItem = item
        
        date = item.wrappedDate
        id = item.wrappedId
        bool = item.bool
        image1 = item.wrappedImg1
        image2 = item.wrappedImg2
        text = item.wrappedText

        isNewData.toggle()
    }
}

