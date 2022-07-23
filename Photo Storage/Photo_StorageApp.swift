//
//  Photo_StorageApp.swift
//  Photo Storage
//
//  Created by 須崎良祐 on 2022/07/23.
//

import SwiftUI

@main
struct Photo_StorageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
