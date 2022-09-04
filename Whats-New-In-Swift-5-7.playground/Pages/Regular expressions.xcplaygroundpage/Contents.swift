/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Regular expressions

Swift 5.7 introduces a whole raft of improvements relating to regular expressions (regexes), and in doing so dramatically improves the way we process strings. This is actually a whole chain of interlinked proposals, including

- [SE-0350](https://github.com/apple/swift-evolution/blob/main/proposals/0350-regex-type-overview.md) introduces a new `Regex` type
- [SE-0351](https://github.com/apple/swift-evolution/blob/main/proposals/0351-regex-builder.md) introduces a result builder-powered DSL for creating regular expressions.
- [SE-0354](https://github.com/apple/swift-evolution/blob/main/proposals/0354-regex-literals.md) adds the ability co create a regular expression using `/.../` rather than going through `Regex` and a string.
- [SE-0357](https://github.com/apple/swift-evolution/blob/main/proposals/0357-regex-string-processing-algorithms.md) adds many new string processing algorithms based on regular expressions.

Put together this is pretty revolutionary for strings in Swift, which have often been quite a sore point when compared to other languages and platforms. 

To see what’s changing, let’s start simple and work our way up.

First, we can now draw on a whole bunch of new string methods, like so:
*/
let message = "the cat sat on the mat"
print(message.ranges(of: "at"))
print(message.replacing("cat", with: "dog"))
print(message.trimmingPrefix("the "))
/*:
But the real power of these is that they all accept regular expressions too:
*/
print(message.ranges(of: /[a-z]at/))
print(message.replacing(/[a-m]at/, with: "dog"))
print(message.trimmingPrefix(/The/.ignoresCase()))
/*:
In case you’re not familiar with regular expressions:

- In that first regular expression we’re asking for the range of all substrings that match any lowercase alphabetic letter followed by “at”, so that would find the locations of “cat”, “sat”, and “mat”.
- In the second one we’re matching the range “a” through “m” only, so it will print “the dog sat on the dog”.
- In the third one we’re looking for “The”, but I’ve modified the regex to be case insensitive so that it matches “the”, “THE”, and so on.

Notice how each of those regexes are made using *regex literals* – the ability to create a regular expression by starting and ending your regex with a `/`.

Along with regex literals, Swift provides a dedicated `Regex` type that works similarly:
*/
do {
    let atSearch = try Regex("[a-z]at")
    print(message.ranges(of: atSearch))
} catch {
    print("Failed to create regex")
}
/*:
However, there’s a key difference that has significant side effects for our code: when we create a regular expression from a string using `Regex`, Swift must parse the string at runtime to figure out the actual expression it should use. In comparison, using regex literals allows Swift to check your regex *at compile time*: it can validate the regex contains no errors, and also understand exactly what matches it will contain.

**This bears repeating, because it’s quite remarkable:** Swift parses your regular expressions at compile time, making sure they are valid – this is, for me at least, the coding equivalent of the head explode emoji.

To see how powerful this difference is, consider this code:
*/
let search1 = /My name is (.+?) and I'm (\d+) years old./
let greeting1 = "My name is Taylor and I'm 26 years old."

if let result = try? search1.wholeMatch(in: greeting1) {
    print("Name: \(result.1)")
    print("Age: \(result.2)")
}
/*:
That creates a regex looking for two particular values in some text, and if it finds them both prints them. But notice how the `result` tuple can reference its matches as `.1` and `.2`, because Swift knows exactly which matches will occur. (In case you were wondering, `.0` will return the whole matched string.)

In fact, we can go even further because regular expressions allow us to name our matches, and these flow through to the resulting tuple of matches:
*/
let search2 = /My name is (?<name>.+?) and I'm (?<age>\d+) years old./
let greeting2 = "My name is Taylor and I'm 26 years old."

if let result = try? search2.wholeMatch(in: greeting2) {
    print("Name: \(result.name)")
    print("Age: \(result.age)")
}
/*:
This kind of safety just wouldn’t be possible with regexes created from strings.

But Swift goes one step further: you can create regular expressions from strings, you can create them from regex literals, but you can also create them from a domain-specific language similar to SwiftUI code.

For example, if we wanted to match the same “My name is Taylor and I’m 26 years old” text, we could write a regex like this:
*/
import RegexBuilder

let search3 = Regex {
    "My name is "

    Capture {
        OneOrMore(.word)
    }

    " and I'm "

    Capture {
        OneOrMore(.digit)
    }

    " years old."
}
/*:
Even better, this DSL approach is able to apply transformations to the matches it finds, and if we use `TryCapture` rather than `Capture` then Swift will automatically consider the whole regex not to match if the capture fails or throws an error. So, in the case of our age matching we could write this to convert the age string into an integer:
*/
let search4 = Regex {
    "My name is "

    Capture {
        OneOrMore(.word)
    }

    " and I'm "

    TryCapture {
        OneOrMore(.digit)
    } transform: { match in
        Int(match)
    }

    " years old."
}
/*:
And you can even bring together named matches using variables with specific types like this:
*/
let nameRef = Reference(Substring.self)
let ageRef = Reference(Int.self)

let search5 = Regex {
    "My name is "

    Capture(as: nameRef) {
        OneOrMore(.word)
    }

    " and I'm "

    TryCapture(as: ageRef) {
        OneOrMore(.digit)
    } transform: { match in
        Int(match)
    }

    " years old."
}

if let result = greeting1.firstMatch(of: search5) {
    print("Name: \(result[nameRef])")
    print("Age: \(result[ageRef])")
}
/*:
Of the three options, I suspect the regex literals will get the most use because it’s the most natural, but helpfully Xcode has the ability to convert regex literals into the RegexBuilder syntax.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/