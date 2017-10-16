# #functions

## Questions

1. Hash functions should make use of all the information they are given. This hash function splits all words based on just their first letter,
    so there is a high likelihood of collisions, which increase the time it takes to search for an element, due to the small number of slots.

2. This hash function is "perfect" by definition because every string passed has a completely different hash value, so it will be very easy to
    search for a specific word as there will be no collisions. However, a hash table with this function could potentially have an infinite
    number of slots, which would make it impossible to store in an array. If you used a linked list instead, you would need an enormous
    amount of memory which would make it very impractical.

3. A JPEG has more data than its hashvalue. This means that storing a JPEG takes up more memory than storing its hashvalue and it would
    take longer to compare two JPEGs than two hashvalues because there are more bytes to compare. By comparing hashvalues, check50 saves
    both time and memory.

4. In the worst case scenario for a hash table, every word passed into the table has the same hash value and the word we are looking for
    is at the end of the linked list for that value. In this case, it will take n comparisons to find the word because we have to iterate
    through n other nodes of the linked list. Therefore, worst case is O(n), because the number of comparisons can theoretically increase
    at the same rate as n. In a trie, it doesn't matter how many words have been added because the search time only depends on the number
    of letters in the word, so we say that it has O(1) because runtime is unaffected by n, the number of words.

## Debrief

1. CS50 shorts

2. 1 hour
