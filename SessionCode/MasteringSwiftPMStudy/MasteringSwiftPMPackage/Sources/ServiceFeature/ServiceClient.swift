//
//  ServiceClient.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import Foundation


public struct Post: Codable, Hashable {
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

public struct User: Codable, Hashable {
    public var name: String
    var id: Int
    
    public init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

public struct Comment: Codable, Hashable {
    var postId: Int
    var id: Int
    public var name: String
    var email: String
    var body: String
    
    public init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}

public class ServiceClient {
    public static let shared = ServiceClient()
    
    let session = URLSession.shared
    let baseURL = URL(string: "http://jsonplaceholder.typicode.com")!
    let decoder = JSONDecoder()
    
    func initialiserStudy() {
        let post = Post(title: "Title1")
        print(post)
    }
    
    public func fetchPosts(offset: Int, limit: Int) async throws -> [Post] {
        let url = baseURL.appending(path: "photos")
            .appending(
                queryItems: [
                    URLQueryItem(name: "_start", value: "\(offset)"),
                    URLQueryItem(name: "_limit", value: "\(limit)")
                ]
            )
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        print(data, response)
        return try decoder.decode([Post].self, from: data)
    }
    
    public func fetchUsers(offset: Int, limit: Int) async throws -> [User] {
        let url = baseURL.appending(path: "users")
            .appending(
                queryItems: [
                    URLQueryItem(name: "_start", value: "\(offset)"),
                    URLQueryItem(name: "_limit", value: "\(limit)")
                ]
            )
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        print(data, response)
        return try decoder.decode([User].self, from: data)
    }
    
    public func fetchComments(offset: Int, limit: Int) async throws -> [Comment] {
        let url = baseURL.appending(path: "comments")
            .appending(
                queryItems: [
                    URLQueryItem(name: "_start", value: "\(offset)"),
                    URLQueryItem(name: "_limit", value: "\(limit)")
                ]
            )
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        print(data, response)
        return try decoder.decode([Comment].self, from: data)
    }
}
