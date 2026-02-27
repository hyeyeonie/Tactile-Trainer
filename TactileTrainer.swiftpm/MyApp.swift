import SwiftUI

@main
struct TactileTrainerApp: App {
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true

    var body: some Scene {
        WindowGroup {
            TabView {
                BasicView()
                    .tabItem { Label("기초", systemImage: "hand.tap.fill") }
                
                HomeView()
                    .tabItem { Label("연습", systemImage: "hand.point.up.braille.fill") }
                
                ScanView()
                    .tabItem { Label("스캔", systemImage: "viewfinder.circle.fill") }
                
                SettingView()
                    .tabItem { Label("설정", systemImage: "gear") }
            }
            .accentColor(TactileTheme.mainColor)
            .preferredColorScheme(isHighContrast ? .dark : .light)
        }
    }
}
