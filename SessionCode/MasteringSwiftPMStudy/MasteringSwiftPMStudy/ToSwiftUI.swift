//
//  ToSwiftUI.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import Foundation
import SwiftUI
import UIKit

struct UIViewControllerRepresentation<V: UIViewController>: UIViewControllerRepresentable {
    var viewController: () -> V
    func makeUIViewController(context: Context) -> some UIViewController {
        viewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension UIViewController {
    func toSwiftUI() -> UIViewControllerRepresentation<UIViewController> {
        UIViewControllerRepresentation {
            self
        }
    }
}
