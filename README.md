# odin-connect-four
toy command line connect four game implemented using TDD and ruby

### about
---
* [Wiki](https://en.wikipedia.org/wiki/Connect_Four)
* two player connection board game
* take turns dropping token into a
* seven columns, six rows vertical grid
* pieces fall straight down
* objective is to be first to form a horizontal, vertical, or diaganol line of four of one's own tokens

### to do 
---
* Implement recursive or non-recursive diaganol solution
* Use special unicode pieces
* Color the pieces
* How will the player interact with the game?
  * choose your own avatar?
  * specify your name?
  * game loop?
* Implement Player methods
* Implement Game methods
* Finish tests

### design decisions
---
* There probably is a nice recursive solution that is faster, but I just considerd diaganol, horizontal, and vertical win conditions seperately; looping over all possibles lines, and keeping track of the counts to 4
* I borrowed some code from tic tac toe, but one game mechanics difference is specifying moves by location versus by column for connect4. Subsequently, a 1D to 2D mapping for related tiled numbers for displays to coordinates was not necessary. 
* One nice trick for inserting pieces I realized is to insert into the first empty slot using somethign like a reverse_each_with_index.  