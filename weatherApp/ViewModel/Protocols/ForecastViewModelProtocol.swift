import Foundation
@MainActor
protocol ForecastViewModelProtocol: ObservableObject {
    
    var city: String {get set}
    var weatherForecasts: [Forecast] {get}
    var cityInfo: City? {get}
    var errorMessage: String? {get}
    var isLoading: Bool {get}
    var groupedForecasts: [String: [Forecast]] {get}
    
    func loadForecast() async
    func formatDate(_ dateStr: String) -> String
    func formatTime(_ dateStr: String) -> String
    
}
