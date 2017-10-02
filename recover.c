// Recover JPEGS from a raw image file

// I used these sites when writing this program
// https://www.tutorialspoint.com/c_standard_library/c_function_fwrite.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fseek.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fopen.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fread.htm

#include <stdio.h>
#include <stdlib.h>
#include <cs50.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    // Define a data type the size of one byte
    // https://discourse.cs50.net/t/buffer-recover/2022
    typedef uint8_t BYTE;

    // ensure proper usage
    if (argc != 2)
    {
        fprintf(stderr, "Usage: ./recover raw_file\n");
        return 1;
    }

    // Opens the given image file and checks that it is not null
    FILE *raw_file = fopen(argv[1], "r");
    if (raw_file == NULL)
    {
        fprintf(stderr, "Could not open %s.\n", argv[1]);
        return 2;
    }

    // size returned by fread()
    int size = 0;
    // Stores number of jpegs found
    int count = 0;
    // if the first jpeg has been found this equals 1, else 0
    int jpeg_found = 0;
    // Stores 512 byte-sized inputs as read by fread() from the image file
    BYTE buffer[512];
    // the jpeg info goes into this file
    FILE *img = NULL;
    // stores the number of times the program has read blocks of 512 bytes from the file
    int counter = 0;

    // Read in the first block of 512 bytes
    size = fread(buffer, 1, 512, raw_file);
    do
    {
        counter++;
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff && (buffer[3] & 0xf0) == 0xe0)
        {
            // Close the previous jpeg file
            if (jpeg_found == 1)
            {
                fclose(img);
            }

            // Stores the name of the jpeg file
            char filename[8];
            filename[7] = '\0';
            sprintf(filename, "%03i.jpg", count);

            // create a new jpeg file
            img = fopen(filename, "w");

            // a jpeg has now been found
            jpeg_found = 1;

            // increment number of jpegs found
            count++;
        }

        // write the read info to a jpeg file, only if we have found the start of at least the first jpeg
        if (jpeg_found == 1)
        {
            fwrite(buffer, 512, 1, img);
        }
        // Read in the next block of 512 bytes
        size = fread(buffer, 1, 512, raw_file);
    }
    while (size == 512);
    // execute this loop until fread() returns a size smaller than 512, meaning we have reached the end of the file

    // Close the raw image file
    fclose(raw_file);

    // Close the last jpeg file
    fclose(img);

    return 0;
}