{-# LANGUAGE QuasiQuotes #-}

import Control.Monad ( when )
import Data.Time ( formatTime, getCurrentTime )
import Data.Time.Format ( defaultTimeLocale )
import qualified System.Console.Docopt as DO
import System.Environment ( getArgs, getProgName )
import System.Exit ( exitWith )
import System.Posix.Process ( getProcessID )
import System.Process ( system )
import Text.Printf ( printf )

import Shutils.Opts ( handleHelp, exitWithMsg )


patterns :: DO.Docopt
patterns = [DO.docopt|
Wrap shell commands in a lambda function

Usage:
  lambda [-h]
  lambda [-v | -vv] <COMMAND> [<ARG>] [<ARG>] ...

Options:
  -h, --help      This help info
  -v, --verbose   Echo back the command and args list before executing
                  Pass twice to echo back the script function as well

This is useful when you need to repeatedly modify an argument buried in the
middle of a long command. lambda lets you pull the arguments out to the end of
the command line where it's easier to edit them. It can also be used as a
`flip` function to reorder arguments.

Use the customary $1, $2... variables. Quoting can be difficult. For debugging
your commands, put 'echo ' in front of them and try running with --verbose

Example:

  $ lambda 'find $2 -name $1' *.log /var/log

The exit code will be that of COMMAND


Version 1.0  Dino Morelli <dino@ui3.info>
|]


main :: IO ()
main = do
  args <- DO.parseArgsOrExit patterns =<< getArgs
  handleHelp patterns args

  userCommand <- maybe (exitWithMsg "ERROR: COMMAND required") return
    $ DO.getArg args (DO.argument "COMMAND")

  let userArgs = DO.getAllArgs args (DO.argument "ARG")

  tempName <- mkTempName
  let script = printf "function %s() { %s; }; %s %s"
        tempName userCommand tempName (unwords userArgs)

  when (DO.isPresent args $ DO.longOption "verbose") $ do
    putStrLn $ "COMMAND: " ++ userCommand
    putStrLn $ "ARGS: " ++ (show userArgs)
    when ((DO.getArgCount args $ DO.longOption "verbose") > 1) $ do
      putStrLn $ "SCRIPT: " ++ script
    putStrLn ""

  system script >>= exitWith


mkTempName :: IO String
mkTempName = printf "%s_%s_%s"
  <$> getProgName
  <*> (show <$> getProcessID)
  <*> (formatTime defaultTimeLocale "%s" <$> getCurrentTime)
