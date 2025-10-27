import Foundation
@MainActor
final class WeatherForecastViewModel: ForecastViewModelProtocol  {
    
    @Published var city: String = ""
    @Published var weatherForecasts = [Forecast]()
    @Published var cityInfo: City?
    @Published var errorMessage: String?
    @Published var isLoading = false
    var groupedForecasts: [String: [Forecast]] {
        Dictionary(grouping: weatherForecasts) { forecast in
            String(forecast.dt_txt.prefix(10))
        }
    }
    
    private var networkManager: NetworkService
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    func loadForecast() async {
           guard !city.isEmpty else { return }
           
           isLoading = true
           weatherForecasts = []
           errorMessage = nil
           
           do {
               let forecastResponse = try await networkManager.fetchForecast(city: city)
               self.cityInfo = forecastResponse.city
               self.weatherForecasts = forecastResponse.list
           } catch {
               self.errorMessage = error.localizedDescription
           }
           
           isLoading = false
       }
    
    func formatDate(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd")?.toString("EEEE, d MMM") ?? dateStr
    }
    
    func formatTime(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd HH:mm:ss")?.toString("HH:mm") ?? dateStr
    }
}
