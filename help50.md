# Helping `help50`

## Questions

1. Float division doesn't result in remainders, so you can't use floats with the modulo operator (%). Try changing 'n' to an int.

2. Calling 'get_string' without parentheses returns the memory address of the function, which can't be assigned to a string.
    Make sure that 'input' is assigned the value of a string. Try adding parentheses to 'get_string'.

3. A 'char' such as 'buffer[0]' takes up one byte of memory while a number in hexadecimal, such as '0xff' takes up two bytes of memory.
    Therefore the two can never be equivalent. Try comparing 'buffer[0]' to another char.

4. 'node *root' is a scalar initializer that requires a pointer, so you can't pass it multiple parameters. Try changing 'root' to
    an array or passing just one parameter.

## Debrief

1. https://stackoverflow.com/questions/13881693/call-function-without-parameter-and-parenthesis

2. 1 hour
