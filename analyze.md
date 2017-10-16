# Analyze This

## Questions

1a. Yes

1b. The upper bound is O(n). No matter how many cards Stelios has to organize, he sorts the whole stack twice, which is 2n operations,
    where n is the number of cards. We ignore the coefficent to get O(n).

2a. Yes

2b. The upper bound is O(n^2). Where n is the number of elements, in our first run of the sort we make (n-1) comparisons to bubble the
    largest value to the top, then (n-2) comparisons to bubble the smallest element to the bottom. This continues such that we make
    (n-1) + (n-2) + (n-3) + ... + 1 comparisons, which is equivalent to (n^2 - n)/2. We look at the term with the largest order of magnitude
    and ignore its coefficient to get O(n^2).

3a. Yes

3b. The upper bound is O(n). If the queen is never the top card until it is the only card left in the deck or the queen is not in the
    deck, Natalie will have to check the top card n times, where n is the number of cards in the deck. This gives O(n).

## Debrief

1. CS50 Lecture Notes

2. 30 minutes
