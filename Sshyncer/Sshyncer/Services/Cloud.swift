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
import Combine

#if DEBUG
let projectId = "ssyncer"
#else
let projectId = "ssyncer"
#endif

let databaseId = "ssyncer"
let hostsCollectionId = "hosts"
let keysCollectionId = "keys"
let tunnelsCollectionId = "tunnels"
let queryLimit = 50

class Cloud: ObservableObject {
    static let shared = Cloud()
    
    private var client: Client
    
    var account: Account
    var databases: Databases
    var functions: Functions
    var storage: Storage
    
    @JSONAppStorage(key: "user") private var persistedUser: User<Prefs>?
    @JSONAppStorage(key: "session") private var persistedSession: Session?
    
    @Published var user: User<Prefs>?
    @Published var session: Session?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        client = Client()
            .setProject(projectId)
        
        account = Account(client)
        databases = Databases(client)
        functions = Functions(client)
        storage = Storage(client)
        
        self.user = persistedUser
        self.session = persistedSession
        
        $user
            .sink { [weak self] newUser in
                self?.persistedUser = newUser
            }
            .store(in: &cancellables)
        
        $session
            .sink { [weak self] newSession in
                self?.persistedSession = newSession
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Authentication
    
    public func isLoggedInAnonymous() async -> Bool {
        await isLoggedIn() && user?.email.isEmpty == true
    }
    
    public func isLoggedIn() async -> Bool {
        if user != nil {
            return true
        }

        do {
            _ = try await getAccount()
            _ = try await getSession()
            
            return true
        } catch {
            return false
        }
    }
    
    public func createEmailAccount(_ email: String, _ password: String) async throws {
        user = try await account.create(
            userId: ID.unique(),
            email: email,
            password: password,
            nestedType: Prefs.self
        )
    }
    
    public func createEmailSession(_ email: String, _ password: String) async throws {
        session = try await account.createEmailPasswordSession(email: email, password: password)
    }
    
    public func createOAuth2Session(_ provider: OAuthProvider) async throws -> Bool {
        if try await account.createOAuth2Session(provider: provider) {
            _ = try await getAccount(fresh: true)
            _ = try await getSession(fresh: true)
            
            return true
        }
        
        return false
    }
    
    public func createAnonymousSession() async throws {
        session = try await account.createAnonymousSession()
        user = try await account.get(nestedType: Prefs.self)
    }
    
    public func getAccount(fresh: Bool = false) async throws -> User<Prefs>? {
        if !fresh, let user = user {
            return user
        }
        
        user = try await account.get(nestedType: Prefs.self)
        
        return user
    }
    
    public func getSession(fresh: Bool = false) async throws -> Session? {
        if !fresh, let session = session {
            return session
        }
        
        session = try await account.getSession(sessionId: "current")
        
        return session
    }
    
    public func deleteSession() async throws {
        _ = try await account.deleteSession(sessionId: "current")
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
            data: host.data,
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
