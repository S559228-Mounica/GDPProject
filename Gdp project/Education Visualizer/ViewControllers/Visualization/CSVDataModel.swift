
import Foundation

struct CSVData: Decodable {
    let accountName: String
    let courseName: String
    let assessmentTitle: String
    let learningOutcomeName: String
    let learningOutcomeRating: String

    private enum CodingKeys: String, CodingKey {
        case accountName = "account name"
        case courseName = "course name"
        case assessmentTitle = "assessment title"
        case learningOutcomeName = "learning outcome name"
        case learningOutcomeRating = "learning outcome rating"
    }
}
