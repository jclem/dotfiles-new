package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"regexp"
	"strings"
)

var symlinkMatch = regexp.MustCompile("\\.symlink$")
var undoMatch = regexp.MustCompile("n?vim(?:\\.symlink)?/files")

var symlinkAll = false
var symlinkNone = false
var homebrewAll = false
var homebrewNone = false
var homebrewCaskAll = false
var homebrewCaskNone = false

const (
	errorColor   = "\033[1;31m%s\033[0m"
	infoColor    = "\033[1;34m%s\033[0m"
	successColor = "\033[1;32m%s\033[0m"
	warnColor    = "\033[1;33m%s\033[0m"
)

// An absolute path/fileInfo struct of a file to be symlinked.
type symlink struct {
	sourcePath string
	targetPath string
}

func (s *symlink) Base() string {
	return filepath.Base(s.targetPath)
}

func (s *symlink) Create() error {
	return os.Symlink(s.sourcePath, s.targetPath)
}

func (s *symlink) Exists() (bool, error) {
	_, err := os.Stat(s.targetPath)

	if os.IsNotExist(err) {
		return false, nil
	}

	if err != nil {
		return false, err
	}

	return true, nil
}

// Install the dotfiles.
func main() {
	if err := installSymlinks(); err != nil {
		panic(err)
	}

	if err := installHomebrew(); err != nil {
		panic(err)
	}

	if err := installHomebrewRecipes(false); err != nil {
		panic(err)
	}

	if err := installHomebrewRecipes(true); err != nil {
		panic(err)
	}

	if err := installVimPlugins(); err != nil {
		panic(err)
	}

	if err := installTmuxPlugins(); err != nil {
		panic(err)
	}

	if err := installTerminfos(); err != nil {
		panic(err)
	}

	// if err := installNeovimConfig(); err != nil {
	// panic(err)
	// }
	//
	// if err := installNeovimPython(); err != nil {
	// panic(err)
	// }
	//
	// if err := installNeovimPlugins(); err != nil {
	// panic(err)
	// }

	printlnSuccess("Done!")
}

func installNeovimPlugins() error {
	printlnInfo("Installing Neovim plugins.")
	instCmd := exec.Command("nvim", "+PlugInstall", "+qa")
	instCmd.Stdin = os.Stdin
	instCmd.Stdout = os.Stdout
	if err := instCmd.Run(); err != nil {
		return err
	}

	printlnInfo("Updating remote Neovim plugins.")
	upCmd := exec.Command("nvim", "+UpdateRemotePlugins", "+qa")
	upCmd.Stdin = os.Stdin
	upCmd.Stdout = os.Stdout
	return upCmd.Run()
}

func installNeovimPython() error {
	printlnInfo("Installing Neovim Python support.")
	cmd := exec.Command("pip", "install", "--upgrade", "neovim")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func installNeovimConfig() error {
	printlnInfo("Installing Neovim config.")

	currentUser, err := user.Current()
	if err != nil {
		return err
	}

	nvimPath := filepath.Join(currentUser.HomeDir, ".config", "nvim")
	stat, err := os.Stat(nvimPath)
	if err != nil {
		return err
	}

	if stat.IsDir() {
		return nil
	}

	if err := os.MkdirAll(nvimPath, 755); err != nil {
		return err
	}

	cwd, err := os.Getwd()
	if err != nil {
		return err
	}

	sourcePath := filepath.Join(cwd, "nvim")
	return os.Symlink(sourcePath, nvimPath)
}

func installTerminfos() error {
	printlnInfo("Installing terminfos.")

	terminfos, err := filepath.Glob("./terminfos/*.terminfo")
	if err != nil {
		return err
	}

	for _, terminfo := range terminfos {
		if err := exec.Command("tic", terminfo).Run(); err != nil {
			return err
		}
	}

	return nil
}

func installTmuxPlugins() error {
	currentUser, err := user.Current()
	if err != nil {
		return err
	}

	tmuxPath := filepath.Join(currentUser.HomeDir, ".tmux", "plugins")
	stat, err := os.Stat(tmuxPath)
	if err != nil {
		return err
	}

	if stat.IsDir() {
		return nil
	}

	printlnInfo("Installing Tmux plugin manager")

	if err := os.MkdirAll(tmuxPath, 755); err != nil {
		return err
	}

	gitCmd := exec.Command("git", "clone", "https://github.com/tmux-plugins/tpm", filepath.Join(tmuxPath, "tpm"))
	gitCmd.Stdin = os.Stdin
	gitCmd.Stdout = os.Stdout
	return gitCmd.Run()
}

func installVimPlugins() error {
	instCmd := exec.Command("vim", "+PlugInstall", "+qa")
	instCmd.Stdin = os.Stdin
	instCmd.Stdout = os.Stdout
	return instCmd.Run()
}

func installHomebrew() error {
	if err := exec.Command("command", "-v", "brew").Run(); err == nil {
		return nil
	}

	printlnInfo("Installing Homebrew.")

	var install bytes.Buffer
	curlCmd := exec.Command("curl", "-fsSL", "https://raw.githubusercontent.com/Homebrew/install/master/install")
	curlCmd.Stdout = &install
	if err := curlCmd.Run(); err != nil {
		return err
	}

	instCmd := exec.Command("/usr/bin/ruby", "-e", install.String())
	if err := instCmd.Run(); err != nil {
		return err
	}

	return nil
}

func installHomebrewRecipes(fromCask bool) error {
	if fromCask {
		printlnInfo("Installing Homebrew cask recipes.")
	} else {
		printlnInfo("Installing Homebrew recipes.")
	}

	var recipePath string
	if fromCask {
		recipePath = "./homebrew-cask-recipes.txt"
	} else {
		recipePath = "./homebrew-recipes.txt"
	}

	content, err := ioutil.ReadFile(recipePath)
	if err != nil {
		return err
	}

	for _, recipe := range strings.Split(string(content), "\n") {
		if recipe == "" {
			continue
		}

		if (fromCask && homebrewCaskNone) || (!fromCask && homebrewNone) {
			printlnWarn(fmt.Sprintf("  ☆  Not installing %s.", recipe))
			continue
		}

		if (fromCask && homebrewCaskAll) || (!fromCask && homebrewAll) {
			installHomebrewRecipe(recipe, fromCask)
			continue
		}

		printWarn(fmt.Sprintf("  ☆  Install %s? [(Y)es (n)o (A)ll (N)o all (q)uit] ", recipe))

		char, err := getch()
		if err != nil {
			return err
		}

		switch char {
		case "Y":
			installHomebrewRecipe(recipe, fromCask)
		case "A":
			if fromCask {
				homebrewCaskAll = true
			} else {
				homebrewAll = true
			}
			installHomebrewRecipe(recipe, fromCask)
		case "N":
			if fromCask {
				homebrewCaskNone = true
			} else {
				homebrewNone = true
			}
			printlnWarn(fmt.Sprintf("  ☆  Not installing %s.", recipe))
		case "q":
			printlnError("Goodbye.")
			os.Exit(1)
		default:
			printlnWarn(fmt.Sprintf("  ☆  Not installing %s.", recipe))

		}
	}

	return nil
}

func installHomebrewRecipe(recipe string, fromCask bool) error {
	var cmdArgs []string
	if fromCask {
		cmdArgs = []string{"cask", "ls", "--versions", recipe}
	} else {
		cmdArgs = []string{"ls", "--versions", recipe}
	}

	if err := exec.Command("brew", cmdArgs...).Run(); err == nil {
		printlnWarn(fmt.Sprintf("  ☆  %s already installed.", recipe))
	}

	printlnInfo(fmt.Sprintf("  ☆  Installing %s.", recipe))

	var instArgs []string
	if fromCask {
		instArgs = []string{"cask", "install", recipe}
	} else {
		instArgs = []string{"install", recipe}
	}

	instCmd := exec.Command("brew", instArgs...)
	instCmd.Stdout = os.Stdout
	instCmd.Stdin = os.Stdin
	if err := instCmd.Run(); err != nil {
		return err
	}

	return nil
}

func installSymlinks() error {
	symlinks, err := getSymlinks()
	if err != nil {
		return err
	}

	printlnInfo("Installing symlinks.")

	for _, symlink := range symlinks {
		if symlinkNone {
			printlnWarn(fmt.Sprintf("  ☆  %s not linked.", symlink.Base()))
			continue
		}

		if symlinkAll {
			if err := createLink(symlink); err != nil {
				return err
			}

			continue
		}

		exists, err := symlink.Exists()
		if err != nil {
			return err
		}

		if exists {
			if err := promptForSymlink(symlink); err != nil {
				return err
			}

			continue
		}

		if err := createLink(symlink); err != nil {
			return err
		}
	}

	return nil

}

// Create a symlink.
func createLink(symlink symlink) error {
	if err := symlink.Create(); os.IsExist(err) {
		if err := os.Remove(symlink.targetPath); err != nil {
			return err
		}

		return createLink(symlink)
	}

	printlnSuccess(fmt.Sprintf("  ☆  %s linked.", symlink.Base()))

	return nil
}

// Get all symlinks in the cwd.
func getSymlinks() ([]symlink, error) {
	symlinks := make([]symlink, 0)

	cwd, err := os.Getwd()
	if err != nil {
		return nil, err
	}

	err = filepath.Walk(cwd, func(absPath string, fileInfo os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if fileInfo.IsDir() {
			if undoMatch.MatchString(absPath) {
				return filepath.SkipDir
			}

			return nil
		}

		if symlinkMatch.MatchString(absPath) {
			currentUser, err := user.Current()

			if err != nil {
				return err
			}

			fileName := fileInfo.Name()
			baseName := fmt.Sprintf(".%s", strings.TrimSuffix(fileName, filepath.Ext(fileName)))
			targetPath := filepath.Join(currentUser.HomeDir, baseName)
			symlinks = append(symlinks, symlink{absPath, targetPath})
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return symlinks, nil
}

// Prompt for whether to symlink.
func promptForSymlink(s symlink) error {
	printWarn(fmt.Sprintf("  ☆  %s already exists. Overwrite? [(Y)es (n)o (A)ll (N)o all (q)uit] ", s.Base()))

	char, err := getch()
	if err != nil {
		return err
	}

	switch char {
	case "Y":
		if err := createLink(s); err != nil {
			return err
		}
	case "A":
		symlinkAll = true
		if err := createLink(s); err != nil {
			return err
		}
	case "N":
		symlinkNone = true
		printlnWarn(fmt.Sprintf("  ☆  %s not linked.", s.Base()))
	case "q":
		printlnError("Goodbye.")
		os.Exit(1)
	default:
		printlnWarn(fmt.Sprintf("  ☆  %s not linked.", s.Base()))
	}
	return nil
}

// Get a single character.
func getch() (string, error) {
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil {
		return "", err
	}
	return string([]byte(input)[0]), nil
}

// Color printing.
func printError(s string) {
	fmt.Printf(errorColor, s)
}
func printlnError(s string) {
	printError(fmt.Sprintf("%s\n", s))
}

func printInfo(s string) {
	fmt.Printf(infoColor, s)
}

func printlnInfo(s string) {
	printInfo(fmt.Sprintf("%s\n", s))
}

func printSuccess(s string) {
	fmt.Printf(successColor, s)
}

func printlnSuccess(s string) {
	printSuccess(fmt.Sprintf("%s\n", s))
}

func printWarn(s string) {
	fmt.Printf(warnColor, s)
}

func printlnWarn(s string) {
	printWarn(fmt.Sprintf("%s\n", s))
}
