// Prints an encrypted message based on inputs from the user

#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(int argc, string argv[])
{
    // Checks for improper number of arguments
    if (argc != 2)
    {
        printf("Usage: ./vigenere keyword\n");
        return 1;
    }

    // Checks for non-alphabetical characters
    for (int i = 0; i < strlen(argv[1]); i++)
    {
        if (!isalpha(argv[1][i]))
        {
            printf("Usage: ./vigenere keyword\n");
            return 1;
        }
    }

    // Key given in the command-line
    string k = argv[1];

    // Message to be encrypted
    string plaintext = get_string("plaintext: ");

    // Encrypted message to be output
    char ciphertext[strlen(plaintext) + 1];
    ciphertext[strlen(plaintext)] = '\0';

    // Count stores the character of the key to be used
    int count = 0;

    // Loops through the message, encrypts each character, and adds it to the ciphertext array
    for (int i = 0; i < strlen(plaintext); i++)
    {
        int charvalue;
        if (isupper(k[count]))
        {
            charvalue = k[count] - 65;
        }
        else
        {
            charvalue = k[count] - 97;
        }
        if (isupper(plaintext[i]))
        {
            ciphertext[i] = (plaintext[i] - 65 + charvalue) % 26 + 65;
        }
        else if (islower(plaintext[i]))
        {
            ciphertext[i] = (plaintext[i] - 97 + charvalue) % 26 + 97;
        }
        else
        {
            ciphertext[i] = plaintext[i];
        }
        count++;
        if (count >= strlen(k))
        {
            count = 0;
        }
    }

    printf("ciphertext: %s\n", ciphertext);
}