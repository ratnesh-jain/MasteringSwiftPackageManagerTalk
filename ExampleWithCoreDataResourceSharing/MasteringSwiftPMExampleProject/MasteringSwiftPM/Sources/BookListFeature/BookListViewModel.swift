//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 06/09/24.
//

import Foundation
import PersistentModels
import CoreData
import Combine

@MainActor @Observable public class BookListViewModel {
    var bookLists: [Book] = []
    private var cancellables: Set<AnyCancellable> = []
    
    public init(bookLists: [Book] = []) {
        self.bookLists = bookLists
        performFetchRequest()
        observeChanges()
    }
    
    func observeChanges() {
        NotificationCenter.default
            .publisher(for: NSManagedObjectContext.didChangeObjectsNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if (notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>)?.contains(where: {$0.entity.name == "Book"}) ?? false {
                    self?.performFetchRequest()
                }
            }
            .store(in: &cancellables)
    }
    
    private func performFetchRequest() {
        let request = Book.fetchRequest()
        let context = PersistentModelStore.container.viewContext
        do {
            let items = try context.fetch(request)
            self.bookLists = items
        } catch {
            print(error)
        }
    }
    
    func createNew() throws {
        let context = PersistentModelStore.container.viewContext
        
        let author = Author(context: context)
        author.id = UUID()
        author.name = "The Author"
        
        let book = Book(context: context)
        book.id = UUID()
        book.title = "The Book"
        book.desc = "Authorization Book"
        book.edition = 1
        book.publishedAt = Date()
        book.authors = author
        
        try context.save()
    }
}
