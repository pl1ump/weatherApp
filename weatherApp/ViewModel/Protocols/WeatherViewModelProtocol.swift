import Foundation

@MainActor
protocol WeatherViewModelProtocol: ObservableObject {
    var weather: WeatherResponse? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadWeather(city: String) async
}
