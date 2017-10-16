# Z++

## Questions

1.

```
function subtract($x, $y)
{
    return(add($x, -$y));
}
```

2.

```
function multiply($x, $y)
{
    $product = 0;
    while(x)
    {
        $product <- add($product, $y);
    }
    return($product);
}
```

3.

```
function multiply($x, $y)
{
    if($x < 2)
    {
        return($y);
    }
    return(add($y, multiply(subtract($x, 1), $y)));
}
```

## Debrief

1. None

2. 15 minutes
