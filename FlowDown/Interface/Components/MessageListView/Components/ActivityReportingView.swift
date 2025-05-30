//
//  Created by ktiays on 2025/2/20.
//  Copyright (c) 2025 ktiays. All rights reserved.
//

import GlyphixTextFx
import UIKit

final class ActivityReportingLabel: UIView {
    var text: String? {
        set {
            textLabel.text = newValue ?? .init()
            setNeedsLayout()
            UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0) {
                self.layoutIfNeeded()
            }
        }
        get { textLabel.text }
    }

    let textLabel: GlyphixTextLabel = .init().with {
        $0.font = ActivityReportingLabel.font
        $0.isBlurEffectEnabled = false
    }

    private let loadingSymbol: LoadingSymbol = .init()

    static let loadingSymbolSize: CGSize = .init(width: 30, height: 10)
    static let font: UIFont = .systemFont(ofSize: 15)

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.textColor = .label
        textLabel.textAlignment = .leading
        addSubview(textLabel)

        loadingSymbol.dotRadius = 2
        loadingSymbol.spacing = 3
        loadingSymbol.animationDuration = 0.3
        loadingSymbol.animationInterval = 0.1
        addSubview(loadingSymbol)

        textLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        loadingSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(textLabel)
            make.leading.equalTo(textLabel.snp.trailing)
            make.size.equalTo(Self.loadingSymbolSize)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ActivityReportingView: MessageListRowView {
    var text: String? {
        set { reportingLabel.text = newValue }
        get { reportingLabel.text }
    }

    private let reportingLabel: ActivityReportingLabel = .init()

    static let loadingSymbolSize: CGSize = ActivityReportingLabel.loadingSymbolSize
    static let font: UIFont = ActivityReportingLabel.font

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(reportingLabel)
        reportingLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    @MainActor required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func themeDidUpdate() {
        super.themeDidUpdate()
        reportingLabel.textLabel.font = theme.fonts.body
    }
}
