# myguixpack

nodokaha の個人用 Guix チャンネル。

## channels.scm への書き方

`~/.config/guix/channels.scm` にこのチャンネルを追加する。

```scheme
(cons (channel
        (name 'myguixpack)
        (url "https://github.com/nodokaha/myguixpack")
        (branch "master"))
      %default-channels)
```

commit を固定する場合は、channel に `(commit "<full SHA>")` を足す。

追加したら `guix pull` で反映される。
