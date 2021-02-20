import Foundation
import Ink
import CSS
import Html
import StylesData

print("Writing assets...")
do {
    try AssetWriter.writeAllAssets()
    print("Done!")
} catch {
    print(error)
}
