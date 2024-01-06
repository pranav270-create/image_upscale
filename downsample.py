import matplotlib.pyplot as plt

# read in image
img = plt.imread('IMG_2806.JPG')
# reduce image by 50%
img_downsampled = img[::2, ::2, :]
# save image
plt.imsave('image.jpg', img_downsampled)
