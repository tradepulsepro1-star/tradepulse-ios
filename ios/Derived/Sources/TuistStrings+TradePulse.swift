// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum TradePulseStrings: Sendable {
  public enum InfoPlist {
  }
  public enum Localizable {
  /// Cancel
    public static let buttonCancel = TradePulseStrings.tr("Localizable", "button-cancel")
    /// Copy link address
    public static let buttonCopyLink = TradePulseStrings.tr("Localizable", "button-copy-link")
    /// Done
    public static let buttonDone = TradePulseStrings.tr("Localizable", "button-done")
    /// Menu
    public static let buttonMenu = TradePulseStrings.tr("Localizable", "button-menu")
    /// OK
    public static let buttonOk = TradePulseStrings.tr("Localizable", "button-ok")
    /// Open link in external browser
    public static let buttonOpenExternal = TradePulseStrings.tr("Localizable", "button-open-external")
    /// Share link
    public static let buttonShareLink = TradePulseStrings.tr("Localizable", "button-share-link")
    /// View
    public static let buttonView = TradePulseStrings.tr("Localizable", "button-view")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension TradePulseStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftformat:enable all
// swiftlint:enable all
