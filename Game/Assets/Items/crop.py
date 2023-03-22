# source: https://stackoverflow.com/questions/53501331/crop-entire-image-with-the-same-cropping-size-with-pil-in-python

import os
from PIL import Image

savedir = "output"
for filename in os.listdir("input"):
    img = Image.open('input/'+filename)
    width, height = img.size

    start_pos = start_x, start_y = (0, 0)
    cropped_image_size = w, h = (16, 16)

    frame_num = 1
    for col_i in range(0, width, w):
        for row_i in range(0, height, h):
            crop = img.crop((col_i, row_i, col_i + w, row_i + h))
            save_to = os.path.join(savedir, str(frame_num)+'_'+filename)
            crop.save(save_to.format(frame_num))
            frame_num += 1
