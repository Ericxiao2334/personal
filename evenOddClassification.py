numbers = [12, 37, 5, 42, 8,3]
even = []
odd = []
while len(numbers) > 0:
    number = numbers.pop()
    if number%2 == 0:
        even.append(number)
    else:
        odd.append(number)
