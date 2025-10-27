import Foundation

@MainActor
final class WeatherViewModel: WeatherViewModelProtocol {
    
  
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let networkManager: NetworkService
    
    init(networKManager: NetworkService) {
        self.networkManager = networKManager
    }
    
    func loadWeather(city: String) async {
        do {
            isLoading = true
            errorMessage = nil
            
            let result = try await networkManager.fetchWeather(city: city)
            weather = result
        } catch {
            errorMessage = error.localizedDescription
            print("Помилка: \(error)")
        }
        
        isLoading = false
    }
}
