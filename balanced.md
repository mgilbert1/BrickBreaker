# Fair and Balanced

## Questions

1. Yes

2. Yes

3.

```c
bool balanced(int *nums, int n)
{
    int sum_diff = 0;
    for(int i = 0; i < n / 2; i++)
    {
        sum_diff += nums[i] - nums[n - 1 - i];
    }
    return (sum_diff == 0);
}
```

## Debrief

1. CS50 Lecture Notes

2. 30 minutes
