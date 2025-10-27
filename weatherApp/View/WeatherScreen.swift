import SwiftUI

struct WeatherScreen<ViewModel: WeatherViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    @State private var city = ""
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
           _viewModel = StateObject(wrappedValue: viewModel())
       }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                TextField("textFieldSearch", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("buttonSearch") {
                    Task {
                        await viewModel.loadWeather(city: city)
                    }
                }
            }
            .padding()
            Spacer()
            
            if viewModel.isLoading {
                Text("loadWeather")
            } else if let weather = viewModel.weather {
                weatherView(weather)
            }   else {
                Text("noData")
            }
            Spacer()
        }
        .padding()
    }
    
    func weatherView(_ weather: WeatherResponse) -> some View {
        VStack {
            Text(weather.name)
                .font(.largeTitle)
                .bold()

            Text("\(Int(weather.main.temp))°C")
                .font(.system(size: 64))
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                ForEach(weather.weather, id: \.icon) { condition in
                    HStack {
                        AsyncImage(
                            url: URL(string: "https://openweathermap.org/img/wn/\(condition.icon)@2x.png"))
                        { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(condition.description.capitalized)
                            .font(.headline)
                    }
                }
            }
        }
    }
    
}

#Preview {
    WeatherScreen(viewModel: WeatherViewModel(networKManager: NetworkManager()))
}
