import wave
import math
import struct
import os

def generate_piano_note(filename, frequency, duration=2.5, sample_rate=44100):
    num_samples = int(sample_rate * duration)
    wav_file = wave.open(filename, 'w')
    wav_file.setnchannels(2) # Stereo for max mobile player compatibility
    wav_file.setsampwidth(2) # 16-bit PCM
    wav_file.setframerate(sample_rate)
    
    data = bytearray()
    
    for i in range(num_samples):
        t = i / sample_rate
        
        # Exponential attack and decay envelope
        if t < 0.005:
            envelope = t / 0.005
        else:
            envelope = math.exp(-2.5 * (t - 0.005))
            
        # Rich harmonic tones
        val = 0.55 * math.sin(2 * math.pi * frequency * t)
        val += 0.25 * math.sin(2 * math.pi * frequency * 2 * t) * math.exp(-0.8 * t)
        val += 0.12 * math.sin(2 * math.pi * frequency * 3 * t) * math.exp(-1.5 * t)
        val += 0.08 * math.sin(2 * math.pi * frequency * 4 * t) * math.exp(-2.5 * t)
        
        sample_val = val * envelope * 28000.0
        sample_val = max(-32767, min(32767, int(sample_val)))
        
        # Pack left and right channels
        packed = struct.pack('<h', sample_val)
        data.extend(packed)
        data.extend(packed)
        
    wav_file.writeframes(data)
    wav_file.close()

notes_freq = {
    # Octave 3
    'c3': 130.81, 'cs3': 138.59, 'd3': 146.83, 'ds3': 155.56,
    'e3': 164.81, 'f3': 174.61, 'fs3': 185.00, 'g3': 196.00,
    'gs3': 207.65, 'a3': 220.00, 'as3': 233.08, 'b3': 246.94,
    # Octave 4
    'c4': 261.63, 'cs4': 277.18, 'd4': 293.66, 'ds4': 311.13,
    'e4': 329.63, 'f4': 349.23, 'fs4': 369.99, 'g4': 392.00,
    'gs4': 415.30, 'a4': 440.00, 'as4': 466.16, 'b4': 493.88,
    # Octave 5
    'c5': 523.25
}

output_dir = 'assets/sounds'
os.makedirs(output_dir, exist_ok=True)

for note, freq in notes_freq.items():
    filepath = os.path.join(output_dir, f'{note}.wav')
    print(f"Generating stereo {filepath} ({freq} Hz)...")
    generate_piano_note(filepath, freq)

print("Audio stereo wave generation complete!")
