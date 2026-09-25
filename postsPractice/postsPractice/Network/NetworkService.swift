import Foundation
import Alamofire


protocol NetworkServiceProtocol {
    func fetchPosts() async throws -> [Post]
}


class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    func fetchPosts() async throws -> [Post] {
        try await AF.request("\(baseURL)/posts")
            .validate()
            .serializingDecodable([Post].self)
            .value
    }
}
