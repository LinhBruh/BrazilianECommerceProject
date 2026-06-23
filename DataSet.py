import kagglehub
import os
import shutil
# Download latest version
path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
des_dir = "BrazilianECommerceProject"
shutil.move(path,des_dir)
