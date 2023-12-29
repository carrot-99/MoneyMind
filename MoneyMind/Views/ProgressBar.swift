//  ProgressBar.swift

import SwiftUI

struct ProgressBar: View {
    var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))

                Rectangle().frame(width: max(0, min(CGFloat(self.progress) * geometry.size.width, geometry.size.width)), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear, value: progress)
            }.cornerRadius(45.0)
        }
    }
}
