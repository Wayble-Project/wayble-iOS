import Foundation

enum DayUtils {
    
    static let dayOrder: [String] = [
        "monday", "tuesday", "wednesday", "thursday",
        "friday", "saturday", "sunday"
    ]

    static func Kday(_ key: String) -> String {
        switch key {
        case "monday": return "월"
        case "tuesday": return "화"
        case "wednesday": return "수"
        case "thursday": return "목"
        case "friday": return "금"
        case "saturday": return "토"
        case "sunday": return "일"
        default: return key
        }
    }
    
    static func BusinessHourDisplay(from businessHours: [String: OpeningHours]) -> [(label: String, hours: OpeningHours)] {
        dayOrder.compactMap { day in
            if let hours = businessHours[day] {
                return (Kday(day), hours)
            } else {
                return nil
            }
        }
    }

    
    static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()

}
