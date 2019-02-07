"""
this program plots the Pioneer DDJ pad notes in sequence



"""


ddj_sx2_modes = [ "HOTCUE", "ROLL", "SLICER", "SAMPLER", 
                 "CUE_LOOP", "SAVED_LOOP", "SLICER_LOOP", "VELOCITY_SAMPLER" ]
ddj_1000_modes = [ "HOTCUE", "PAD_FX1", "BEAT_JUMP", "SAMPLER",
                  "KEYBOARD", "PAD_FX2", "BEAT_LOOP", "KEY_SHIFT" ]

notes="C C# D D# E F F# G G# A A# B"
notes = notes.split()

cur_note=0
cur_octave=-1
for (mode_i, (mode_st1, mode_st2)) in enumerate(zip(ddj_sx2_modes, ddj_1000_modes)):
    mode_i = (mode_i % 4) + 1
    print("\n%d: %s  ==  %s" % (mode_i, mode_st1, mode_st2))
    
    for a in range(4):
        print("   ", end="")
        for b in range(4):
            
            #print(cur_note)
            note = "%s%d" % (notes[cur_note], cur_octave)
            
            if b < 3:
                ret = "%-6s " % note
            else:
                ret = "%s" % note.strip()
            print(ret, end="")

            cur_note = cur_note + 1
            if cur_note >= len(notes):
                cur_note = 0
                cur_octave = cur_octave + 1
        print()
        if (a % 2) == 1:
            print()

    
