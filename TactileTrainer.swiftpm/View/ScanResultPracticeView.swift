//
//  ScanResultPracticeView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI
import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

struct ScanResultPracticeView: View {
    let text: String
    @StateObject private var hapticManager = TactileHapticManager()
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        ZStack {
            (isHighContrast ? TactileTheme.highContrastBlack : Color(uiColor: .systemGroupedBackground))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                let units = TactileConverter.getBrailleUnits(for: text)
                
                TabView {
                    ForEach(units.indices, id: \.self) { idx in
                        let unit = units[idx]
                        let intDots = unit.dots.map { $0 ? 1 : 0 }
                        
                        VStack {
                            Spacer()
                            
                            BraillePlate(
                                fullText: text,
                                char: unit.char,
                                dots: intDots,
                                type: unit.type,
                                activeDot: hapticManager.activeDot,
                                onTouch: { loc, w, h in
                                    hapticManager.handleTouchInArea(
                                        unitIdx: idx,
                                        dots: intDots,
                                        loc: loc,
                                        viewWidth: w,
                                        viewHeight: h
                                    )
                                },
                                onTouchEnd: { hapticManager.reset() }
                            )
                            .padding(.horizontal, 30)
                            
                            Spacer().frame(height: 60)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            hapticManager.reset()
            setupAppearance(isHighContrast: isHighContrast)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("스캔 결과")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(TactileTheme.mainColor)
            
            Text(text)
                .font(.system(size: 36, weight: .heavy))
                .foregroundColor(isHighContrast ? .white : .black)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
        .padding(.bottom, 10)
    }
    
    private func setupAppearance(isHighContrast: Bool) {
        UIPageControl.appearance().currentPageIndicatorTintColor = isHighContrast ? .white : .black
        UIPageControl.appearance().pageIndicatorTintColor = (isHighContrast ? UIColor.white : UIColor.black).withAlphaComponent(0.2)
    }
}
