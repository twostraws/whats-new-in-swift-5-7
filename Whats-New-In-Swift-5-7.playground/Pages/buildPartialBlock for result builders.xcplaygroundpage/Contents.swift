/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# buildPartialBlock for result builders

[SE-0348](https://github.com/apple/swift-evolution/blob/main/proposals/0348-buildpartialblock.md) dramatically simplifies the overloads required to implement complex result builders, which is part of the reason Swift’s advanced regular expression support was possible. However, it also theoretically removes the 10-view limit for SwiftUI without needing to add variadic generics, so if it’s adopted by the SwiftUI team it will make a lot of folks happy.

To give you a practical example, here’s a simplified version of what SwiftUI’s `ViewBuilder` looks like:
*/
import SwiftUI

@resultBuilder
struct SimpleViewBuilderOld {
    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> where C0 : View, C1 : View {
        TupleView((c0, c1))
    }
    
    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView<(C0, C1, C2)> where C0: View, C1: View, C2: View {
        TupleView((c0, c1, c2))
    }
}
/*:
I’ve made that to include two versions of `buildBlock()`: one that accepts two views and one that accepts three. In practice, SwiftUI accepts a wide variety of alternatives, but critically only up to 10 – there’s a `buildBlock()` variant that returns `TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>`, but there isn’t anything beyond that for practical reasons.

We could then use that result builder with functions or computed properties, like this:
*/
@SimpleViewBuilderOld func createTextOld() -> some View {
    Text("1")
    Text("2")
    Text("3")
}
/*:
That will accept all three `Text` views using the `buildBlock<C0, C1, C2>()` variant, and return a single `TupleView` containing them all. However, in this simplified example there’s no way to add a *fourth* `Text` view, because I didn’t provide any more overloads in just the same way that SwiftUI doesn’t support 11 or more.

This is where the new `buildPartialBlock()` comes in, because it works like the `reduce()` method of sequences: it has an initial value, then updates that by adding whatever it has already to whatever comes next. 

So, we could create a new result builder that knows how to accept a single view, and how to combine that view with another one:
*/
@resultBuilder
struct SimpleViewBuilderNew {
    static func buildPartialBlock<Content>(first content: Content) -> Content where Content: View {
        content
    }
    
    static func buildPartialBlock<C0, C1>(accumulated: C0, next: C1) -> TupleView<(C0, C1)> where C0: View, C1: View {
        TupleView((accumulated, next))
    }
}
/*:
Even though we only have variants accepting one or two views, because they *accumulate* we can actually use as many as we want:
*/
@SimpleViewBuilderNew func createTextNew() -> some View {
    Text("1")
    Text("2")
    Text("3")
}
/*:
The result isn’t *identical*, however: in the first example we would get back a `TupleView<Text, Text, Text>`, whereas now we would get back a `TupleView<(TupleView<(Text, Text)>, Text)>` – one `TupleView` nested inside another. Fortunately, if the SwiftUI team do intend to adopt this they ought to be able to create the same 10 `buildPartialBlock()` overloads they had before, which should mean the compile automatically creates groups of 10 just like we’re doing explicitly right now.

**Tip:** `buildPartialBlock()` is part of Swift as opposed to any platform-specific runtime, so if you adopt it you’ll find it back deploys to earlier OS releases.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/