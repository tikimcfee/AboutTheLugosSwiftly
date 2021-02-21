import Foundation
import SharedAppTools

public struct AssetWriter {
    private init() { }
    
    public static func writeAllAssets() throws {
        try writeGlobalCss()
    }

    public static func writeGlobalCss() throws {
        try sharedPageCss.string().write(
            to: rootFile(named: "global.css"),
            atomically: true,
            encoding: .utf8
        )
    }
}
