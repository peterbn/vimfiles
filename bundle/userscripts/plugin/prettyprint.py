import vim
import re


# Regular expressions used by script
tagRe = re.compile(R'<.*?>', re.DOTALL)
whitespace = re.compile(R'^\s*$')


def prettyPrint():
  # Get the contents as a single string
  contents = "\n".join(vim.current.buffer[:] )

  formatted = [] # Buffer to contain the new lines
  level = 0 # Current indent level
  while len(contents) > 0: # Iterate while w
    tag = tagRe.search(contents)
    if tag is None:
      append(formatted, level,contents)
      contents = ""
    else:
      tagIndex = tag.start()
      append(formatted, level, contents[:tagIndex])
      contents = contents[tagIndex:]
      match = tag.group(0)
      matchLen = len(match)

      # Peek at the matched string to determine what we're dealing with
      if match[1] == '!' and match[2] == '[':
        mode = 'cdata'
      elif match[1] == "?" or match[1] == "!":
        mode = 'literal'
      elif match[1] == "/": 
        mode = 'end'
      elif match[-2] == "/":
        mode = 'empty'
      else:
        mode = 'start' # Default to start tag

      if mode == 'end':
        level -= 1 # Remove indentation before printing end tag

      # Print tag (CDATA should not be normalized)
      if mode == 'cdata':
        append(formatted, level, match)
      else:
        append(formatted, level, normalizeTagString(match))

      if mode == 'start':
        level += 1 # Increase indentation after printing start tag

      if level < 0:
        level = 0 # Reset indentation to zero if it has fallen below 

      contents = contents[matchLen:] # Snip off the buffer 

  # Done with looping through buffer
  # Delete contents and replace with formatted text
  del vim.current.buffer[:]
  for s in formatted:
    vim.current.buffer.append(s)

  del vim.current.buffer[0] # Delete initial blank line
  return 'Formatted ' + str(len(vim.current.buffer)) + ' lines'

def normalizeTagString(string):
  return re.sub('\s+',' ',re.sub('\n', ' ',string))

def append(formatted, level, string):
  newString = indent(level, string)
  if not whitespace.match(newString):
    for s in newString.split('\n'):
      formatted.append(s)


def indent(level, string):
  if level >= 0:
    return (' ' * 4 * level) + string.strip()
  else:
    return string.strip()

#Call the main function
prettyPrint()
