import re
import sys
import fileinput

# Check if a filename was provided as a command-line argument
if len(sys.argv) != 2:
    print("Usage: python script.py <input_filename>")
    sys.exit(1)

# Get the filename from the command line argument
input_filename = sys.argv[1]

# Define a regular expression pattern to match map() function calls
pattern = r'\bmap\s*\(([^)]*\n?[^)]*)\)'

# Replace map() function calls with a valid map object
def replace_map(match):
    # args = match.group(1)
    # modified_args = re.sub(r'\n\s*', '', args)
    # return f'tomap({modified_args})'

    args = match.group(1)
    # Split the arguments by commas and whitespace
    arg_list = re.split(r',\s*', args)
    new_list = []
    for i in range(0, len(arg_list)):
        if arg_list[i] != "":
            new_list.append(arg_list[i])
    # Format the arguments as a key-value object
    object_str = '\n'.join([f'{new_list[i].strip()} = {new_list[i+1].strip()}' for i in range(0, len(new_list), 2)])
    return f'{{ {object_str} }}'

# Process the input file in-place
in_map_block = False
accumulated_lines = []

with fileinput.FileInput(input_filename, inplace=True) as file:
    for line in file:
        if not in_map_block:
            # Check if the line contains the start of a map() block
            if re.search(r'\bmap\(', line):
                in_map_block = True
                accumulated_lines = [line]
            else:
                print(line, end='')
        else:
            # Accumulate lines until the end of the map() block
            accumulated_lines.append(line)
            if line.strip().endswith(')'):
                in_map_block = False
                map_block = ''.join(accumulated_lines)
                modified_map_block = re.sub(pattern, replace_map, map_block, flags=re.DOTALL)
                print(modified_map_block, end='')
            continue

print(f"File '{input_filename}' has been modified in-place.")
