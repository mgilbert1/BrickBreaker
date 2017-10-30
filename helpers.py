from enum import Enum

# Helpful sites I used:
# http://jinja.pocoo.org/docs/2.9/templates/#synopsis
# https://stackoverflow.com/questions/39523485/jinja2-itterate-through-list-of-tuples
# https://www.w3schools.com/bootstrap/default.asp
# https://stackoverflow.com/questions/8220702/error-int-object-is-not-subscriptable
# https://stackoverflow.com/questions/5122041/extracting-the-a-value-from-a-tuple-when-the-other-values-are-unused
# https://stackoverflow.com/questions/6667201/how-to-define-two-dimensional-array-in-python
# https://docs.python.org/3/library/functions.html
# https://stackoverflow.com/questions/23986337/converting-character-to-int-and-vice-versa-in-python


class Operation(Enum):
    """Operations"""

    DELETED = 1
    INSERTED = 2
    SUBSTITUTED = 3

    def __str__(self):
        return str(self.name.lower())


def distances(a, b):
    """Calculate edit distance from a to b"""

    lenA = len(a)
    lenB = len(b)

    # Sets up the score matrix
    matrix = [[0] * (lenB + 1) for i in range(lenA + 1)]
    matrix[0][0] = (0, None)

    # Set the values for the first row and column of the matrix
    for i in range(lenA):
        matrix[i + 1][0] = (matrix[i][0][0] + 1, Operation.DELETED)
    for i in range(lenB):
        matrix[0][i + 1] = (matrix[0][i][0] + 1, Operation.INSERTED)

    for i in range(lenA):
        for j in range(lenB):
            # Row and Column of the matrix tuple I want to set
            row = i + 1
            col = j + 1

            # Selects the minimum of the three choices and adds the lowest score and the transformation to the score matrix
            delete = matrix[row - 1][col][0] + 1
            subs = matrix[row - 1][col - 1][0] + 1
            insert = matrix[row][col - 1][0] + 1
            if a[i] == b[j]:
                subs -= 1
            lowest = min(delete, subs, insert)
            if(delete == lowest):
                matrix[row][col] = (lowest, Operation.DELETED)
            elif(insert == lowest):
                matrix[row][col] = (lowest, Operation.INSERTED)
            else:
                matrix[row][col] = (lowest, Operation.SUBSTITUTED)
    return matrix
