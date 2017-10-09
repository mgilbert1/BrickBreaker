// Implements a dictionary's functionality

// I used these websites:
// https://www.tutorialspoint.com/c_standard_library/c_function_fgetc.htm
// https://www.cs.bu.edu/teaching/c/tree/trie/

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "dictionary.h"

// Number of characters in the alphabet being used
const int alphabet_size = 27;

// Definition of Trie
typedef struct trie
{
    // True if a word ends with the character specified by this trie
    bool isEnd;

    // Array of tries for a-z and '
    struct trie *paths[alphabet_size];
}
trie;

// Prototypes
int getIndex(int c);
void unload2(trie *t);
void initializeNode(trie *node);

// Root of the trie that stores the dictionary
trie *root = NULL;

// Number of words in the dictionary
int word_count;

// Returns true if word is in dictionary else false
// Loops through the trie all characters in word and returns true if the isEnd is true in the trie for the last character
bool check(const char *word)
{
    trie *trav = root;
    for (int i = 0; i < strlen(word); i++)
    {
        if (trav->paths[getIndex(tolower(word[i]))] == NULL)
        {
            return false;
        }
        trav = trav->paths[getIndex(tolower(word[i]))];
    }
    return (trav->isEnd);
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Open dictionary file, check that it exists
    FILE *dict = fopen(dictionary, "r");
    if (dict == NULL)
    {
        printf("Could not open %s.\n", dictionary);
        unload();
        return 1;
    }

    // Initialize the root node of the trie
    root = malloc(sizeof(trie));
    if (!root)
    {
        return false;
    }
    initializeNode(root);

    // Loops through all the characters of the dictionary file
    word_count = 0;
    trie *trav = root;
    for (int c = fgetc(dict); c != EOF; c = fgetc(dict))
    {
        // Continue with the same word
        if (c != 10)
        {
            int index = getIndex(c);

            // If the trie for character 'c' doesn't exist, create it
            if (trav->paths[index] == NULL)
            {
                trie *node = malloc(sizeof(trie));
                if (!node)
                {
                    return false;
                }
                initializeNode(node);

                trav->paths[index] = node;
            }

            // Set trav to the node of the next character in this word
            trav = trav->paths[index];
        }
        // Create a new word
        else
        {
            trav->isEnd = true;
            trav = root;
            word_count++;
        }
    }

    // Close dictionary file
    fclose(dict);

    return true;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    return word_count;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    unload2(root);
    return true;
}

// Traverse the trie and free all memory
void unload2(trie *t)
{
    for (int i = 0; i < alphabet_size; i++)
    {
        if (t->paths[i] != NULL)
        {
            unload2(t->paths[i]);
        }
    }
    free(t);
}

// Returns the index of the 'paths' array in each trie node that character 'c' corresponds to
int getIndex(int c)
{
    if (c == 39)
    {
        return 26;
    }
    return c - 97;
}

// Initialize the variables in the trie node
void initializeNode(trie *node)
{
    for (int i = 0; i < alphabet_size; i++)
    {
        node->paths[i] = NULL;
    }
    node->isEnd = false;
}