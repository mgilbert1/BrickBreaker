from cs50 import get_int

# Gets a height from the user and check that it's valid
height = get_int("Height: ")
while height < 0 or height > 23:
    height = get_int("Height: ")

# Prints the pyramid
for i in range(height):
    for j in range(height - i - 1):
        print(end=" ")
    for j in range(i + 1):
        print(end="#")
    print(end="  ")
    for j in range(i + 1):
        print(end="#")
    print()
