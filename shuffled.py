import fileinput

def is_shuffled(left, right, combined):
  return any(helper(left, right, combined))

def helper(left, right, combined):
  if left and right and combined and left[0] is combined[0] and right[0] is combined[0]:
    return helper(left[1:], right, combined[1:]) + helper(left, right[1:], combined[1:])
  if left and combined and left[0] is combined[0]:
    return helper(left[1:], right, combined[1:])
  if right and combined and right[0] is combined[0]:
    return helper(left, right[1:], combined[1:])
  if not left and not right and not combined:
    return [True]
  return [False]

left, right, combined, *foo = fileinput.input()
result = is_shuffled(left.split(),right.split(),combined.split())
print(result)
