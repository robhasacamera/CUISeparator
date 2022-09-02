//
// CUIExpandableButton
//
// MIT License
//
// Copyright (c) 2022 Robert Cole
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import CUIPreviewKit
import SwiftUI

public struct CUISeparator: View {
    public enum Style: Identifiable, CaseIterable {
        case solid
        case dashed
        case dotted

        public var id: Style { self }
    }

    public enum Orientation: Identifiable, CaseIterable {
        case horizontal
        case vertical

        public var id: Orientation { self }
    }

    public var style: Style
    public var orientation: Orientation

    var dash: [CGFloat] {
        switch style {
        case .solid:
            return []
        case .dashed:
            return [lineWidth * 5]
        case .dotted:
            return [0.1, lineWidth * 3]
        }
    }

    var lineCap: CGLineCap {
        switch style {
        case .solid: fallthrough
        case .dashed:
            return .butt
        case .dotted:
            return .round
        }
    }

    var lineWidth: CGFloat

    public init(
        style: Style = .solid,
        linewidth: CGFloat = 1,
        orientation: CUISeparator.Orientation = .horizontal
    ) {
        self.style = style
        self.lineWidth = linewidth
        self.orientation = orientation
    }

    public var body: some View {
        _CUISeparatorPath(orientation: orientation)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, dash: dash))
            .frame(
                width: orientation == .vertical ? lineWidth : nil,
                height: orientation == .horizontal ? lineWidth : nil
            )
    }
}

struct _CUISeparatorPath: Shape {
    var orientation: CUISeparator.Orientation

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to:
            CGPoint(
                x: orientation == .horizontal ? rect.width : 0,
                y: orientation == .vertical ? rect.height : 0
            )
        )
        return path
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        CUICenteredPreview(title: ".horizontal") {
            VStack {
                ForEach(CUISeparator.Style.allCases) { style in
                    CUICaptionedView("\(style)") {
                        CUISeparator(
                            style: style,
                            orientation: .horizontal
                        )
                    }
                }

                ForEach(CUISeparator.Style.allCases) { style in
                    CUICaptionedView("\(style) .foregroundColor(.yellow)") {
                        CUISeparator(
                            style: style,
                            orientation: .horizontal
                        )
                        .foregroundColor(.yellow)
                    }
                }

                ForEach(CUISeparator.Style.allCases) { style in
                    CUICaptionedView("\(style)") {
                        CUISeparator(
                            style: style,
                            linewidth: 3,
                            orientation: .horizontal
                        )
                    }
                }
            }
        }

        ForEach(CUISeparator.Orientation.allCases) { orientation in
            CUICenteredPreview {
                CUISeparator(orientation: orientation)
            }
        }
        ForEach(CUISeparator.Orientation.allCases) { orientation in
            CUICenteredPreview {
                CUISeparator(orientation: orientation)
                    .foregroundColor(.yellow)
            }
        }
    }
}
