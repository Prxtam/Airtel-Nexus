import os
import re

def strip_selection_area(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'SelectionArea(' not in content:
        return

    print(f"Processing {filepath}")
    
    # We will find SelectionArea( and find the matching closing bracket, 
    # then remove 'SelectionArea(' and the corresponding ')' and optionally 'child: '.
    # Due to formatting, 'child: ' might be on a new line.
    
    while True:
        start_idx = content.find('SelectionArea(')
        if start_idx == -1:
            break
            
        # find matching closing parenthesis
        open_count = 0
        end_idx = -1
        for i in range(start_idx, len(content)):
            if content[i] == '(':
                open_count += 1
            elif content[i] == ')':
                open_count -= 1
                if open_count == 0:
                    end_idx = i
                    break
                    
        if end_idx == -1:
            print("ERROR: Could not find closing parenthesis!")
            break
            
        # extract the inner content between SelectionArea( and the final )
        inner_content = content[start_idx + len('SelectionArea('):end_idx]
        
        # strip the 'child:' or 'child :' part
        # usually it's "child:" optionally followed by spaces or newlines
        child_match = re.search(r'\s*child\s*:\s*', inner_content)
        if child_match and child_match.start() == 0:
            inner_content = inner_content[child_match.end():]
        elif inner_content.strip().startswith('child:'):
            # fallback
            inner_content = inner_content.strip()[6:].strip()
            
        # now replace the whole SelectionArea block with inner_content
        content = content[:start_idx] + inner_content + content[end_idx+1:]
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Updated {filepath}")

def main():
    lib_dir = r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib"
    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                strip_selection_area(os.path.join(root, file))

if __name__ == "__main__":
    main()
