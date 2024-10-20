//
//  Appwrite.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

import Appwrite
import AppwriteEnums
import JSONCodable
import SwiftUI

#if !DEBUG
let projectId = "ssyncer"
#else
let projectId = "ssyncer"

#endif

let databaseId = "ssyncer"
let hostsCollectionId = "hosts"
let keysCollectionId = "keys"
let tunnelsCollectionId = "tunnels"

let queryLimit = 50

class Appwrite: ObservableObject {
    private var client: Client
    
    var account: Account
    var databases: Databases
    var functions: Functions
    var storage: Storage
    
    @Published var user: User<[String: AnyCodable]>? = nil
    @Published var session: Session? = nil
    
    init() {
        client = Client()
            .setProject(projectId)
        
        account = Account(client)
        databases = Databases(client)
        functions = Functions(client)
        storage = Storage(client)
    }
    
    //MARK: - Authentication
    
    public func createEmailAccount(_ email: String, _ password: String) async throws {
        user = try await account.create(
            userId: ID.unique(),
            email: email,
            password: password
        )
    }
    
    public func createEmailSession(_ email: String, _ password: String) async throws -> Session? {
        session = try await account.createEmailPasswordSession(email: email, password: password)
            
        return session
    }
    
    public func createOAuth2Session(_ provider: OAuthProvider) async throws {
        if (try await account.createOAuth2Session(provider: provider)) {
            
        }
    }
    
    public func createAnonymousSession() async throws {
        session = try await account.createAnonymousSession()
    }
    
    public func getAccount() async throws -> User<[String: AnyCodable]>? {
        user = try await account.get()
        
        return user
    }
    
    public func getSession() async throws -> Session? {
        session = try await account.getSession(sessionId: "current")
        
        return session
    }
    
    //MARK: - Hosts
    
    public func createHost(_ host: Host) async throws -> Document<Host> {
        return try await databases.createDocument(
            databaseId: databaseId,
            collectionId: hostsCollectionId,
            documentId: ID.unique(),
            data: host,
            nestedType: Host.self
        )
    }
    
    public func listHosts(lastId: String? = nil) async throws -> DocumentList<Host> {
        var queries = [Query.limit(queryLimit)]
        
        if let lastId {
            queries.append(Query.cursorAfter(lastId))
        }
        
        return try await databases.listDocuments(
            databaseId: databaseId,
            collectionId: hostsCollectionId,
            queries: queries,
            nestedType: Host.self
        )
    }
    
    public func getHost(id: String) async throws -> Document<Host> {
        return try await databases.getDocument(
            databaseId: databaseId,
            collectionId: hostsCollectionId,
            documentId: id,
            nestedType: Host.self
        )
    }
    
    public func updateHost(_ host: Document<Host>) async throws -> Document<Host> {
        return try await databases.updateDocument(
            databaseId: databaseId,
            collectionId: hostsCollectionId,
            documentId: host.id,
            data: host,
            nestedType: Host.self
        )
    }
    
    public func deleteHost(id: String) async throws {
        _ = try await databases.deleteDocument(
            databaseId: databaseId,
            collectionId: hostsCollectionId,
            documentId: id
        )
    }
    
    //MARK: - Keys
    
    public func createKey(_ key: Key) async throws -> Document<Key> {
        return try await databases.createDocument(
            databaseId: databaseId,
            collectionId: keysCollectionId,
            documentId: ID.unique(),
            data: key,
            nestedType: Key.self
        )
    }
    
    public func listKeys(lastId: String? = nil) async throws -> DocumentList<Key> {
        var queries = [Query.limit(queryLimit)]
        
        if let lastId {
            queries.append(Query.cursorAfter(lastId))
        }
        
        return try await databases.listDocuments(
            databaseId: databaseId,
            collectionId: keysCollectionId,
            queries: queries,
            nestedType: Key.self
        )
    }
    
    public func getKey(id: String) async throws -> Document<Key> {
        return try await databases.getDocument(
            databaseId: databaseId,
            collectionId: keysCollectionId,
            documentId: id,
            nestedType: Key.self
        )
    }
    
    public func updateKey(_ key: Document<Key>) async throws -> Document<Key> {
        return try await databases.updateDocument(
            databaseId: databaseId,
            collectionId: keysCollectionId,
            documentId: key.id,
            data: key.data,
            nestedType: Key.self
        )
    }
    
    public func deleteKey(id: String) async throws {
        _ = try await databases.deleteDocument(
            databaseId: databaseId,
            collectionId: keysCollectionId,
            documentId: id
        )
    }
}
