#### Creating a new release

```
# Make changes appropriate for a specific version of Node, in the Dockerfile.
> git commit -m "4.3.2" Dockerfile
> git tag -a 4.3.2 -m "4.3.2"
> git tag -d 4.3 && git push origin :refs/tags/4.3 && git tag -a 4.3 -m "4.3"
> git push origin --tags
```

#### Removing a broken release

```
> git tag -d 4.3.0
> git push origin :refs/tags/4.3.0
```
