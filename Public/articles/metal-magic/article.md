# GPU Programming  = wat

This is just musing. So far, I've written exactly two shader functions for Metal, both of which are basically copy-adopted from Stack Overflow and multiple tutorials about Metal programming. First off, please give some mega respect and props to these folks for propping me up and offering excellent tutorials and advice for my tiny graphics project:

* Warren Moore - [Metal by Example](https://metalbyexample.com/)
* Rick Twohy - [2E Tutorials](https://www.youtube.com/c/2etime)
* Everything about Metal (Marius Horga) - [MetalKit](https://metalkit.org/)
* (if your name is missing, ping me!)

Second off, GPU programming is _wat_.

I've finally been able to do what I think I've been needing / wanting to do, which apparently is called [instancing (link for tutorial)](https://www.youtube.com/watch?v=D9b61K0UZJo&list=PLEXt1-oJUa4BVgjZt9tK2MhV_DW7PVDsg&index=16). With it, you provide a mesh and a buffer of constants, and that mesh is drawn repeatedly and in parallel all over the canvas. You provide additional vertices from the vertex function by indexing into the array of constants, and deriving some new vertex from any data you wish to attach.

In my case of glyphs, I ended up storing the texture UV coordinates for a basic texture atlas (an article is due for that, if only for the sake of documenting the glue of it all). Vertex function gets the mesh and a constant, its properties multiply out a new vertex, and the texture coordinate is associated with that new vertex.

The fun of all of this is that the original bottleneck of SceneKit is basically gone - I'm rendering upwards of 5,000,000 glyphs (actual instanced nodes generated on the fly) at 60fps, and able to fly around without issue. **Note that this is _without_ state changes**, which still require a subtler approach to updating the backing buffer and its representing nodes. For example, the current code has uses [InstanceState](https://github.com/tikimcfee/LookAtThat/blob/experiments/metal-link/MetalLink/MetalLinkObjects/Instancing/MetalLinkInstancedObject%2BState.swift) to capture and rebuild its entire buffer, but this is expensive to do per frame and for each node.

Anyway, the musing here is mostly for a quick screencap of the app rendering itself - finally - at 60fps! That's every file, nothing filtered, all at once. This makes me smile.

<img src="metal-magic/manychar.jpg" alt="the LookAtThat project full glyph set rendered front to back" style="max-width:100%"/>

## Next up

#### Rebuilding the interactive layer from the original SceneKit implementation. 

* Much will be stolen from [Metal-Picking](https://github.com/metal-by-example/metal-picking), another wonderful Mooreism.

#### Rebuilding / rewiring the lookup mechanism from CodeGrid and SemanticInfo. 

* Don't know which way to go with this - some of the complexities were from the slow build up of CodeGrid, and some of it just works well. I think it could do for a rewrite… the flow is different enough now that I have a better idea of how to do everything needed: 
* Load files > build glyph atlas > render files with highlighting into a GlyphCollection (or more than one)

#### With great node comes great responsibility

* Get Treesitter in here. I like being able to use the SyntaxParser, but it's cumbersome to deploy and limited to Swift. I may not get the same bang out of Treesitter, but I imagine it'll be pretty darn close. I still haven't cracked basic runtime tracing for anything by Swift anyway, so exploring this may give some ideas on how to map between other language traces and their programs' AST.