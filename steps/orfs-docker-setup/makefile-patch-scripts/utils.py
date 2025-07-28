import os
import shutil
import re 

def replace_in_file(filepath, replacements):
    with open(filepath, 'r') as file:
        content = file.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
    
    with open(filepath, 'w') as file:
        file.write(content)

def comment_out_line(filepath, line_to_comment):
    with open(filepath, 'r') as file:
        lines = file.readlines()
    
    with open(filepath, 'w') as file:
        for line in lines:
            if line.strip() == line_to_comment.strip():
                file.write(f'# {line}')
            else:
                file.write(line)

def replace_line_in_file(filepath, old_line, new_line):
    with open(filepath, 'r') as file:
        lines = file.readlines()
    
    with open(filepath, 'w') as file:
        for line in lines:
            if line.strip() == old_line.strip():
                file.write(new_line + '\n')
            else:
                file.write(line)

def comment_out_and_add_line(filepath, line_to_comment, new_line):
    with open(filepath, 'r') as file:
        lines = file.readlines()
    
    with open(filepath, 'w') as file:
        for line in lines:
            if line.strip() == line_to_comment.strip():
                # Write the commented-out line
                file.write(f'# {line}')
                # Write the new line immediately after the commented-out line
                file.write(new_line + '\n')
            else:
                # Write the original line if it doesn't match the line to comment
                file.write(line)

def delete_word_in_a_line(filepath, target_line, word_to_delete):
    # Use a regex pattern to split by both spaces and tabs
    pattern = r'(\s+)'

    with open(filepath, 'r') as file:
        lines = file.readlines()
    
    with open(filepath, 'w') as file:
        for line in lines:
            if line.strip() == target_line.strip():
                # Use re.split to split by spaces and tabs, preserving delimiters
                parts = re.split(pattern, line)
                # Reconstruct the line, removing the specified word but preserving whitespace
                new_line = ''.join([part for part in parts if part.strip() != word_to_delete])
                file.write(new_line)
            else:
                file.write(line)

def copy_after_target(src_filepath, dest_filepath, target_name):
    with open(src_filepath, 'r') as src_file:
        src_lines = src_file.readlines()
    
    with open(dest_filepath, 'r') as dest_file:
        dest_lines = dest_file.readlines()
    
    target_start = None
    target_end = None

    for i, line in enumerate(dest_lines):
        if line.strip().startswith(target_name + ":"):
            target_start = i
            break
    
    if target_start is not None:
        for i in range(target_start + 1, len(dest_lines)):
            if dest_lines[i].strip() and not dest_lines[i].startswith("\t"):
                target_end = i
                break
        if target_end is None:
            target_end = len(dest_lines)
    
        with open(dest_filepath, 'w') as dest_file:
            for i, line in enumerate(dest_lines):
                dest_file.write(line)
                if i == target_end - 1:
                    dest_file.write("\n")  # Add one line of space before copying the content
                    for src_line in src_lines:
                        dest_file.write(src_line)
                    dest_file.write("\n")  # Add one line of space after copying the content
    else:
        raise ValueError(f"Target '{target_name}' not found in {dest_filepath}")

def add_line_next_to_specific_line(file_name, match_line, new_line):
    # Read the content of the file
    with open(file_name, 'r') as file:
        lines = file.readlines()

    # Open the file in write mode to update its content
    with open(file_name, 'w') as file:
        for i, line in enumerate(lines):
            file.write(line)
            if line.strip() == match_line:
                file.write(new_line + '\n')

def add_lines_next_to_specific_line(file_name, match_line, new_lines):
    # Read the content of the file
    with open(file_name, 'r') as file:
        lines = file.readlines()

    # Open the file in write mode to update its content
    with open(file_name, 'w') as file:
        for i, line in enumerate(lines):
            file.write(line)
            if line.strip() == match_line:
                for new_line in new_lines:
                    file.write(new_line + '\n')