//
//  AppApp.swift
//  App
//
//  Created by Renan Germano on 30/08/25.
//

import ShowsList
import SwiftUI
import Service

@main
struct AppApp: App {
    var body: some Scene {
        WindowGroup {
            ListView.init(service: ShowsService())
        }
    }
}
