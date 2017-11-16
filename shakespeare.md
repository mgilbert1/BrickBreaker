# To be or not to be

## ~~That is the question~~ These are the questions

4.1. 1000 strings

4.2. Every time a character in the string matches the corresponding character in the target, score is incremented by 1. Fitness is
        this score divided (as a float to preserve decimal places) by the length of the target string. Fitness is 0 if no characters
        match, 1 if all of them do, otherwise the fitness is in between 0 and 1.

4.3. The fitness of KoMQ%25"zHnGt1whXY would be 1/18, or 0.05555556

4.4. The worst case edit distance would be the length of the target if every character in the string had to be changed, and best case
        would be 0 if the strings matched. Fitness could be calculated by taking the difference between the length of the target and
        the edit distance and dividing that by the length of the target, with 1 being most fit and 0 being least.

4.5. script.py mutates some of the characters in strings in case a character in the target has no match in its corresponding position
        in any of the original 1000 strings created. If mutate did not occur, this unmatched character would never be able to appear
        because it wasn't in the original strings and no new characters are introduced, so we could never achieve the target.
        (For example, if "t" were not the first character of any of the original strings, there would be no way to get a matching "t"
        in any future generations without mutations)

## Debrief

a. https://medium.com/generative-design/evolving-design-b0941a17b759

b. 30 minutes
