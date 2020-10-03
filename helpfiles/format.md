### Long vs. wide format

***

- **Long format** means that one variable contains all the _dependent variable_
observations, and another variables is the (binary) _independent variable_ which
contains the group to which each observation belongs to.

```
| observation | group     |
| ----------- | --------- |
| 130         | treatment |
| 110         | control   |
| 140         | treatment |
| ...         | ...       |
```

- **Wide format** means that one variable contains the dependent variable
observations for the _first group_, and another contains the dependent variable
observations for the _second group_. In other words, each sample is in its own
variable.

```
| treatment | control   |
| --------- | --------- |
| 130       | 122       |
| 125       | 110       |
| 140       | 109       |
| ...       | ...       |
```