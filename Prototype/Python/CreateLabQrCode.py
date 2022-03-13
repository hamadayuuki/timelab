import qrcode
from PIL import Image

IMG_SIZE = 1024   # 2^x
TIMELAB_ICON_SIZE = 200
TIMELAB_ICON_PATH = "TIMELAB_AppIcon.png"
img = qrcode.make("0123456789", error_correction = qrcode.constants.ERROR_CORRECT_H).convert('RGB')
img = img.resize((IMG_SIZE, IMG_SIZE))

app_icon = Image.open(TIMELAB_ICON_PATH)

app_icon = app_icon.resize((TIMELAB_ICON_SIZE, TIMELAB_ICON_SIZE))
app_icon.show()

img.paste(app_icon, ((IMG_SIZE//2) - (TIMELAB_ICON_SIZE//2), (IMG_SIZE//2) - (TIMELAB_ICON_SIZE//2)))
img.save("TIMELAB_0123456789.png")
