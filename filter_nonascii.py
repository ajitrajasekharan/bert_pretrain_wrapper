import pdb
import sys
import string

#This is purely for generating vocab only to avoid just numbers in vocab. Note nunmber char mix will go through - e.g.  cd80



preserve_str="£¥§©®¯°±²³´µ·¹º¼½×ß÷øɑɛ˂˙˚˜΄αβγδεζηθικλμνξοπρστυφχψωϕϵабвгез׳،‐‑‒–—‘’“”„†‡‰′″⁰⁴⁵⁶⁷⁸⁹⁺⁻₀₁₂₃₄₅₆₇₈₉₋€™∈∑−∓∕∗∘∙√∝∞∶∼≃≈≡≤≥≦≧≪≫≲⊥⋅⋯═♀♂⟨⟩⩽⩾、。％（），－：；＜＞［］～±×™фэ≥∕ー⩾δω⁺юβμ≤⋅бκατ═ε₃≈£→₆₅đσ¬´€−ﬁ₄¹ηφłء½χ²₁¯øъœµ⋯ϕυρολ∶⁹º©∆∘⁶₇₉₀π₋⁸⁰⩽⁵₈≡～٠١≃∥¼⊥˙θ∝≫∈ɑ↑÷←˚⁷ﬂ＞♀↔ⅰℓ≧ɛⅲ△♂√≲˜æ˂∞¥ĸіζ＜≪΄٢≦し●ⅳμμен°°اов±ββра±⋯±±≥μβногоβкоприا≥αа±≥±±≥и±±≥и≥°°±°µ"
def remove_nonascii(word):
    arr = []
    for i in range(len(word)):
        if (ord(word[i]) >= 128 and word[i] not in preserve_str):
                arr.append(' ')
        else:
            arr.append(word[i])
    return ''.join(arr)  

def filter_numeric(file_name,vocab_filter):
    with open(file_name,"r") as fp:
        for line in fp:
            punct_line = []
            for ch in line:
                if (ch in string.punctuation or ord(ch) >= 128):
                    punct_line.append(" " + ch + " ")
                else:
                    punct_line.append(ch)
            line = ''.join(punct_line) 
            words = line.split()
            out_words = []
            for word in words:
                word = remove_nonascii(word)
                if (vocab_filter and (word.isdigit() or word.replace('.','').isdigit())):
                    continue
                words_arr = word.split()
                for i in words_arr:
                    out_words.append(i)
            if (vocab_filter):
                    final_words = []
                    for word in out_words:
                        if (word.isdigit() or word.replace('.','').isdigit()):
                            continue
                        final_words.append(word)
                    out_words  = final_words
            print(' '.join(out_words))
                  


if __name__ == "__main__":
    if (len(sys.argv) != 3):
        print("prog <input file_name> 0-vocab filter; 1 -main filter")
    else:
        filter_numeric(sys.argv[1],(int(sys.argv[2]) == 0))
            
