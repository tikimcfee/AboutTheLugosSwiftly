# VR + AR Visualization  in SceneKit

## What is it?

[LookAtThat on Github](https://github.com/tikimcfee/LookAtThat/)

See Swift in Space! 

A tool to load up Swift files, render them into a SceneKit layer, and view the results in a 3D VR (macOS) or AR (iOS) environment.


## Why do it?

Lots of reasons why! Here are some smarter people with better presentation skills and more carefully studied reasons:

* [Embodied Code](https://embodiedcode.net/) - A look into a team of folks using true physical metaphors and current-stage tech to power VR experiences with manipulating code (and code effects) in space.
 
- [Rethinking Visual Programming in Go](https://divan.dev/posts/visual_programming_go/) - An excellent write up with a great historical context of this project's space, and gets into well reasoned and poignant ideas for why 3D space is a as-yet-underutilized space for programming.

- [STARS Code Park](https://stars.library.ucf.edu/etd/5511/) (UCF!) - My alma mater had a semi-recent student created writeup on using a specific set of tools to create a VR ennvironment for code analysis, and ran some interesting statistics on the results of people using the tool.

- <your name here / link here> - Tell me your thoughts and your projects related to visualizing code - the more the merrier!
  
## How's it work?

Lots and lots of other people's tools and code suggestions. Primarily:

- [Apple's SceneKit](https://developer.apple.com/scenekit/) and a light AR wrapper for mobile on iPhone and iPad support.
- [SwiftSyntax](https://github.com/apple/swift-syntax) for parsing Swift files and grabbing an Abstract Syntax Tree.
- [SwiftTrace](https://github.com/johnno1962/SwiftTrace) to capture execution traces and generate small tracing corpuses for visualization.
- [CodeEditorView](https://github.com/mchakravarty/CodeEditorView) because it's a great simple drop in for text-field editing in SwiftUI
- [FileKit](https://github.com/nvzqz/FileKit) just because it's a nice abstraction.

### How to run it

You will need everything in this repository, including the syntax parsing libraries for SwiftSyntax targeting macOS, and iOS - play along with your phone or tablet!

The current goal is to allow you to:

- Pull the project
- Run it from XCode, targeting your iPhone, iPad or Mac
- See code in space

At the moment, none of the important things with respect to building a functioning release binary are in place. Everything is experimental, unstable, and ready to explode at any moment. It's very exciting.

## What's next?

Likely to be out of date sooner rather than later, here's a running list of target features, fixes, and ideas being worked on now-ish!

### Editing

-  Using a standard 2D editor to select and edit selected files in-line, rendering as necessary.

### Focusing and Highlighting

- Update GlyphNode to support smarter focusing; more geometry slots, better caching flow, etc.

### Tracing

- Multi-queue: currently traces one queue at a time. Trace each running queue simultaneously.
- Static lines: draw paths through an ordered set of trace lines to create 'static' visualization of call flow

### UI

- Update mobiles interfaces. Most controls are supported on iPhone / iPad. Use interface.idiom to create different layouts per device.
- Update mainframe interfaces: add support to dock/popout panel windows (fun!)

### Language Server / Sourcekit

- Jump to definition to auto-render and jump to grid syntax nodes
- Server/client interaction from phone to mainframe (pretty much no way to get sourcekit-lsp running on device AFAIK)

### Misc Experiments

- TapKit: I bought this weird TapStrap thing for more inputs. It's kinda fun for shortcuts. Code is there play with.
- [Cool TapKit AR sample from Zack Qattan!](https://youtube.com/shorts/5J7k5tu-MZ8?feature=share) -> [They're on YouTube!](https://www.youtube.com/c/ZackQattan)
