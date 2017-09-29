## Puppet CLI tips/tricks/tools

### erb tester
If you want to test an erb without waiting on puppet runs
```bash
erbtest.rb templatename=blah.erb [var1=val1 var2=val2 ...]
```

