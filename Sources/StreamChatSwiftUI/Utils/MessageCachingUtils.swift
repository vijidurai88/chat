//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat

/// Caches messages related data to avoid accessing the database.
/// Cleared on chat channel view dismiss or memory warning.
class MessageCachingUtils {
    
    private var messageAuthorMapping = [String: String]()
    private var messageAuthors = [String: UserDisplayInfo]()
    private var messageAttachments = [String: Bool]()
    private var checkedMessageIds = Set<String>()
    private var quotedMessageMapping = [String: ChatMessage]()
    
    func authorId(for message: ChatMessage) -> String {
        if let userDisplayInfo = userDisplayInfo(for: message) {
            return userDisplayInfo.id
        }
        
        let userDisplayInfo = saveUserDisplayInfo(for: message)
        return userDisplayInfo.id
    }
    
    func authorName(for message: ChatMessage) -> String {
        if let userDisplayInfo = userDisplayInfo(for: message) {
            return userDisplayInfo.name
        }
        
        let userDisplayInfo = saveUserDisplayInfo(for: message)
        return userDisplayInfo.name
    }
    
    func authorImageURL(for message: ChatMessage) -> URL? {
        if let userDisplayInfo = userDisplayInfo(for: message) {
            return userDisplayInfo.imageURL
        }
        
        let userDisplayInfo = saveUserDisplayInfo(for: message)
        return userDisplayInfo.imageURL
    }
    
    func quotedMessage(for message: ChatMessage) -> ChatMessage? {
        if checkedMessageIds.contains(message.id) {
            return nil
        }
        
        if let quoted = quotedMessageMapping[message.id] {
            return quoted
        }
        
        let quoted = message.quotedMessage
        if quoted == nil {
            checkedMessageIds.insert(message.id)
        } else {
            quotedMessageMapping[message.id] = quoted
        }
        
        return quoted
    }
    
    func clearCache() {
        log.debug("Clearing cached message data")
        messageAuthorMapping = [String: String]()
        messageAuthors = [String: UserDisplayInfo]()
        messageAttachments = [String: Bool]()
        checkedMessageIds = Set<String>()
        quotedMessageMapping = [String: ChatMessage]()
    }
    
    // MARK: - private
    
    private func userDisplayInfo(for message: ChatMessage) -> UserDisplayInfo? {
        if let userId = messageAuthorMapping[message.id],
           let userDisplayInfo = messageAuthors[userId] {
            return userDisplayInfo
        } else {
            return nil
        }
    }
    
    private func saveUserDisplayInfo(for message: ChatMessage) -> UserDisplayInfo {
        let user = message.author
        let userDisplayInfo = UserDisplayInfo(
            id: user.id,
            name: user.name ?? user.id,
            imageURL: user.imageURL
        )
        messageAuthorMapping[message.id] = user.id
        messageAuthors[user.id] = userDisplayInfo
        
        return userDisplayInfo
    }
    
    private func checkAttachments(for message: ChatMessage) -> Bool {
        let hasAttachments = !message.attachmentCounts.isEmpty
        messageAttachments[message.id] = hasAttachments
        return hasAttachments
    }
}

struct UserDisplayInfo {
    let id: String
    let name: String
    let imageURL: URL?
}