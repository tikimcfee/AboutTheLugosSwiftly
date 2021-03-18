# Things learned
---

#### Swift Package Manager

* `swift package generate-xcodeproj` does what it sounds like; it generates a project file for configuration. That's great to know - it's a way to start making more complicated changes - like embedding / linking libraries - a little more easily.
* Target for this is understanding when to include the library manually, and when it seems to be automatically available at runtime. Might be a property of dynamic libs, or I'm completely off my rocker.


**Overflow wisdom:**

> Just to clarify/simplify Daniel's Dunbar answer, after every

> ```swift package update```

> u should generate xcodeproj again:

> ```swift package generate-xcodeproj```


#### swift-ast-explorer

* The goal in using this is to maybe yoink the traversal process, keep the row/column setup and do a map-style rendering of the text in LookAtThat instead of the setup now. 

> The idea of building bottom-to-top turned out hacky and hard to reason. Mostly from a place of ignorance to the grammar of the language, and my inexperience in traversing arbitrarily defined trees.

> Science! Done badly!


* Can't get it to run in `debug` mode, spins a server but resets connections in `release` mode.
> Correction: I needed to set a working directory that wasn't the sandbox. Everything was fine after that so… hooray! I can continue!
* Doesn't quite work with 5.3 toolchain, seems to be related to `arm64` architecture symols in the M1.
* I haven't really been rigorous with testing this.


