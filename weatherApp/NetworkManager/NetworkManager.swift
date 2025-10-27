import Foundation

protocol NetworkService {
    func fetchWeather(city: String) async throws -> WeatherResponse
    func fetchForecast(city: String) async throws -> ForecastResponse
}

final class NetworkManager: NetworkService {
    private let apiKey: String
    
    init(apiKey: String? = nil) {
        
        if let key = apiKey {
            self.apiKey = key
        } else {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
                fatalError("Error: API_KEY not found in Info.plist")
            }
            self.apiKey = key
        }
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.unauthorized(message: apiError?.message)
            case 404:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.notFound(message: apiError?.message)
            case 429:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.rateLimited(message: apiError?.message)
            case 400...499:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.clientError(statusCode: httpResponse.statusCode, message: apiError?.message)
            case 500...599:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: apiError?.message)
            default:
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw NetworkError.unknown(statusCode: httpResponse.statusCode, message: apiError?.message)
            }
        }
        catch {
            throw NetworkError.transportError(error)
        }
    }
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = urlComponents.url else { throw NetworkError.invalidURL }
        
        
        let data = try await fetchData(from: url)
        do {
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchForecast(city: String) async throws -> ForecastResponse {
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast") else {
            throw NetworkError.invalidURL
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "d3322ac1b76c41b7ea438325914b120b"),
            URLQueryItem(name: "units", value: "metric")]
        
        guard let url = urlComponents.url else { throw NetworkError.invalidURL }
        
        let data = try await fetchData(from: url)
        do {
            return try JSONDecoder().decode(ForecastResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

