# Emoji

## Questions

1. Three bytes are necessary to represent the jack-o-lantern.

2. The jack-o-lantern can't be represented by a char because a char only stores one byte and the jack-o-lantern has a size of three bytes

3.

```c
emoji get_emoji(string prompt)
{
    while(true)
    {
        string input = get_string("%s", prompt);
        if(input[0] != 'U' || input[1] != '+')
        {
            continue;
        }
        input[0] = '0';
        input[1] = 'x';
        char **endptr = malloc(sizeof(char**));
        int num = strtol(input, endptr, 16);
        if (endptr[0][0] != '\0')
        {
            free(endptr);
            continue;
        }
        emoji e = num;
        free(endptr);
        return e;
    }
}
```

## Debrief

1. CS50 Reference

2. 1.5 hours
