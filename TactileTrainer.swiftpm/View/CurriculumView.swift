//
//  CurriculumView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/21/26.
//

import SwiftUI

struct CourseItem: Identifiable {
    let id = UUID()
    let level: String
    let title: String
    let description: String
    let icon: String
    let progress: Double
    let color: Color
}

struct CurriculumView: View {
    let courses = [
        CourseItem(level: "Level 01", title: "감각 깨우기", description: "화면 속 숨겨진 점을 찾아 터치하며 손끝의 신경을 활성화합니다.", icon: "sparkles", progress: 1.0, color: .orange),
        CourseItem(level: "Level 02", title: "기본 자모음", description: "한글의 기본 자음과 모음의 점자 형태를 하나씩 익힙니다.", icon: "character.book.closed.fill", progress: 0.4, color: .red)
    ]
    
    var body: some View {
        NavigationView {
            List(courses) { course in
                NavigationLink(destination: CourseDetailView(course: course)) {
                    HStack(spacing: 16) {
                        Circle().fill(course.color.opacity(0.15)).frame(width: 50, height: 50)
                            .overlay(Image(systemName: course.icon).foregroundColor(course.color))
                        VStack(alignment: .leading) {
                            Text(course.level).font(.caption2).bold().foregroundColor(course.color)
                            Text(course.title).font(.headline).foregroundColor(.white)
                            ProgressView(value: course.progress).tint(course.color)
                        }
                    }
                }
                .listRowBackground(Color.black)
            }
            .navigationTitle("학습 코스")
            .background(Color.black)
            .scrollContentBackground(.hidden)
        }
    }
}

struct CourseDetailView: View {
    let course: CourseItem
    @StateObject private var hapticManager = TactileHapticManager()
    @State private var targetPoint = CGPoint(x: 180, y: 300)
    @State private var found = false

    var body: some View {
        ZStack {
            TactileTheme.highContrastBlack.ignoresSafeArea()
            
            VStack {
                Text(found ? "찾았습니다!" : "화면을 훑으며 숨겨진 점을 찾으세요")
                    .font(.headline)
                    .foregroundColor(found ? .yellow : .white)
                    .padding()
                
                Spacer()
            }
            
            if course.level == "Level 01" {
                Rectangle()
                    .fill(Color.white.opacity(0.001))
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { val in
                                let dist = sqrt(pow(val.location.x - targetPoint.x, 2) + pow(val.location.y - targetPoint.y, 2))
                                if dist < 45 {
                                    hapticManager.handleTouch(unitIdx: 0, dots: [true, true, true, true, true, true], loc: .zero)
                                    found = true
                                } else {
                                    found = false
                                }
                            }
                    )
            }
        }
        .navigationTitle(course.title)
    }
}

#Preview {
    CurriculumView()
}
