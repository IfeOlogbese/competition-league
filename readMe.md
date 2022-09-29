# Competition League

### How to run the application
---

In the terminal, run `ruby lib/game_points.rb` to begin

Insert the below `multiline string`
```
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
```

It should product the following output

```
========= OUTPUT ==========
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
4. Snakes, 1 pt
5. Grouches, 0 pts
```

### How to run the tests
---
- `cd competition-league && bundle install`
- run `rspec spec`

All tests should pass