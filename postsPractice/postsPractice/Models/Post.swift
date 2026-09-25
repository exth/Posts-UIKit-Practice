import Foundation


struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
