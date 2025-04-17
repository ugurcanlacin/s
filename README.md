# s - fast command search and execution

Tired of typing `history | grep -i "something"` and then copying and pasting commands? This tiny shell function is here to help! Just type `s docker` or `s git push` and it will show you all matching commands from your history. Pick a number, press enter, and boom - your command is running. No more copy-paste hassle!

## Features

- 🔍 Search through command history with case-insensitive matching
- 🎯 Supports up to 3 search terms for precise filtering
- 🔄 Removes duplicate commands from results
- 📝 Interactive numbered list for easy command selection
- ✨ Works with both Bash and Zsh shells

## Installation

One-line installation:
```bash
curl -o- https://raw.githubusercontent.com/ugurcanlacin/s/main/install.sh | bash
```

Or manually:
1. Clone the repository: `git clone https://github.com/ugurcanlacin/s.git`
2. Navigate to the directory: `cd s`
3. Make the script executable: `chmod +x install.sh`
4. Run the installation: `./install.sh`

## Usage

The function is called with `s` followed by up to three search terms:

```bash
s [search_term1] [search_term2] [search_term3]
```

### Examples

1. Basic search:
```bash
$ s docker
  1) docker ps
  2) docker images
  3) docker-compose up -d
Enter number to execute (or press Enter to cancel):
```

2. Multiple terms to narrow down results:
```bash
$ s git commit
  1) git commit -m "initial commit"
  2) git commit --amend
Enter number to execute (or press Enter to cancel):
```

3. Search with specific flags or parameters:
```bash
$ s npm install express
  1) npm install express --save
  2) npm install express-session
Enter number to execute (or press Enter to cancel):
```

## How It Works

1. When you run the `s` command with search terms, it searches through your shell history
2. It filters out duplicate commands and displays unique matches
3. Each matching command is displayed with a number
4. You can execute any command by entering its number
5. Pressing Enter without a number cancels the operation

## Tips

- Use more specific search terms to narrow down results
- The search is case-insensitive for better matching
- You can use partial commands or arguments as search terms
- The function maintains command integrity by executing exactly what you see

## Contributing

Feel free to submit issues and enhancement requests!

PS: This repo is entirely vibe coded.