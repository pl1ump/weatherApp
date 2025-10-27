import Foundation

struct APIErrorResponse: Decodable {
    let cod: String?
    let message: String?
}
