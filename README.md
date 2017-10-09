# Questions

## What is pneumonoultramicroscopicsilicovolcanoconiosis?

A lung disease caused by breathing in too much dust

## According to its man page, what does `getrusage` do?

It returns usage statistics for a given process, such as time and memory used

## Per that same man page, how many members are in a variable of type `struct rusage`?

16

## Why do you think we pass `before` and `after` by reference (instead of by value) to `calculate`, even though we're not changing their contents?

The program would fail if one or both were NULL otherwise.

## Explain as precisely as possible, in a paragraph or more, how `main` goes about reading words from a file. In other words, convince us that you indeed understand how that function's `for` loop works.

    Speller's 'main' function loops through every character of the text file individually. There are now three possibilities for actions,
which depend on 'c'.
    If 'c' is a letter or an apostrophe (but, if it's an apostrophe it can't be the first character of a word), it adds 'c' to our current word.
Then it checks that theword length limit has not been exceeded. If it has, the function loops through characters of file until it reaches a
non-alphabetical character or the end of the file, and then starts a new word and ignores the old one.
    If 'c' is a number, the function loops through characters of file until it reaches a non-alphabetical and non-numerical character
or the end of the file, and then starts a new word and ignores the old one.
    If 'c' is not a letter, number, or apostrophe, the current word is a whole word. The function adds '\0' to word array to end the word.
Then, it checks if the word is in the dictionary using the function 'check' that I wrote, and calculates the time it takes for this function to run
and adds this time to the total runtime. Then it prints the word if it is misspelled, and then gets ready to start a new word.


## Why do you think we used `fgetc` to read each word's characters one at a time rather than use `fscanf` with a format string like `"%s"` to read whole words at a time? Put another way, what problems might arise by relying on `fscanf` alone?

'fcanf' separates strings based on whitespace, while we want to start new words anytime we reach a character that is not a number, letter, or apostrophe.
We would still have to read through all of the words to check for special characters and numbers.

## Why do you think we declared the parameters for `check` and `load` as `const` (which means "constant")?

We want to avoid accidentally changing the data. If we edited the words in the dictionary or the text file it would mess up the program output.
