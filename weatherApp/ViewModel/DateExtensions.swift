import Foundation

extension String {
    func toDate(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

extension Date {
    func toString(_ format: String = "EEEE, d MMM") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
