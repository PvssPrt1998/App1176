import Foundation

enum Screen {
    case splash
    case main
    case onboarding
    case subscriptionView
    case rateScreen
}

enum TabScreen {
    case generationChoice
    case videoImageGenerator
    case videoResult
    case promtResult
}

enum LoadingState {
    case loading
    case noConnection
    case loaded
    case violateContent
}
