//
//  AppData+CoreDataProperties.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//
//

import Foundation
import CoreData


extension AppData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppData> {
        return NSFetchRequest<AppData>(entityName: "AppData")
    }

    @NSManaged public var bool: Bool
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image1: Data?
    @NSManaged public var image2: Data?
    @NSManaged public var text: String?

}
//coreDataのデータ型はオプショナルになるので、nilの場合の処理を追加
extension AppData{
    public var wrappedDate: Date {date ?? Date()}
    public var wrappedId: UUID {id ?? UUID()}
    public var wrappedImg1: Data {image1 ?? Data.init(capacity: 0)}
    public var wrappedImg2: Data {image2 ?? Data.init(capacity: 0)}
    public var wrappedText: String {text ?? ""}
}

extension AppData : Identifiable {

}
