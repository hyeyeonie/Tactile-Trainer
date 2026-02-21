import SwiftUI

@main
struct TactileTrainerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem { Label("연습", systemImage: "hand.tap.fill") }
                CurriculumView()
                    .tabItem { Label("코스", systemImage: "book.fill") }
                SettingsView()
                    .tabItem { Label("설정", systemImage: "gear") }
            }
            .accentColor(TactileTheme.mainColor)
            .preferredColorScheme(.dark)
        }
    }
}

enum TactileTheme {
    static let mainColor = Color.blue
    static let highContrastBlack = Color.black
    static let cardGray = Color(uiColor: .systemGray6)
    static let activeHighlight = Color.yellow
}
