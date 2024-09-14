//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 14/09/24.
//

import Foundation
import SwiftUI
import Resources
import AppFonts
import ServiceFeature

public struct CommentsView: View {
    
    let limit: Int = 15
    @State var offset: Int = 0
    @State var comments: [Comment] = []
    
    public init() {}
    
    public var body: some View {
        List {
            ForEach(comments, id: \.self) { comment in
                Text(comment.name)
                    .font(.playwrite(weight: .regular, size: 17))
            }
            ProgressView()
                .id(UUID())
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    fetchComments()
                }
        }
        .onAppear {
            fetchComments()
        }
        .navigationTitle("Comments")
    }
    
    @MainActor
    var imageAssetBody: some View {
        List {
            Text("Welcome")
                .font(.playwrite(weight: .regular, size: 40))
            Image(asset: .adamSavage)
            Image(asset: .mikeAsh)
            Image(asset: .oleBegemann)
        }
    }
    
    private func fetchComments() {
        Task {
            do {
                let offset = self.offset
                let latestComments = try await ServiceClient.shared.fetchComments(offset: offset, limit: limit)
                if offset == 0 {
                    self.comments = latestComments
                } else {
                    self.comments.append(contentsOf: latestComments)
                }
                self.offset = comments.count
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    _ = UIFont.register(.playWrite)
    return CommentsView()
}
