// Decrypts a given hash

#include <cs50.h>
#include <stdio.h>
#include <string.h>
// Checked this site before I read the "Hints" section of crack, so I used crypt.h instead of unistd.h
// https://cs50.stackexchange.com/questions/23583/cs-des-based-crypt-function
#include <crypt.h>

// Prototypes
bool checkGuess(char key[], string salt, string password);
string getPW(string arg, char[6]);

int main(int argc, string argv[])
{
    // Check for valid input
    if (argc != 2)
    {
        printf("Usage: ./crack hash\n");
        return 1;
    }

    char c[6];
    string answer = getPW(argv[1], c);

    printf("%s\n", answer);
    return 0;
}

// Returns the plaintext password
string getPW(string arg, char password[6])
{
    string salt = arg;
    string hash = arg;
    strncpy(salt, hash, 2);
    password[5] = '\0';

    // Loop through all possible combinations of five-letter passwords
    // Check if each one matches the hash when encrypted, and if so return it
    for (int i = 65; i <= 122; i++)
    {
        if (i == 91)
        {
            i = 97;
        }
        // Set the next letter of the password guess to the ASCII character that corresponds to the value of i
        password[0] = i;

        for (int j = 65; j <= 122; j++)
        {

            if (j == 91)
            {
                j = 97;
            }
            password[1] = j;

            for (int k = 65; k <= 122; k++)
            {
                if (k == 91)
                {
                    k = 97;
                }
                password[2] = k;

                for (int l = 65; l <= 122; l++)
                {
                    if (l == 91)
                    {
                        l = 97;
                    }
                    password[3] = l;

                    for (int m = 65; m <= 122; m++)
                    {
                        if (m == 91)
                        {
                            m = 97;
                        }
                        password[4] = m;

                        // Checks all five-letter combinations
                        if (checkGuess(password, salt, arg))
                        {
                            return password;
                        }
                    }

                    // Checks all four-letter combination
                    password[4] = '\0';
                    if (checkGuess(password, salt, arg))
                    {
                        return password;
                    }
                }

                // Checks all three-letter combination
                password[3] = '\0';
                if (checkGuess(password, salt, arg))
                {
                    return password;
                }
            }

            // Checks all two-letter combination
            password[2] = '\0';
            if (checkGuess(password, salt, arg))
            {
                return password;
            }
        }

        // Checks all onec-letter combination
        password[1] = '\0';
        if (checkGuess(password, salt, arg))
        {
            return password;
        }
    }
    return "No valid password found";
}

// Returns true if the hash matches the encrypted key and salt
bool checkGuess(char key[], string salt, string hash)
{
    return (strcmp(crypt(key, salt), hash) == 0);
}