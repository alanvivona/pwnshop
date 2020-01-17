import itertools
import string
from tqdm import tqdm

filter_chars = lambda template: filter(lambda c: chr(c) in string.printable and chr(c) not in string.whitespace, template)
template = lambda t: list(filter_chars(t))

# threshold for password generation
t = 0x5

lower_than   = lambda v: range(0x00 + t, v + 0x01 - t)
greater_than = lambda v: range(v + t, 0xff + 0x01 - t)
diff_from    = lambda v: filter(lambda c: c != v, range(0x00 + t, 0xff + 0x01 - t))

password_template = [
    template(greater_than(0x47)),
    template(lower_than(0x66)),
    template([0x56]),
    template(greater_than(0x66)),
    template(lower_than(0x33)),
    template(greater_than(0x79)),
    template(greater_than(0x38)),
    template(lower_than(0x4e)),
    template(diff_from(0x52)),
    template([0x32]),
]

print(f"How many codes should I generate?")
max_codes_q = int(input())
gen_codes_q = 0

with tqdm(total=max_codes_q) as pbar, open("./codes.txt", "wt") as f:
    for combination in itertools.product(*password_template):
        if gen_codes_q > max_codes_q:
            break
        else:
            string_rep = ''.join(map(lambda x : chr(x), combination))      
            f.write(string_rep+"\n")
            gen_codes_q += 1
            pbar.update(1)
