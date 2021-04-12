#1 step or 2 steps each time
def solution1(n):
    dp = [0] * max(n,2)
    dp[0] = 1
    dp[1] = 2
    if n <= 2:
        return dp[n-1]
    for i in range(2,n):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n-1]


# 1 step, 2 steps or 3 steps each time
def solution2(n):
    dp = [0] * max(3,n)
    dp[0] = 1
    dp[1] = 2
    dp[2] = 4
    if n <= 3:
        return dp[n-1]
    for i in range(3,n):
        dp[i] = dp[i-1] + dp[i-2] + dp[i-3]
    return dp[n-1]