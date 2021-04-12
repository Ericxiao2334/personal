# 老王有1020个西瓜，老王第一天卖一半多两个，
# 以后每天卖剩下的一半多两个，
# 问老王几天后可以把西瓜卖完;
def solution(n):
    num = n
    day = 0
    while (num >= 0):
        num = num/2 - 2
        day += 1
    print(f'will use {day} days to sold out.')

solution(1020)