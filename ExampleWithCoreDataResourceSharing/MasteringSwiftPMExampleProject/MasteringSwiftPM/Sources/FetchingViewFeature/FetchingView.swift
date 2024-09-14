// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Alamofire
import Fonts

public struct FetchingView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .font(.playwrite(weight: .light, size: 20))
        }
    }
}

#Preview {
    _ = UIFont.register(.playWrite)
    return FetchingView()
}
