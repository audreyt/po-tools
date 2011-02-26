{-# LANGUAGE OverloadedStrings #-}
import Data.Text (Text)
import System.IO
import System.Environment (getArgs, getProgName)
import Control.Monad (forM_)
import Data.List (partition)
import qualified Data.Text as T
import qualified Data.Text.IO as T

type Lexicon = [Msg]
data Msg = MkMsg { msgId :: !Text, msgStr :: !Text } deriving Show

main = do
    poFiles <- getArgs
    if null poFiles then usage else forM_ poFiles $ \file -> withFile file ReadMode $ \h -> do
        hSetNewlineMode h universalNewlineMode
        po <- T.hGetContents h
        let (untranslated, translated) = partition (T.null . msgStr) lexicon
            lexicon = filter (not . T.null . msgId) $ parsePo po
        -- Untranslated entries go to .new.txt
        writeText (file ++ ".new.txt") formatNew untranslated
        hPutStrLn stderr $ "*** Written TXT file: " ++ file ++ ".new.txt"
        -- Untranslated entries go to .ref.txt
        writeText (file ++ ".ref.txt") formatRef translated
        hPutStrLn stderr $ "*** Written TXT file: " ++ file ++ ".ref.txt"

parsePo :: Text -> Lexicon
parsePo = map parseMsg . T.splitOn "\n\n"

parseMsg :: Text -> Msg
parseMsg text = MkMsg (T.concat $ map parsePart id) (T.concat $ map parsePart str)
    where
    msg = dropWhile (withPrefix "msgid ") $ T.lines text
    (id, str) = span (withPrefix "msgstr ") msg
    withPrefix = (not .) . T.isPrefixOf

parsePart :: Text -> Text
parsePart = T.init . T.tail . T.dropAround (/= '"')

(<>) = T.append
formatNew (MkMsg i _) = "[[[" <> i <> "]]]\n" <> i <> "\n\n"
formatRef (MkMsg i s) = i <> "\n" <> s <> "\n\n"

writeText :: FilePath -> (Msg -> Text) -> Lexicon -> IO ()
writeText file format msgs = withFile file WriteMode $ \h -> do
    hSetNewlineMode h (NewlineMode CRLF CRLF)
    T.hPutStr h . T.concat $ map format msgs

usage = do
    prog <- getProgName
    putStrLn $ "Usage: " ++ prog ++ " file.po [file.po...]"
