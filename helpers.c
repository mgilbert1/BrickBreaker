// Helper functions for music

#include <cs50.h>
#include <math.h>
#include <string.h>
#include <stdio.h>

#include "helpers.h"

// Converts a fraction formatted as X/Y to eighths
int duration(string fraction)
{
    int numerator = atoi(&fraction[0]);
    int denominator = atoi(&fraction[2]);

    // Multiply the numerator and denominator by two until the fraction is in eighths
    while (denominator != 8)
    {
        denominator *= 2;
        numerator *= 2;
    }

    return numerator;
}

// Calculates frequency (in Hz) of a note
int frequency(string note)
{
    int compareToOctave = 4;
    int semitonesPerOctave = 12;

    // Difference in semitones between A and the other letters in an octave
    //                       A  B   G   F   E   D   C
    int differenceFromA[] = {0, 2, -9, -7, -5, -4, -2};

    // Information about the given note
    char letter = note[0];
    char accidental;
    int octave;

    // Number of semitones from A4 to the given note
    int n = 0;

    // If there is no accidental
    if (strlen(note) == 2)
    {
        accidental = '0';
        octave = atoi(&note[1]);
    }
    // If there is an accidental
    else
    {
        accidental = note[1];
        octave = atoi(&note[2]);
    }

    // Determine the number of semitones between the given note and A4
    n += differenceFromA[letter - 'A'];
    n += semitonesPerOctave * (octave - compareToOctave);

    if (accidental == '#')
    {
        n++;
    }
    else if (accidental == 'b')
    {
        n--;
    }

    // Calculate and return the frequency of the given note
    return lroundf(powf(2, n / 12.) * 440);
}

// Determines whether a string represents a rest
bool is_rest(string s)
{
    return strcmp(s, "") == 0;
}
