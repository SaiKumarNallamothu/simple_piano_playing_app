import wave
import math
import struct
import os

def generate_piano_note(filename, frequency, duration=2.2, sample_rate=44100):
    num_samples = int(sample_rate * duration)
    wav_file = wave.open(filename, 'w')
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)
    
    data = bytearray()
    
    for i in range(num_samples):
        t = i / sample_rate
        
        if t < 0.005:
            envelope = t / 0.005
        else:
            envelope = math.exp(-2.2 * (t - 0.005))
            
        val = 0.60 * math.sin(2 * math.pi * frequency * t)
        val += 0.25 * math.sin(2 * math.pi * frequency * 2 * t) * math.exp(-1.0 * t)
        val += 0.10 * math.sin(2 * math.pi * frequency * 3 * t) * math.exp(-2.0 * t)
        
        sample_val = val * envelope * 24000.0
        sample_val = max(-32767, min(32767, int(sample_val)))
        
        data.extend(struct.pack('<h', sample_val))
        
    wav_file.writeframes(data)
    wav_file.close()

# 88 Piano Notes from A0 (MIDI 21) to C8 (MIDI 108)
note_names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

output_dir = 'assets/sounds'
os.makedirs(output_dir, exist_ok=True)

print("Synthesizing 88 piano notes (A0 to C8)...")

for midi in range(21, 109):
    # A0 is midi 21
    # n = midi - 69 (A4 is midi 69, 440Hz)
    freq = 440.0 * (2.0 ** ((midi - 69) / 12.0))
    
    # Calculate note name and octave
    # MIDI 12 is C0
    octave = (midi // 12) - 1
    name_idx = midi % 12
    name_str = note_names[name_idx].lower().replace('#', 's')
    note_id = f"{name_str}{octave}"
    
    wav_path = os.path.join(output_dir, f"{note_id}.wav")
    generate_piano_note(wav_path, freq)

print("88 piano notes synthesized successfully!")
