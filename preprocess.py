import sys
import nltk
nltk.download('punkt')

for line in sys.stdin:
    for sentence in nltk.sent_tokenize(line):
        print(' '.join(nltk.word_tokenize(sentence)).lower())
