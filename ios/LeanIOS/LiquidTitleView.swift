//
//  LiquidTitleView.swift
//  TradePulse
//

import UIKit

@objc(LEANLiquidTitleView)
public class LiquidTitleView: UIView {

    private let label = UILabel()
    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemMaterial)
        return UIVisualEffectView(effect: effect)
    }()

    @objc
    public var text: String? {
        didSet {
            label.text = text
            self.invalidateIntrinsicContentSize()
            UIView.animate(withDuration: 0.4, delay: 0,
                           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
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
        blurView.layer.cornerRadius = 22
        blurView.clipsToBounds = true
        addSubview(blurView)

        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override var intrinsicContentSize: CGSize {
        let s = label.intrinsicContentSize
        return CGSize(width: s.width + 32, height: 44)
    }
}
