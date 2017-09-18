// Prints an encrypted message using Caesar's cipher

#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(int argc, string argv[])
{
    // Checks if there is an improper number of arguments
    if (argc != 2)
    {
        printf("Usage: ./caesar integer\n");
        return 1;
    }

    // Key given in the command-line
    int k = atoi(argv[1]);

    // Message to be encrypted
    string plaintext = get_string("plaintext: ");

    // Encrypted message to be output
    char ciphertext[strlen(plaintext)];

    // Loops through the message, encrypts each character, and adds it to the ciphertext array
    for (int i = 0; i < strlen(plaintext); i++)
    {
        if (isupper(plaintext[i]))
        {
            ciphertext[i] = (plaintext[i] - 65 + k) % 26 + 65;
        }
        else if (islower(plaintext[i]))
        {
            ciphertext[i] = (plaintext[i] - 97 + k) % 26 + 97;
        }
        else
        {
            ciphertext[i] = plaintext[i];
        }
    }

    printf("ciphertext: %s\n", ciphertext);
}