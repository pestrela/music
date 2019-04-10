#!/usr/bin/python
import sys
import scipy
import numpy  
import warnings

from scipy.io.wavfile import read as wav_read
from scipy.signal import hann
from scipy.fftpack import rfft
# uncomment for debugging:
#import matplotlib.pyplot as plt

def moving_average(a, w):
  # calculate moving average
  window = numpy.ones(int(w))/float(w)
  r = numpy.convolve(a, window, 'valid')
  # len(a) = len(r) + w
  a = numpy.empty((w/2))
  a.fill(numpy.nan)
  b = numpy.empty((w-len(a)))
  b.fill(numpy.nan)
  # add nan arrays to equal input and output length
  return numpy.concatenate((a,r,b))

def find_cutoff(a, dx, diff, limit):
  for i in range(1,a.shape[0]-dx):
    if a[-i]/a[-1]>limit:
      break
    if a[-i-dx]-a[-i]>diff:
      return a.shape[0]-i-dx
  return a.shape[0]

	
# print usage if no argument given
if len(sys.argv[1:])<2:
  print 'usage %s audio_file.wav  mp3_file.mp3' % (sys.argv[0])
  sys.exit(1)

# read audio samples and ignore warnings, print errors
try:
  with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    input_data = wav_read(sys.argv[1])
    mp3_file = sys.argv[2]
		
except IOError, e:
  print e[1]
  sys.exit(e[0])

# process data
freq = input_data[0]
audio = input_data[1]
channel = 0
samples = len(audio[:,0])
seconds = int(samples/freq)

#min_seconds = 30
min_seconds = 300   # min is done on the bash script
seconds = min(seconds,min_seconds)
spectrum = [0] * freq

# run over the seconds (max 30)
for t in range(0,seconds-1):
  # apply hanning window
  window = hann(freq)
  audio_second = audio[t*freq:(t+1)*freq,channel] * window
  # do fft to add second to frequency spectrum
  spectrum += abs(rfft(audio_second))

# calculate average of the spectrum
spectrum /= seconds
# normalize frequency spectrum
spectrum = scipy.log10(spectrum)
# smoothen frequency spectrum with window w
spectrum = moving_average(spectrum,freq/100)
# find cutoff in frequency spectrum
cutoff = find_cutoff(spectrum,freq/50,1.25,1.1)

# print bit rate of frequency spectrum before cutoff
#print '%s kHz' % (cutoff/2000)
#print '(%s kHz)' % (cutoff/2000.0)

cutoff2 = (cutoff/2000.0)
#print '%s:    %.1f kHz' % (mp3_file, cutoff2)
print '%.1f khz' % (cutoff2)


if False:
	if (cutoff/2000) == 11:
		print '64 kbps'
	elif (cutoff/2000) == 16:
		print '128 kbps'
	elif (cutoff/2000) == 19:
		print '192 kbps'
	elif (cutoff/2000) == 20:
		print '320 kbps'
	elif (cutoff/2000) == 22:
		print '500 kbps'
	elif (cutoff*100)/freq > 90:
		print 'lossless'
	else:
		print """
		11 kHz: 64 kbps
		16 kHz: 128 kbps
		19 kHz: 192 kbps
		20 kHz: 320 kbps
		22 kHz: 500 kbps
		"""

	# debugging only:
	if globals().has_key('plt'):
		# plot
		plt.plot(spectrum)
		# label the axes
		plt.ylabel("Magnitude")
		plt.xlabel("Frequency")
		# set the title
		plt.title("Spectrum")
		plt.axis((0,45000,0,10))
		plt.show()

    
    
    
