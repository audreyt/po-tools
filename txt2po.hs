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
        T.writeFile (file ++ ".po") $ standardHeader <> (T.concat $ map formatChunk . tail $ T.splitOn "[[[" txt)
        hPutStrLn stderr $ "*** Written PO file: " ++ file ++ ".po"

standardHeader = T.concat
    [ "msgid \"\""
    , "msgstr \"\""
    , "\"Project-Id-Version: RT 3.8.x\\n\""
    , "\"Report-Msgid-Bugs-To: \\n\""
    , "\"POT-Creation-Date: 2010-04-27 03:03+0000\\n\""
    , "\"PO-Revision-Date: 2010-10-31 23:53+0000\\n\""
    , "\"Last-Translator: sunnavy <sunnavy@gmail.com>\\n\""
    , "\"Language-Team: rt-devel <rt-devel@lists.bestpractical.com>\\n\""
    , "\"Language: \\n\""
    , "\"MIME-Version: 1.0\\n\""
    , "\"Content-Type: text/plain; charset=UTF-8\\n\""
    , "\"Content-Transfer-Encoding: 8bit\\n\""
    ]

(<>) = T.append
formatChunk :: Text -> Text
formatChunk chunk = "msgid \"" <> T.strip id <> "\"\n"
                 <> "msgstr \"" <> T.strip (T.drop 3 str) <> "\"\n\n"
    where
    (id, str) = T.breakOn "]]]" chunk

usage = do
    prog <- getProgName
    putStrLn $ "Usage: " ++ prog ++ " file.txt [file.txt...]"
