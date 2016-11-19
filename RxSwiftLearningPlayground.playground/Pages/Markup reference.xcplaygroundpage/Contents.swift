//: Playground - noun: a place where people can play

// Simple line markup //:
//: Markup Format

// Heading # or ## or ###
//: # Heading 1
//: ## Heading2
//: ### Heading3

// A bulleted list *
/*: 
 * Item 1
 * Item 2
 */

// A numbered list 1.
/*:
 1. Cat
 2. Dog
 1. Golden Retriever
 3. Llama
 */

// Note >
/*:
 > A great text.
 */

// Code Block. Start each line of a code block with at least 4 spaces.
/*:
 while true {
 println("hoge")
 }
 */

// Emphasis. *emphasis* or _emphasis_
//: This line has a word with *emphasis*.
//: _A emphasised line_

// Strong. **strong** or __strong__
//: A **strong * (asterisk)** is on this line.
//: __A strong line__


// Code. `let`
//: Show Swift elements such as `for` and `let` as monspaced code font

// Image. ![<alt text>](<URL> "<image title for hover>")
// ![](.png)
//: ![Icon for a playground](http://devimages.apple.com.edgekey.net/swift/images/playgrounds.png "An image I seesawed")
// A link to a playground resource with no hover text.
//: ![A picture beyond words!](Resources/my-great-image.jpg)

// Link. [<text to display>](<http URL>)
/*: Include a link to the Swift page in the text
 See more about Markup Format by [following this link.](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Reference/Playground_Ref/MarkupReference.html#//apple_ref/doc/uid/TP40014789-CH3-SW14)
 */


// Horizontal Rule. 4 more -
/*: A block of markup code showing a single horizontal line
 ----
 */

// Backslash Escape. \(special character)
//: Show the *middle asterisk\* with emphasis*

//: This is also a Level 1 Heading

//: ## This is a Level 2 Heading

//: ### This is a Level 3 Heading


/*:
 ## Countries
 > 1. Brazil
 > 2. Vietnam
 > 3. Colombia
 
 (the > symbol denotes a new section)
 */

/*:
 ## Points to Remember
 * Empty lines end the single line comment delimiter block
 * Comment content ends at a newline
 * Commands that work in a comment block work in single line
 * This **includes** text formatting commands
 */


/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */


/*: Setup and use a link reference.
 [The Swift Programming Language]: http://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ "Some hover text"
 
 For more information, see [The Swift Programming Language].
 */

//: show Swift keywords such as `for` and `let` as monspaced font.


//: [Next](@next)
//: [Previous](@previous)

//: [go back to first page](page1)
