import os
import sys

top_dir = os.getcwd()
eval_str = " ".join(sys.argv[1:])

if __name__ == "__main__":
    print (eval(eval_str))
