import sys
import crypt

# Helpful sites I used:
# https://stackoverflow.com/questions/663171/is-there-a-way-to-substring-a-string-in-python
# https://docs.python.org/3.6/library/crypt.html

def main():
    # Get a hashed password from the user
    if len(sys.argv) != 2:
        print("Usage: ./crack hash")
        return 1
    print(getPW(sys.argv[1]))
    return 0

# Returns the password matching the hash or tells the user the password doesn't exist
def getPW(pw):
    # ASCII value one greater than capital Z
    gt_upperZ = ord('Z') + 1
    # ASCII value of 'a'
    lowera = ord('a')
    # ASCII value of 'A'
    upperA = ord('A')
    # ASCII value of 'z'
    lowerz = ord('z')

    salt = pw[:2]
    guess = ""

    # Loop through all possibilities of the first character of the password
    for i in range(upperA, lowerz):
        if i == gt_upperZ:
            i = lowera
        guess = chr(i)
        if checkGuess(guess, salt):
            return guess

        # Loop through all possibilities of the second character of the password
        for j in range(upperA, lowerz):
            if j == gt_upperZ:
                j = lowera
            guess = chr(i) + chr(j)
            if checkGuess(guess, salt):
                return guess

            # Loop through all possibilities of the third character of the password
            for k in range(upperA, lowerz):
                if k == gt_upperZ:
                    k = lowera
                guess = chr(i) + chr(j) + chr(k)
                if checkGuess(guess, salt):
                    return guess

                # Loop through all possibilities of the fourth character of the password
                for l in range(upperA, lowerz):
                    if l == gt_upperZ:
                        l = lowera
                    guess = chr(i) + chr(j) + chr(k) + chr(l)
                    if checkGuess(guess, salt):
                        return guess

                    # Loop through all possibilities of the fifth character of the password
                    for m in range(upperA, lowerz):
                        if m == gt_upperZ:
                            m = lowera
                        guess = chr(i) + chr(j) + chr(k) + chr(l) + chr(m)
                        if checkGuess(guess, salt):
                            return guess

    return "No valid password found"

# Returns true if the hash of the guess matches the hashed password
def checkGuess(guess, salt):
    return crypt.crypt(guess, salt) == sys.argv[1]


if __name__ == "__main__":
    main()
