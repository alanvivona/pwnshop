import collections
import logging

def hamming_distance(bv1, bv2):
    if len(bv1) != len(bv2):
        raise Exception("Inputs should be of same length")
    distance = 0
    for i in range(len(bv1)):
        if bv1[i] != bv2[i]:
            distance += 1 
    return distance

def get_keysizes(keysize_start, keysize_end, input_b):
    keysizes = []
    for keysize in range(keysize_start, keysize_end+1):
        samples = []
        for i in range(keysize, len(input_b), keysize):
            samples.append(input_b[i-keysize:i])    

        distances = []
        for i in range(1,len(samples)):
            distances.append(hamming_distance(samples[i-1], samples[i]))
        distance = sum(distances)/(len(distances)*keysize)
        keysizes.append({'size': keysize, 'distance': distance})
    
    keysizes.sort(key=lambda x: x['distance'])
    return keysizes

def transpose(input_b, keysize):
    blocks = [ b'' for _ in range(0, keysize) ]
    logging.debug(f"Transposing input into {keysize} blocks")

    for i, b in enumerate(input_b):
        blocks[i%keysize] += bytes([b])
    logging.debug(f"Got {len(blocks)} blocks")
    return blocks

def xor_cipher(key_b, input_b):     
    xored_msg = b''
    for i, b in enumerate(input_b):
        # print(f"{key_b} >> {len(key_b)} [{i}]")
        xor_r = b ^ key_b[i%len(key_b)]
        xored_msg += bytes([xor_r])

    return xored_msg, key_b

def bruteforce_xor(input_b):
    key_start = 0x00
    key_end = 0x100
    scored = []
    for key in range(key_start, key_end):
        out, _ = xor_cipher([key], input_b)
        scored.append({'key': key, 'score':english_score(out)})
    return sorted(scored, key=lambda x: x['score'], reverse=True)


def english_score(input_b):
    
    symbol_freq = {
        # https://en.wikipedia.org/wiki/Letter_frequency
        'a': 8.167, 'b': 1.492, 'c': 2.782, 'd': 4.253,
        'e': 12.702,'f': 2.228, 'g': 2.015, 'h': 6.094,
        'i': 6.094, 'j': 0.153, 'k': 0.772, 'l': 4.025,
        'm': 2.406, 'n': 6.749, 'o': 7.507, 'p': 1.929,
        'q': 0.095, 'r': 5.987, 's': 6.327, 't': 9.056,
        'u': 2.758, 'v': 0.978, 'w': 2.360, 'x': 0.150,
        'y': 1.974, 'z': 0.074,

        # https://en.wikipedia.org/wiki/Punctuation_of_English#Frequency
        ".": 0.653,
        ",": 0.613,
        ";": 0.032,
        ":": 0.034,
        "!": 0.033,
        "?": 0.056,
        "'": 0.243,
        '"': 0.267,
        "-": 0.153,

        # http://www.data-compression.com/english.html
        " ": 0.1918182,

    }

    word_freq = {
        "the": 7.14, "of": 4.16, "and": 3.04, "to": 2.60, "in": 2.27, "a": 2.06, "is": 1.13, "that": 1.08, "for": 0.88, "it": 0.77, "as": 0.77, "was": 0.74, "with": 0.70, "be": 0.65, "by": 0.63, "on": 0.62, "not": 0.61,
        "he": 0.55, "i": 0.52, "this": 0.51, "are": 0.50, "or": 0.49, "his": 0.49, "from": 0.47, "at": 0.46, "which": 0.42, "but": 0.38, "have": 0.37, "an": 0.37, "had": 0.35, "they": 0.33, "you": 0.31, "were": 0.31, "their": 0.29,
        "one": 0.29, "all": 0.28, "we": 0.28, "can": 0.22, "her": 0.22, "has": 0.22, "there": 0.22, "been": 0.22, "if": 0.21, "more": 0.21, "when": 0.20, "will": 0.20, "would": 0.20, "who": 0.20, "so": 0.19, "no": 0.19,
    }

    word_size_freq = {
        1:   0.027,
        2:   0.679,
        3:   4.730,
        4:   7.151,
        5:   10.804,
        6:   13.674,
        7:   14.751,
        8:   13.616,
        9:   11.356,
        10:  8.679,
        11:  5.913,
        12:  3.792,
        13:  2.329,
        14:  1.232,
        15:  0.685,
        16:  0.290,
        17:  0.162,
        18:  0.066,
        19:  0.041,
        20:  0.016,
        21:  0.001,
        22:  0.005,
        23:  0.002,
    }
    
    symbol_score = sum([symbol_freq.get(chr(b), 0) for b in input_b.lower()])

    words = input_b.lower().split(b" ")
    word_score = sum([word_freq.get(str(w), 0) for w in words])

    word_size_score = sum([word_size_freq.get(len(w), 0) for w in words])

    return symbol_score + word_score + word_size_score
