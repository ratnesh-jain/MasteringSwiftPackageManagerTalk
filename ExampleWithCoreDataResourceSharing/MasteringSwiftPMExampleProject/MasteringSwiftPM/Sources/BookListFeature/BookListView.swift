//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 06/09/24.
//

import Foundation
import PersistentModels
import SwiftUI

@MainActor
public struct BookListView: View {
    let viewModel: BookListViewModel
    
    public init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.bookLists) { book in
                Section {
                    Text(book.title ?? "No title")
                    Text(book.desc ?? "No Desc")
                    Text(book.authors?.name ?? "No Author")
                    Text(book.publishedAt?.formatted() ?? "")
                }
            }
            .listSectionSpacing(.compact)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    do {
                        try viewModel.createNew()
                    } catch {
                        print(error)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookListView(viewModel: .init())
    }
}
