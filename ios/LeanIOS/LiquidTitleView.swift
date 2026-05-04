//
//  LiquidTitleView.swift
//  TradePulse
//

import UIKit

@objc(LEANLiquidTitleView)
class LiquidTitleView: UIView {

    private let label = UILabel()

    @objc
    var text: String? {
        didSet {
            label.text = text
            self.invalidateIntrinsicContentSize()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 22
        layer.masksToBounds = true
        backgroundColor = UIColor.black.withAlphaComponent(0.3)

        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 32, height: 44)
    }
}
