// Resizes a given BMP file
// This is resize: more comfortable

// I used these sites when writing this program
// https://www.tutorialspoint.com/c_standard_library/c_function_fwrite.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fseek.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fopen.htm
// https://www.tutorialspoint.com/c_standard_library/c_function_fread.htm

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <cs50.h>

#include "bmp.h"

int main(int argc, char *argv[])
{
    // ensure proper usage
    if (argc != 4)
    {
        fprintf(stderr, "Usage: ./resize float infile outfile\n");
        return 1;
    }

    // amount to resize the image by
    float resizeBy = atof(argv[1]);

    // Check that the given resize value is valid
    if (resizeBy <= 0.0 || resizeBy > 100.0)
    {
        fprintf(stderr, "Usage: ./resize float infile outfile\n");
        return 1;
    }

    // stores the parts of the given float that are before and after the decimal separately
    int intResizeBy = (int) roundf(floorf(resizeBy));
    float fractionResizeBy = resizeBy - intResizeBy;

    // remember filenames
    char *infile = argv[2];
    char *outfile = argv[3];

    // open input file
    FILE *inptr = fopen(infile, "r");
    if (inptr == NULL)
    {
        fprintf(stderr, "Could not open %s.\n", infile);
        return 2;
    }

    // open output file
    FILE *outptr = fopen(outfile, "w");
    if (outptr == NULL)
    {
        fclose(inptr);
        fprintf(stderr, "Could not create %s.\n", outfile);
        return 3;
    }

    // read infile's BITMAPFILEHEADER
    BITMAPFILEHEADER bf;
    fread(&bf, sizeof(BITMAPFILEHEADER), 1, inptr);

    // read infile's BITMAPINFOHEADER
    BITMAPINFOHEADER bi;
    fread(&bi, sizeof(BITMAPINFOHEADER), 1, inptr);

    // ensure infile is (likely) a 24-bit uncompressed BMP 4.0
    if (bf.bfType != 0x4d42 || bf.bfOffBits != 54 || bi.biSize != 40 ||
        bi.biBitCount != 24 || bi.biCompression != 0)
    {
        fclose(outptr);
        fclose(inptr);
        fprintf(stderr, "Unsupported file format.\n");
        return 4;
    }

    // determine padding for scanlines
    int padding = (4 - (bi.biWidth * sizeof(RGBTRIPLE)) % 4) % 4;

    // Values for the resized image:
    // number of pixels per row
    int rowSize = 0;
    // size of each column (aka number of rows)
    int colSize = 0;
    // number of bytes per row
    int rowBytes = 0;

    // Another column is added every time 'col_fractionCounter', which is incremented by the decimal portion of the resize value,
    // surpasses a whole number, which is stored in 'col_intCounter'
    int col_intCounter = 1;
    float col_fractionCounter = fractionResizeBy;

// These will be overwritten with updated information later but it ensures that the actual image starts after the correct number of bytes
    // write outfile's BITMAPFILEHEADER
    fwrite(&bf, sizeof(BITMAPFILEHEADER), 1, outptr);

    // write outfile's BITMAPINFOHEADER
    fwrite(&bi, sizeof(BITMAPINFOHEADER), 1, outptr);

    // Set the cursor to the start of the correct row
    // the width must be a multiple of four, this accounts for padding
    int width = 3 * bi.biWidth;
    while (width % 4 != 0)
    {
        width++;
    }

    // iterate over infile's scanlines
    for (int i = 0, biHeight = abs(bi.biHeight); i < biHeight; i++)
    {
        // If this is a row that will be repeated an extra time due to the incrementation of 'col_fractionCounter', 'l' starts at -1 instead of 0
        int l = 0;
        if (col_intCounter - col_fractionCounter <= 0.0)
        {
            l--;
            col_intCounter++;
        }
        // increment 'col_fractionCounter'
        col_fractionCounter += fractionResizeBy;

        // adds 'l' of a specific row to resize the columns
        for (; l < intResizeBy; l++)
        {
            fseek(inptr, i * width + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER), SEEK_SET);

            // repeats the previous pixel every time 'row_fractionCounter' surpasses the integer stored in 'row_intCounter',
            // the same way it works for the columns
            int row_intCounter = 1;
            float row_fractionCounter = fractionResizeBy;

            // number of bytes in this row
            int numBytes = 0;

            // number of pixels in this row
            rowSize = 0;

            // Another row is being added, so increment the size of the columns
            colSize++;

            // iterate over pixels in scanline
            for (int j = 0; j < bi.biWidth; j++)
            {
                // temporary storage
                RGBTRIPLE triple;

                // read RGB triple from infile
                fread(&triple, sizeof(RGBTRIPLE), 1, inptr);

                // Repeat each pixel as many times as specified by the integer part of the resize value
                for (int k = 0; k < intResizeBy; k++)
                {
                    // write RGB triple to outfile
                    fwrite(&triple, sizeof(RGBTRIPLE), 1, outptr);

                    // one pixel is three bytes
                    numBytes += 3;

                    // increment the number of pixels in this row
                    rowSize++;
                }

                // add another pixel based on the incrementation of the fraction part of the resize value
                if (row_intCounter - row_fractionCounter <= 0.0)
                {
                    // write RGB triple to outfile
                    fwrite(&triple, sizeof(RGBTRIPLE), 1, outptr);
                    numBytes += 3;
                    rowSize++;
                    row_intCounter++;
                }
                row_fractionCounter += fractionResizeBy;

            }

            // skip over padding, if any
            fseek(inptr, padding, SEEK_CUR);

            // add padding so that the number of bytes on the line is a multiple of four
            while (numBytes % 4 != 0)
            {
                fputc(0x00, outptr);
                numBytes++;
            }

            // store the number of bytes in each row
            rowBytes = numBytes;
        }
    }

    // reset the cursor for both files
    fseek(outptr, 0, SEEK_SET);
    fseek(inptr, 0, SEEK_SET);

    // read infile's BITMAPFILEHEADER
    BITMAPFILEHEADER resized_bf;
    fread(&resized_bf, sizeof(BITMAPFILEHEADER), 1, inptr);

    // set the bfSize for the new image
    resized_bf.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + colSize * rowBytes;

    // write outfile's BITMAPFILEHEADER
    fwrite(&resized_bf, sizeof(BITMAPFILEHEADER), 1, outptr);
    //fwrite(&bf, sizeof(BITMAPFILEHEADER), 1, outptr);

    // read infile's BITMAPINFOHEADER
    BITMAPINFOHEADER resized_bi;
    fread(&resized_bi, sizeof(BITMAPINFOHEADER), 1, inptr);

    // set the values for the new image's BITMAPINFOHEADER
    resized_bi.biSizeImage = colSize * rowBytes;
    resized_bi.biWidth = rowSize;
    resized_bi.biHeight = colSize * bi.biHeight / abs(bi.biHeight);

    // write outfile's BITMAPINFOHEADER
    fwrite(&resized_bi, sizeof(BITMAPINFOHEADER), 1, outptr);

    // close infile
    fclose(inptr);

    // close outfile
    fclose(outptr);

    // success
    return 0;
}
