#### Creating a new release

```
> git tag 4.3.0
> git tag 4.3
> git push origin --tags
```

#### Removing a broken release

```
> git tag -d 4.3.0
> git push origin :refs/tags/4.3.0
```
