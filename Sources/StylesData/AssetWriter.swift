import Foundation
import SharedAppTools

public struct AssetWriter {
    private init() { }
    
    public static func writeAllAssets() throws {
        try writeGlobalCss()
    }

    public static func writeGlobalCss() throws {
        try SiteStyling.sharedPageCss.string().write(
            to: rawFile(named: "global.css"),
            atomically: true,
            encoding: .utf8
        )
    }
}
