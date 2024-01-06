from transformers import Swin2SRForImageSuperResolution
from PIL import Image
from transformers import Swin2SRImageProcessor
import torch
import numpy as np

model = Swin2SRForImageSuperResolution.from_pretrained("caidas/swin2SR-classical-sr-x2-64")
image = Image.open("image.jpg")
processor = Swin2SRImageProcessor()

pixel_values = processor(image, return_tensors="pt").pixel_values
print(pixel_values.shape)

with torch.no_grad():
    outputs = model(pixel_values)

output = outputs.reconstruction.data.squeeze().float().cpu().clamp_(0, 1).numpy()
output = np.moveaxis(output, source=0, destination=-1)
output = (output * 255.0).round().astype(np.uint8)  # float32 to uint8
image = Image.fromarray(output)
# show image
image.show()
image.save("output.jpg")
