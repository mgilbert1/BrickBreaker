#include <stdio.h>
#include <cs50.h>

int main(void)
{
    // Prompt for the height until a valid height is given
    int in = -1;
    while (in > 23 || in < 0)
    {
        in = get_int("Height: ");
    }

    for (int i = 0; i < in; i++)
    {
        // Print spaces
        for (int j = i; j < in - 1; j++)
        {
            printf(" ");
        }
        // Print the first half of the pyramid
        for (int j = 0; j <= i; j++)
        {
            printf("#");
        }
        printf("  ");
        // Print the second half of the pyramid
        for (int j = 0; j <= i; j++)
        {
            printf("#");
        }
        printf("\n");
    }
}