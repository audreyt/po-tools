{-# LANGUAGE OverloadedStrings #-}
import Data.Text (Text)
import System.IO
import System.Environment (getArgs, getProgName)
import Control.Monad (forM_)
import qualified Data.Text as T
import qualified Data.Text.IO as T

main = do
    txtFiles <- getArgs
    if null txtFiles then usage else forM_ txtFiles $ \file -> withFile file ReadMode $ \h -> do
        hSetNewlineMode h universalNewlineMode
        txt <- T.hGetContents h
        T.writeFile (file ++ ".po") $ T.concat $ map formatChunk . tail $ T.splitOn "[[[" txt
        hPutStrLn stderr $ "*** Written PO file: " ++ file ++ ".po"

(<>) = T.append
formatChunk :: Text -> Text
formatChunk chunk = "msgid \"" <> T.strip id <> "\"\n"
                 <> "msgstr \"" <> T.strip (T.drop 3 str) <> "\"\n\n"
    where
    (id, str) = T.breakOn "]]]" chunk

usage = do
    prog <- getProgName
    putStrLn $ "Usage: " ++ prog ++ " file.txt [file.txt...]"
