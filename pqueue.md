# Now Boarding

## Questions

1.

```c
typedef struct
{
    passenger p;
    struct pqueue *next;
    struct pqueue *prev;
}
pqueue;
```

2. I would have a global pointer 'head' that points to the first element of the queue
    Iterate through the queue with a pointer 'trav' until I find the first passenger with a lower priority group or I reach the end of the queue
    Dynamically allocate a new node 'newpq' with the passenger value passed to 'enqueue'
    Set the 'next' pointer of 'newpq' to trav and the 'prev' pointer of 'newpq' to the 'prev' pointer of trav
    Check if 'newpq' was placed at the start of the list; if it was, set 'head' to 'newpq'

3. This algorithm is O(n). In the worst case scenario, I have to place the new passenger at the very end of the queue, which requires
    iterating through all 'n' existing passengers.

4. Check that 'head' is not 'NULL'; that is, check that there exists and element for us to dequeue
    Create a new pointer 'temp' that points to 'head'
    Set 'head' to the second element of the list (which is 'head->next')
    Store the 'passenger' value from 'temp' in a new passenger struct 'temp_passenger'
    Free 'temp'
    Set the 'prev' pointer of 'head' to 'NULL'
    Return 'temp_passenger'

5. This algorithm is O(1). It always returns the 'passenger' field of the first element, so it doesn't matter how many elements
    are behind it in the queue. Runtime remains constant as list size increases, therefore runtime doesn't depend on 'n' at all.

## Debrief

1. CS50 Shorts

2. 2 hours
