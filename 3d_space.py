import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv(
    'results/measure-stats-spreadsheet.csv',
    sep=',',
    quotechar='"',
    header=0,
    on_bad_lines='warn',
    low_memory=False,
)
print(data)

#print(data.iloc[0, :])
#print(data.iloc[-1, :])

count_mouses = np.array(data.loc[:, 'count mouses'], dtype=np.int32)
count_cats = np.array(data.loc[:, 'count cats'], dtype=np.int32)
count_sunflowers = np.array(data.loc[:, 'count sunflowers'], dtype=np.int32)

# Mouse-Cat-Sunflower 3D space
ax = plt.subplot(projection='3d')
ax.plot3D(count_mouses, count_cats, count_sunflowers)
ax.set_xlabel('Mouses')
ax.set_ylabel('Cats')
ax.set_zlabel('Sunflowers')
ax.set_title('Mouse-Cat-Sunflower 3D space')

# show plots
plt.show()