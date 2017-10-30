from cs50 import get_int

# Gets a card number from the user
num = get_int("Number: ")
double_sums, sums = 0, 0

# Calculate the special sum of the digits according to Luhn's algorithm
temp = num
while temp > 0:
    sums += temp % 10
    temp //= 10
    digits = temp % 10 * 2
    sum2 = digits % 10
    digits //= 10
    sum2 += digits
    double_sums += sum2
    temp //= 10

# Check if the number is valid and, if so, which company it belongs too
if (double_sums + sums) % 10 == 0:
    if (num >= 340000000000000 and num < 350000000000000) or (num >= 370000000000000 and num < 380000000000000):
        print("AMEX")
    elif num >= 5100000000000000 and num < 5600000000000000:
        print("MASTERCARD")
    elif (num >= 4000000000000 and num < 5000000000000) or (num >= 4000000000000000 and num < 5000000000000000):
        print("VISA")
    else:
        print("INVALID")
else:
    print("INVALID")
