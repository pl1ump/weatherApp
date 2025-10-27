import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct ForecastResponse: Codable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable {
    let dt: Int
    let dt_txt: String
    let main: Main
    let weather: [Weather]
}

struct City: Codable {
    let name: String
    let country: String
}
