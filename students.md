# Comparing Students

## Questions

1.1. int (*comp)(const void *, const void *) represents the function definition of the function that will compare the two given values
        (the two "const void *"'s)

1.2. The comparison function in the example decides which value a or b comes first by using "<" and ">", which only work with integer
        values, so a and b must be typecast from "const void *" to "const int *" so that when the pointers are assigned to arg1 and arg2,
        arg1 and arg2 will be assigned the integer values that a and b point to. Otherwise, ">" and "<" won't work.s

1.3. See `students.c`.

1.4. See `students.py`.

1.5. See `students.js`.

## Debrief

a. Links from the problem description, CS50 reference,
    https://stackoverflow.com/questions/28396382/casting-a-const-void-to-a-const-char-in-c
    https://www.programiz.com/c-programming/c-user-defined-functions

b. 60 minutes
