# Stack Smashing

## Questions

1. A 'stack canary' is a value that is written just before a return value. Stack buffer overflow occurs when input exceeds the
    allotted space. The goal of stack smashing is to enter an input so large that it overwrites a return address with an address
    chosen by the attacker. However, if the return address was changed, the 'stack canary' must also have been changed because
    it comes before the address. Therefore, we can check the 'canary' before we access the return address: if it is the same as before,
    no buffer overflow has occurred; if it is different, it is possible that the return address has been overwritten and we know not to
    access it.

2. A 'stack canary' is named after the 'canary in a coal mine'. Miners would bring a canary with them to check for poisonous gases.
    If the canary died, the miners would know that there was poisonous gas in the air and that they should leave for their own safety.
    The 'stack canary' is similar; if something bad happens to it, you know that there is some danger that you have to watch out for.

3.
#include <string.h>
#include <stdlib.h>

void excited(int n)
{
    char he_said[100];
    memset(he_said, 'O', n);
    he_said[0] = 'W';
    // WOOOOOOOOOOOOOOOOOO
}


int main(int argc, char *argv[])
{
    if(argc == 2)
    {
        excited(atoi(argv[1]));
    }
}

## Debrief

1. https://www.youtube.com/watch?v=uSC3guWOvpk, CS50 Lecture Notes, Wikipedia

2. 30 minutes
