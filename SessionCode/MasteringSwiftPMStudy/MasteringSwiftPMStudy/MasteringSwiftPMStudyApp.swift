//
//  MasteringSwiftPMStudyApp.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import SwiftUI
import AppFonts

@main
struct MasteringSwiftPMStudyApp: App {
    
    init() {
        _ = UIFont.register(.playWrite)
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabBarController().toSwiftUI()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
