{-# LANGUAGE DeriveDataTypeable #-}
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util
import Data.Set
import Data.Typeable
import Control.Exception

data SlideException = SlidesNotFound { msg :: String }
     deriving (Show, Typeable)

instance Exception SlideException

tgz :: String
tgz = "tgz"

main :: IO ()
main =
  shakeArgs shakeOptions{shakeFiles="_build/"} $ do
    want ["images/ghc-clojure" <.> tgz]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    "images/ghc-clojure.tgz" *> \image -> do
        need ["ghc-clojure/Dockerfile"] 
        () <- cmd "docker build -t atddio/ghc-clojure ghc-clojure"
        cmd "docker save -o " [image] "atddio/ghc-clojure"
