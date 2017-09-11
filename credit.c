// Check the validity of a credit card number given by the user

#include <stdio.h>
#include <cs50.h>

int main(void)
{
    // Get a card number input
    long long num = -1;
    num = get_long_long("Number: ");

    // Sums of the digits of every other digit from the second-to-last after being doubled
    int double_sums = 0;
    // Sums of the digits of every other number from the last one
    int sums = 0;

    // Loop through the number and get all of the sums of digits
    // Use temp to preserve num for later
    long long temp = num;
    while (temp > 0)
    {
        sums += temp % 10;
        temp /= 10;
        int digits = temp % 10 * 2;
        int sum2 = digits % 10;
        digits /= 10;
        sum2 += digits;
        double_sums += sum2;
        temp /= 10;
    }

    // Check if the number is valid and, if so, which company it belongs too
    if ((double_sums + sums) % 10 == 0)
    {
        if ((num >= 340000000000000 && num < 350000000000000) || (num >= 370000000000000
                && num < 380000000000000))
        {
            printf("AMEX\n");
        }
        else if (num >= 5100000000000000 && num < 5600000000000000)
        {
            printf("MASTERCARD\n");
        }
        else if ((num >= 4000000000000 && num < 5000000000000) || (num >= 4000000000000000
                 && num < 5000000000000000))
        {
            printf("VISA\n");
        }
        else
        {
            printf("INVALID\n");
        }
    }
    // If the number is not valid, print INVALID
    else
    {
        printf("INVALID\n");
    }

    return 0;
}