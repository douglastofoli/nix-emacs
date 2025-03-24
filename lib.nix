{
  withPlugin = cond: plugins:
    if cond
    then plugins
    else [];
  writeIf = cond: text:
    if cond
    then text
    else "";
}
