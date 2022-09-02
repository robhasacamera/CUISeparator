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

/// A styled separator that can be used to visual separate views. Useful for separating views into different groups when using a Stack or ScrollView.
public struct CUISeparator: View {
    @Environment(\.displayScale)
    var displayScale: CGFloat

    /// The style defines how the separator is draw.
    public enum Style: Identifiable, CaseIterable {
        /// Draws a solid line for the separator.
        case solid
        /// Draws a dashed line for the separator. This uses butted line caps.
        case dashed
        /// Draws a dotted line for the separator. This uses rounded line caps.
        case dotted

        public var id: Style { self }
    }

    /// The weight defines the thickness of the separator.
    ///
    /// The weight will scales the spacing and length of any segmented ``CUISeparator/Style`` such as ``CUISeparator/Style/dashed``.
    public enum Weight: Identifiable, CaseIterable {
        /// The thinest separator that can be displayed. Recommended for adding a subtle separation between elements.
        ///
        /// This uses the display scale to calculate the thickness. This will be displayed at 1 *actual* pixel, not a point.
        case thin
        /// The default thickness for a separator. Recommended for most cases.
        case regular
        /// A thicker seprator. Recommended for emphasizing a separation between views.
        case bold
        /// A much thicker separator. Recommended for use when needing separation between elements that are already using ``bold`` style separators.
        case heavy

        public var id: Weight { self }
    }

    /// The orientation for the separator.
    public enum Orientation: Identifiable, CaseIterable {
        /// Provides a leading to trailing separator.
        case horizontal
        /// Provides a top to bottom separator.
        case vertical

        public var id: Orientation { self }
    }

    var style: Style
    var weight: Weight
    var orientation: Orientation

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

    @ScaledMetric
    var regularWeight: CGFloat = 1

    @ScaledMetric
    var boldWeight: CGFloat = 2

    @ScaledMetric
    var heavyWeight: CGFloat = 3

    var lineWidth: CGFloat {
        switch weight {
        case .thin:
            return max(regularWeight, 1) / displayScale
        case .regular:
            return regularWeight
        case .bold:
            return boldWeight
        case .heavy:
            return heavyWeight
        }
    }

    /// Creates a separator that can be used to separator views visually.
    /// - Parameters:
    ///   - style: The stlye of the separator.
    ///   See ``CUISeparator/Style`` for more info.
    ///   - weight: The weight of the separator
    ///   See ``CUISeparator/Weight`` for more info.
    ///   - orientation: The orientation of the separator.
    ///   See ``CUISeparator/Orientation`` for more info.
    public init(
        style: Style = .solid,
        weight: Weight = .regular,
        orientation: CUISeparator.Orientation = .horizontal
    ) {
        self.style = style
        self.weight = weight
        self.orientation = orientation
    }

    public var body: some View {
        _CUISeparatorPath(orientation: orientation)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, dash: dash))
            .frame(
                width: orientation == .vertical ? max(lineWidth, 1) : nil,
                height: orientation == .horizontal ? max(lineWidth, 1) : nil
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
        CUICenteredPreview(title: ".horizontal, style & weight") {
            VStack {
                ForEach(CUISeparator.Style.allCases) { style in
                    ForEach(CUISeparator.Weight.allCases) { weight in
                        CUICaptionedView("\(style), \(weight)") {
                            CUISeparator(
                                style: style,
                                weight: weight,
                                orientation: .horizontal
                            )
                        }
                    }
                    Spacer(minLength: 30)
                }

                ForEach(CUISeparator.Style.allCases) { style in
                    CUICaptionedView("\(style), .foregroundColor(.yellow)") {
                        CUISeparator(
                            style: style,
                            orientation: .horizontal
                        )
                        .foregroundColor(.yellow)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }

        CUICenteredPreview(title: ".horizontal, size categories") {
            VStack {
                ForEach(CUISeparator.Weight.allCases) { weight in
                    CUICaptionedView(".xs, \(weight)") {
                        CUISeparator(
                            weight: weight,
                            orientation: .horizontal
                        )
                        .environment(\.sizeCategory, .extraSmall)
                    }
                }
                Spacer(minLength: 30)

                ForEach(CUISeparator.Weight.allCases) { weight in
                    CUICaptionedView(".xxxl, \(weight)") {
                        CUISeparator(
                            weight: weight,
                            orientation: .horizontal
                        )
                        .environment(\.sizeCategory, .extraExtraExtraLarge)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }

        CUICenteredPreview(title: ".vertical, style & weight") {
//            ScrollView(.horizontal) {
            VStack(alignment: .center) {
                ForEach(CUISeparator.Style.allCases) { style in
                    HStack {
                    ForEach(CUISeparator.Weight.allCases) { weight in
                        CUICaptionedView("\(style), \(weight)") {
                            CUISeparator(
                                style: style,
                                weight: weight,
                                orientation: .vertical
                            )
                        }
                    }
                    }
                }
            }
//            }
        }
    }
}

extension ContentSizeCategory: Identifiable {
    public var id: ContentSizeCategory { self }
}
